// lib/screens/key_setup_screen.dart — first-launch key entry for OpenRouter.
// 1:1 port of src/screens/KeySetupScreen.tsx.
//
// Flow: user pastes a key → "Test connection" validates → "Save and continue"
// stores it via SharedPreferences → App re-checks hasKey → AssistantScreen
// mounts. "Use placeholder instead" skips to placeholder mode.
//
// The actual testKey() validation lands in Phase 5 (services/assistant/api.dart).
// For now the Test button surfaces a no-op success after a short delay — the
// real call replaces the body without changing the surrounding UI.

import 'package:flutter/material.dart';

import '../services/assistant/api.dart';
import '../services/assistant/key_store.dart';
import '../theme/accents.dart';
import '../theme/theme_builder.dart';
import '../theme/utils.dart';
import '../widgets/primitives/btn.dart';
import '../widgets/primitives/card_widget.dart';
import '../widgets/primitives/kicker.dart';

sealed class _TestState {
  const _TestState();
}

class _TestIdle extends _TestState {
  const _TestIdle();
}

class _TestTesting extends _TestState {
  const _TestTesting();
}

class _TestOk extends _TestState {
  const _TestOk();
}

class _TestError extends _TestState {
  final String code;
  final String message;
  const _TestError(this.code, this.message);
}

class KeySetupScreen extends StatefulWidget {
  final VoidCallback onSaved;
  final VoidCallback onSkip;
  const KeySetupScreen({super.key, required this.onSaved, required this.onSkip});

  @override
  State<KeySetupScreen> createState() => _KeySetupScreenState();
}

class _KeySetupScreenState extends State<KeySetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final KeyStore _store = const SharedPrefsKeyStore();
  bool _showKey = false;
  _TestState _test = const _TestIdle();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTest() async {
    final draft = _controller.text.trim();
    if (draft.isEmpty) {
      setState(() => _test = const _TestError('no_key', 'Paste a key first.'));
      return;
    }
    setState(() => _test = const _TestTesting());
    try {
      await testKey(draft);
      if (!mounted) return;
      setState(() => _test = const _TestOk());
    } on AssistantError catch (e) {
      if (!mounted) return;
      setState(() => _test = _TestError(e.code, friendlyError(e.code, e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _test = _TestError('network', e.toString()));
    }
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);
    try {
      await _store.set(_controller.text.trim());
      if (!mounted) return;
      widget.onSaved();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _test = _TestError('save', e.toString());
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final acc = Accents.exam;
    final draft = _controller.text;
    final idle = _test is _TestIdle;
    final ok = _test is _TestOk;
    final err = _test is _TestError ? _test as _TestError : null;

    Color borderColor = t.border;
    if (ok) {
      borderColor = tint(greenHex, 0.6);
    } else if (err != null) {
      borderColor = tint(redHex, 0.6);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradLinear(acc),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: tint(acc.c, 0.45), blurRadius: 22, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: const Icon(Icons.vpn_key, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Kicker(c: acc.c, child: const Text('First-time setup')),
                const SizedBox(height: 8),
                Text(
                  'Set up your AI key',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    'Connect the Study Assistant to an OpenRouter account. The key stays on this device only.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.5, color: t.textMid, height: 1.55),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          CardWidget(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OPENROUTER API KEY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: t.textDim,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Focus(
                      onFocusChange: (f) {
                        if (!f && idle) setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        decoration: BoxDecoration(
                          color: t.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: TextField(
                          controller: _controller,
                          obscureText: !_showKey,
                          autocorrect: false,
                          enableSuggestions: false,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                            color: t.text,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'sk-or-v1-…',
                            contentPadding: EdgeInsets.fromLTRB(13, 12, 78, 12),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (_) {
                            if (!idle) setState(() => _test = const _TestIdle());
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _showKey = !_showKey),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _showKey ? 'Hide' : 'Show',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: t.textDim,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (ok) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 14, color: hexToColor(greenHex)),
                      const SizedBox(width: 6),
                      Text(
                        'Key validated. Model responded.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: hexToColor(greenHex),
                        ),
                      ),
                    ],
                  ),
                ],
                if (err != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    err.message,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: hexToColor(redHex),
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Btn(
                  variant: BtnVariant.ghost,
                  full: true,
                  onClick: _test is _TestTesting ? null : _onTest,
                  disabled: _test is _TestTesting || draft.trim().isEmpty,
                  child: _test is _TestTesting
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 1.6),
                            ),
                            SizedBox(width: 8),
                            Text('Testing…'),
                          ],
                        )
                      : const Text('Test connection'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Btn(
                  accent: acc.c,
                  gradient: gradCss(acc),
                  full: true,
                  onClick: draft.trim().isEmpty || _saving ? null : _onSave,
                  disabled: draft.trim().isEmpty || _saving,
                  child: Text(_saving ? 'Saving…' : 'Save and continue'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tint(acc.c, t.name == 'dark' ? 0.08 : 0.05),
              border: Border.all(color: tint(acc.c, 0.25)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, size: 14, color: hexToColor(acc.c)),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 11.5, color: t.textMid, height: 1.5),
                      children: [
                        const TextSpan(text: 'Your key is stored locally in this app\'s secure preferences. It\'s sent only to '),
                        TextSpan(
                          text: 'openrouter.ai',
                          style: TextStyle(color: t.text, fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: ' and nowhere else.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: widget.onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(8),
              foregroundColor: t.textDim,
              textStyle: const TextStyle(fontSize: 12.5),
            ),
            child: const Text('Use placeholder instead →'),
          ),
        ],
      ),
    );
  }
}

/// Friendly error mapper — mirrors the helper in src/screens/KeySetupScreen.tsx.
/// Phase 5 hooks the actual testKey() up; this stays here so the UI is ready.
String friendlyError(String code, String raw) {
  switch (code) {
    case 'invalid_key':
      return 'Invalid key. Check it starts with `sk-or-v1-` and has no extra spaces.';
    case 'model_not_found':
      return 'Model not found on OpenRouter. The model name in config.ts may be wrong.';
    case 'rate_limited':
      return 'OpenRouter rate limit hit. Try again in a moment.';
    case 'network':
      return "Couldn't reach OpenRouter. Check your internet connection.";
    default:
      return raw.isEmpty ? 'Something went wrong.' : raw;
  }
}