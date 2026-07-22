// lib/screens/chat_screen.dart — the AI assistant screen.
// 1:1 port of src/screens/ChatScreen.tsx.
//
// Phase 4: renders the assistant UI (sub-header, message bubbles, thinking
// dots, error card, suggestion chips, input bar with send/stop). The send
// path still goes through ChatNotifier.send() — the live OpenRouter stream
// arrives in Phase 5 (services/assistant/api.dart).

import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../services/assistant/key_store.dart';
import '../services/assistant/suggestions.dart';
import '../state/chat.dart';
import '../state/nav.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/primitives/btn.dart';
import '../widgets/primitives/card_widget.dart';

class ChatScreen extends StatefulWidget {
  final ChatNotifier chat;
  final NavTarget from;
  final VoidCallback onOpenKeySetup;

  const ChatScreen({
    super.key,
    required this.chat,
    required this.from,
    required this.onOpenKeySetup,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _draft = TextEditingController();
  final ScrollController _scroll = ScrollController();
  late final List<String> _initialSuggestions;

  @override
  void initState() {
    super.initState();
    _initialSuggestions = getSuggestions(SuggestionsContext(from: widget.from));
    widget.chat.addListener(_onChatChanged);
  }

  @override
  void didUpdateWidget(covariant ChatScreen old) {
    super.didUpdateWidget(old);
    if (old.chat != widget.chat) {
      old.chat.removeListener(_onChatChanged);
      widget.chat.addListener(_onChatChanged);
    }
  }

  @override
  void dispose() {
    widget.chat.removeListener(_onChatChanged);
    _draft.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onChatChanged() {
    if (!mounted) return;
    setState(() {});
    // Scroll to bottom after a frame so the new message is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _submit() {
    final text = _draft.text.trim();
    if (text.isEmpty || widget.chat.thinking) return;
    widget.chat.send(text);
    _draft.clear();
  }

  @override
  Widget build(BuildContext context) {
    final acc = Accents.exam;
    final chat = widget.chat;
    final messages = chat.messages;
    final streaming = chat.streamingText;
    final thinking = chat.thinking;
    final error = chat.error;
    final hasKey = chat.hasKey;
    final onlyWelcome = messages.length <= 1 && streaming.isEmpty;

    return Column(
      children: [
        _AssistantHeader(
          acc: acc,
          hasKey: hasKey,
          onOpenKeySetup: widget.onOpenKeySetup,
        ),
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
            children: [
              for (int i = 0; i < messages.length; i++)
                ChatBubble(role: messages[i].role, text: messages[i].text, acc: acc),
              if (streaming.isNotEmpty)
                ChatBubble(role: ChatRole.bot, text: streaming, acc: acc),
              if (thinking && streaming.isEmpty) _ThinkingDots(acc: acc),
              if (error != null) _ErrorCard(
                error: error,
                onOpenKeySetup: widget.onOpenKeySetup,
              ),
              if (onlyWelcome && !thinking && error == null)
                _Suggestions(
                  hasKey: hasKey,
                  suggestions: _initialSuggestions,
                  acc: acc,
                  onTap: (s) {
                    widget.chat.send(s);
                  },
                ),
            ],
          ),
        ),
        _InputBar(
          controller: _draft,
          thinking: thinking,
          onSubmit: _submit,
          onStop: widget.chat.stop,
          hasKey: hasKey,
          acc: acc,
          onReset: () async {
            await keyStore.clear();
            widget.chat.reset();
          },
        ),
      ],
    );
  }
}

class _AssistantHeader extends StatelessWidget {
  final Accent acc;
  final bool hasKey;
  final VoidCallback onOpenKeySetup;
  const _AssistantHeader({
    required this.acc,
    required this.hasKey,
    required this.onOpenKeySetup,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: gradLinear(acc),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: tint(acc.c, 0.4), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.smart_toy, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Study Assistant ',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: t.text),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: tint(
                            acc.c,
                            t.name == 'dark' ? 0.20 : 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hasKey ? 'OPENROUTER' : 'PLACEHOLDER',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: hexToColor(acc.c),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: hasKey ? greenColor : t.textFaint,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      hasKey
                          ? 'Live · answers stream in real time'
                          : 'Not connected — set up your key',
                      style: TextStyle(fontSize: 11.5, color: t.textDim),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hasKey)
            InkWell(
              onTap: onOpenKeySetup,
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: t.border),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.vpn_key, size: 12, color: t.textDim),
                    const SizedBox(width: 4),
                    Text(
                      'Key',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600, color: t.textDim),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatRole role;
  final String text;
  final Accent acc;
  const ChatBubble({
    super.key,
    required this.role,
    required this.text,
    required this.acc,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isUser = role == ChatRole.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: gradLinear(acc),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.smart_toy, size: 14, color: Colors.white),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              decoration: BoxDecoration(
                gradient: isUser ? gradLinear(acc) : null,
                color: isUser ? null : t.surface,
                border: isUser ? null : Border.all(color: t.border),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isUser ? 14 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 14),
                ),
                boxShadow: t.shadow,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.55,
                  color: isUser ? Colors.white : t.textMid,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThinkingDots extends StatefulWidget {
  final Accent acc;
  const _ThinkingDots({required this.acc});
  @override
  State<_ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<_ThinkingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              gradient: gradLinear(widget.acc),
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: t.surface,
              border: Border.all(color: t.border),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final phase = _c.value; // 0..1 looping
                Widget dot(double delay) {
                  final v = ((phase + delay) % 1.0);
                  final dy = v < 0.4 ? -3.0 * (v / 0.4) : -3.0 * (1.0 - ((v - 0.4) / 0.6));
                  final opacity = v < 0.5 ? 0.25 + (v / 0.5) * 0.75 : 1.0 - ((v - 0.5) / 0.5) * 0.75;
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: t.textDim,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }

                return Row(
                  children: [
                    dot(0.0),
                    const SizedBox(width: 5),
                    dot(0.18),
                    const SizedBox(width: 5),
                    dot(0.36),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final ChatError error;
  final VoidCallback onOpenKeySetup;
  const _ErrorCard({required this.error, required this.onOpenKeySetup});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isNoKey = error.code == 'no_key';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardWidget(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        accent: redHex,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isNoKey ? 'No API key set' : 'Assistant error',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: hexToColor(redHex),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              error.message,
              style: TextStyle(fontSize: 12, color: t.textMid, height: 1.45),
            ),
            if (isNoKey) ...[
              const SizedBox(height: 8),
              Btn(
                variant: BtnVariant.ghost,
                onClick: onOpenKeySetup,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.vpn_key, size: 12),
                    SizedBox(width: 5),
                    Text('Set up key'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  final bool hasKey;
  final List<String> suggestions;
  final Accent acc;
  final void Function(String) onTap;
  const _Suggestions({
    required this.hasKey,
    required this.suggestions,
    required this.acc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 4, 0, 8),
            child: Text(
              hasKey ? 'Try asking' : 'Try asking (placeholder answers)',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: t.textFaint,
              ),
            ),
          ),
          for (int i = 0; i < suggestions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SuggestionChip(
                text: suggestions[i],
                acc: acc,
                onTap: () => onTap(suggestions[i]),
                index: i,
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatefulWidget {
  final String text;
  final Accent acc;
  final VoidCallback onTap;
  final int index;
  const _SuggestionChip({
    required this.text,
    required this.acc,
    required this.onTap,
    required this.index,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: _hover ? tint(widget.acc.c, 0.5) : t.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: hexToColor(widget.acc.c)),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: _hover ? t.text : t.textMid,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool thinking;
  final VoidCallback onSubmit;
  final VoidCallback onStop;
  final bool hasKey;
  final Accent acc;
  final VoidCallback onReset;
  const _InputBar({
    required this.controller,
    required this.thinking,
    required this.onSubmit,
    required this.onStop,
    required this.hasKey,
    required this.acc,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.border)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Ask the study assistant…',
                    hintStyle: TextStyle(color: t.textDim),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    filled: true,
                    fillColor: t.surfaceAlt,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: t.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: t.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: tint(acc.c, 0.6)),
                    ),
                  ),
                  style: TextStyle(fontSize: 14, color: t.text, height: 1.4),
                  onSubmitted: (_) {
                    if (!thinking) onSubmit();
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (thinking)
                _IconButton(
                  bg: t.surfaceHover,
                  fg: t.textMid,
                  icon: Icons.stop_circle_outlined,
                  onTap: onStop,
                )
              else
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final canSend = value.text.trim().isNotEmpty;
                    return _IconButton(
                      bg: canSend ? null : t.surfaceHover,
                      gradient: canSend ? gradLinear(acc) : null,
                      fg: canSend ? Colors.white : t.textFaint,
                      icon: Icons.send,
                      shadow: canSend ? tint(acc.c, 0.4) : null,

                      onTap: canSend ? onSubmit : null,
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hasKey
                ? 'Powered by OpenRouter · streaming'
                : 'No key set — paste one in Setup, or fall back to placeholder.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.5, color: t.textFaint),
          ),
          // Hidden reset trigger for parity with the React #__reset__ button.
          SizedBox(
            height: 0,
            width: 0,
            child: TextButton(
              onPressed: onReset,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Color? bg;
  final LinearGradient? gradient;
  final Color fg;
  final IconData icon;
  final Color? shadow;
  final VoidCallback? onTap;
  const _IconButton({
    this.bg,
    this.gradient,
    required this.fg,
    required this.icon,
    this.shadow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: bg,
          gradient: gradient,
          borderRadius: BorderRadius.circular(13),
          boxShadow: shadow == null
              ? null
              : [BoxShadow(color: shadow!, blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, size: 18, color: fg),
      ),
    );
  }
}