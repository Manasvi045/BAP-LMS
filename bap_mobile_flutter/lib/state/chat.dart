// lib/state/chat.dart — chat state + send/stream, mirroring src/hooks/useChat.ts.
//
// Phase 5: when ACTIVE_PROVIDER is "openrouter", send() builds an RAG system
// prompt from the live content tree, hits OpenRouter's SSE endpoint, and
// streams the reply token-by-token. The placeholder branch remains for
// dev/demo without a key.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';
import '../services/assistant/api.dart';
import '../services/assistant/context.dart';
import '../services/assistant/key_store.dart';
import '../services/assistant/provider.dart';
import '../state/nav.dart';

/// Welcome message shown on first open.
const ChatMessage chatWelcome = ChatMessage(
  role: ChatRole.bot,
  text:
      "Hi! I'm your BAP study assistant. Ask me about any vertical, topic, or product — or tap a suggestion below to get started.",
);

/// Last error from a send() call.
@immutable
class ChatError {
  final String code;
  final String message;
  const ChatError(this.code, this.message);
}

/// Pure-Dart chat controller. The notifier owns the message list, the
/// streaming state, the error, and `hasKey`. send() / stop() / reset() are
/// the public surface used by the chat screen.
class ChatNotifier extends ChangeNotifier {
  final NavTarget Function() currentScreen;
  final KeyStore keyStore;

  ChatNotifier({required this.currentScreen, required this.keyStore}) {
    _probeKey();
  }

  final List<ChatMessage> _messages = <ChatMessage>[chatWelcome];
  bool _thinking = false;
  String _streamingText = '';
  ChatError? _error;
  bool _hasKey = false;
  Timer? _placeholderTimer;
  StreamSubscription<String>? _streamSub;
  http.Client? _streamClient;

  List<ChatMessage> get messages => List<ChatMessage>.unmodifiable(_messages);
  bool get thinking => _thinking;
  String get streamingText => _streamingText;
  ChatError? get error => _error;
  bool get hasKey => _hasKey;

  Future<void> _probeKey() async {
    try {
      final v = await keyStore.has();
      _hasKey = v;
      notifyListeners();
    } catch (_) {
      _hasKey = false;
      notifyListeners();
    }
  }

  Future<void> refreshHasKey() async {
    await _probeKey();
  }

  void reset() {
    _placeholderTimer?.cancel();
    _streamSub?.cancel();
    _streamClient?.close();
    _streamClient = null;
    _streamSub = null;
    _messages
      ..clear()
      ..add(chatWelcome);
    _streamingText = '';
    _thinking = false;
    _error = null;
    notifyListeners();
  }

  void stop() {
    if (_streamSub != null) {
      _streamSub!.cancel();
      _streamSub = null;
      _streamClient?.close();
      _streamClient = null;
      // Keep partial text on abort (matches React behaviour).
      if (_streamingText.isNotEmpty) {
        _messages.add(ChatMessage(role: ChatRole.bot, text: '$_streamingText\n\n_(stopped)_'));
      }
      _streamingText = '';
      _thinking = false;
      notifyListeners();
      return;
    }
    _placeholderTimer?.cancel();
    _placeholderTimer = null;
    _thinking = false;
    notifyListeners();
  }

  /// Send a user message. In placeholder mode, replies with a canned string
  /// after a short delay. In openrouter mode, streams a real reply token-by-
  /// token from OpenRouter.
  void send(String text) {
    final clean = text.trim();
    if (clean.isEmpty || _thinking) return;
    _error = null;
    _messages.add(ChatMessage(role: ChatRole.user, text: clean));
    _streamingText = '';
    _thinking = true;
    notifyListeners();

    if (activeProvider == AssistantProvider.placeholder || !_hasKey) {
      _placeholderTimer = Timer(
          Duration(milliseconds: 600 + (DateTime.now().millisecondsSinceEpoch % 400)), () {
        _messages.add(ChatMessage(role: ChatRole.bot, text: _placeholderReply(clean)));
        _thinking = false;
        notifyListeners();
      });
      return;
    }

    _sendOpenRouter(clean);
  }

  Future<void> _sendOpenRouter(String userText) async {
    final key = await keyStore.get();
    if (key == null || key.isEmpty) {
      _error = const ChatError('no_key', 'No API key set');
      _thinking = false;
      notifyListeners();
      return;
    }

    final history = <({WireRole role, String text})>[];
    for (final m in _messages) {
      final role = m.role == ChatRole.user ? WireRole.user : WireRole.assistant;
      history.add((role: role, text: m.text));
    }
    // Drop the welcome message if it's the very first item and has no
    // substantive content; not strictly necessary but matches React.
    final systemPrompt = buildSystemPrompt(AssistantContext(currentScreen: currentScreen()));
    final wireMessages = buildRequestMessages(history, systemPrompt, userText);

    final client = http.Client();
    _streamClient = client;
    final stream = streamChat(StreamOptions(apiKey: key, messages: wireMessages, client: client));

    _streamSub = stream.listen(
      (delta) {
        _streamingText = '$_streamingText$delta';
        notifyListeners();
      },
      onError: (Object e) {
        _streamSub = null;
        _streamClient = null;
        if (e is AssistantError) {
          _error = ChatError(e.code, e.message);
        } else {
          _error = ChatError('network', e.toString());
        }
        _thinking = false;
        _streamingText = '';
        notifyListeners();
      },
      onDone: () {
        _streamSub = null;
        _streamClient = null;
        if (_streamingText.isNotEmpty) {
          _messages.add(ChatMessage(role: ChatRole.bot, text: _streamingText));
        }
        _streamingText = '';
        _thinking = false;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

  static String _placeholderReply(String text) {
    return 'You asked: "$text".\n\nThis assistant is a preview — live answers aren\'t '
        "connected yet. Once wired up, I'll pull from the BAP course content to "
        'explain concepts, quiz you, and track weak spots.';
  }
}