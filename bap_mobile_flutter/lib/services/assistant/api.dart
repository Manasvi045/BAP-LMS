// lib/services/assistant/api.dart — OpenRouter chat-completions client.
// 1:1 port of src/lib/assistant/api.ts.
//
// OpenAI-compatible: {model, messages, stream}. SSE response:
//   data: {"choices":[{"delta":{"content":"..."}}]}\n\n
//   data: [DONE]\n\n
//
// Errors:
//   401 → invalid key
//   404 → model not found
//   429 → rate limited
//   5xx → upstream issue
//   anything else → generic

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'config.dart';

/// Wire-level chat message — `role` uses OpenAI names directly.
enum WireRole { system, user, assistant }

class WireChatMessage {
  final WireRole role;
  final String content;
  const WireChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'role': role.name,
        'content': content,
      };
}

typedef AssistantErrorCode = String;

const String errNoKey = 'no_key';
const String errInvalidKey = 'invalid_key';
const String errModelNotFound = 'model_not_found';
const String errRateLimited = 'rate_limited';
const String errUpstream = 'upstream';
const String errNetwork = 'network';

class AssistantError implements Exception {
  final AssistantErrorCode code;
  final String message;
  final int? status;
  AssistantError(this.code, this.message, [this.status]);

  @override
  String toString() => 'AssistantError($code, $message${status == null ? '' : ', $status'})';
}

class StreamOptions {
  final String apiKey;
  final String? model;
  final List<WireChatMessage> messages;
  final http.Client? client;
  StreamOptions({
    required this.apiKey,
    required this.messages,
    this.model,
    this.client,
  });
}

/// Stream the assistant reply token-by-token. Yields text deltas as they
/// arrive. Throws [AssistantError] on failure or [StateError] on abort.
Stream<String> streamChat(StreamOptions opts) async* {
  if (opts.apiKey.isEmpty) {
    throw AssistantError(errNoKey, 'No API key set');
  }
  final model = opts.model ?? AssistantConfig.model;
  final client = opts.client ?? http.Client();
  final ownsClient = identical(client, opts.client ?? client) && opts.client == null;

  http.StreamedResponse response;
  try {
    final req = http.Request('POST', Uri.parse(AssistantConfig.endpoint))
      ..headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${opts.apiKey}',
        ...AssistantConfig.appHeaders,
        'Accept': 'text/event-stream',
      })
      ..body = jsonEncode(<String, dynamic>{
        'model': model,
        'messages': opts.messages.map((m) => m.toJson()).toList(),
        'stream': true,
      });
    response = await client.send(req);
  } catch (e) {
    if (ownsClient) client.close();
    throw AssistantError(errNetwork, 'Network error — check your connection');
  }

  if (response.statusCode != 200) {
    final status = response.statusCode;
    final code = status == 401
        ? errInvalidKey
        : status == 404
            ? errModelNotFound
            : status == 429
                ? errRateLimited
                : errUpstream;
    final text = await response.stream.bytesToString().catchError((_) => '');
    if (ownsClient) client.close();
    throw AssistantError(
      code,
      'OpenRouter $status: ${text.isEmpty ? 'request failed' : text.substring(0, text.length < 200 ? text.length : 200)}',
      status,
    );
  }

  // SSE loop — split events on blank lines, parse each "data:" payload.
  final decoder = utf8.decoder;
  String buffer = '';
  try {
    await for (final chunk in response.stream.transform(decoder)) {
      buffer += chunk;
      int idx;
      while ((idx = buffer.indexOf('\n\n')) != -1) {
        final event = buffer.substring(0, idx);
        buffer = buffer.substring(idx + 2);
        for (final line in event.split('\n')) {
          final trimmed = line.trim();
          if (!trimmed.startsWith('data:')) continue;
          final payload = trimmed.substring(5).trim();
          if (payload == '[DONE]') return;
          if (payload.isEmpty) continue;
          try {
            final json = jsonDecode(payload) as Map<String, dynamic>;
            final choices = json['choices'] as List?;
            if (choices == null || choices.isEmpty) continue;
            final first = choices.first as Map<String, dynamic>;
            final delta = first['delta'] as Map<String, dynamic>?;
            final content = delta?['content'] as String?;
            if (content != null && content.isNotEmpty) yield content;
          } catch (_) {
            // Skip malformed line — SSE is best-effort.
          }
        }
      }
    }
    // Flush any partial bytes / last unterminated event.
    if (buffer.trim().isNotEmpty) {
      for (final line in buffer.split('\n')) {
        final trimmed = line.trim();
        if (!trimmed.startsWith('data:')) continue;
        final payload = trimmed.substring(5).trim();
        if (payload == '[DONE]' || payload.isEmpty) continue;
        try {
          final json = jsonDecode(payload) as Map<String, dynamic>;
          final choices = json['choices'] as List?;
          if (choices == null || choices.isEmpty) continue;
          final first = choices.first as Map<String, dynamic>;
          final delta = first['delta'] as Map<String, dynamic>?;
          final content = delta?['content'] as String?;
          if (content != null && content.isNotEmpty) yield content;
        } catch (_) {
          /* noop */
        }
      }
    }
  } finally {
    if (ownsClient) {
      client.close();
    }
  }
}

/// Single-shot test fetch to validate a key without streaming.
Future<void> testKey(String apiKey, {String? model, http.Client? client}) async {
  final m = model ?? AssistantConfig.model;
  final c = client ?? http.Client();
  try {
    final resp = await c.post(
      Uri.parse(AssistantConfig.endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        ...AssistantConfig.appHeaders,
      },
      body: jsonEncode(<String, dynamic>{
        'model': m,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': 'Reply with just the word OK.'},
        ],
      }),
    );
    if (resp.statusCode == 200) {
      // Drain body so the connection closes.
      return;
    }
    final status = resp.statusCode;
    final code = status == 401
        ? errInvalidKey
        : status == 404
            ? errModelNotFound
            : status == 429
                ? errRateLimited
                : errUpstream;
    final text = resp.body.isEmpty ? '' : (resp.body.length < 200 ? resp.body : resp.body.substring(0, 200));
    throw AssistantError(
      code,
      'OpenRouter $status: ${text.isEmpty ? resp.reasonPhrase ?? "request failed" : text}',
      status,
    );
  } catch (e) {
    if (e is AssistantError) rethrow;
    throw AssistantError(errNetwork, e.toString());
  } finally {
    if (client == null) c.close();
  }
}