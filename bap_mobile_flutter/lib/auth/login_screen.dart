// lib/auth/login_screen.dart
// ============================================================================
// Email + password sign-in form. Submits to POST /api/auth/login via
// AuthService. On success the parent gate takes the session and routes
// to the right screen (change-password, learner app, or admin notice).
//
// The form does light client-side validation (email shape, non-empty
// password); the backend is the final word on validity so any server
// message bubbles up via AuthException.
// ============================================================================

import 'package:flutter/material.dart';

import '../theme/theme_builder.dart';
import 'auth_models.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;
  final void Function(AuthSession session) onLoggedIn;

  /// Optional message to surface once when the screen first appears.
  /// Used by AuthGate to display a toast when a 401 forced a logout
  /// (e.g. "Your session has expired. Please sign in again.").
  final String? pendingMessage;
  final VoidCallback? onPendingMessageShown;

  const LoginScreen({
    super.key,
    required this.authService,
    required this.onLoggedIn,
    this.pendingMessage,
    this.onPendingMessageShown,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _obscure = true;
  bool _busy = false;
  String? _serverError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.pendingMessage != null) {
      // Defer to after the first frame so the Scaffold is mounted and
      // its messenger is available to show the SnackBar.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(widget.pendingMessage!),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        widget.onPendingMessageShown?.call();
      });
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _busy = true;
      _serverError = null;
    });

    try {
      final session = await widget.authService.login(
        email: _emailCtl.text.trim(),
        password: _passwordCtl.text,
      );
      if (!mounted) return;
      widget.onLoggedIn(session);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _serverError = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _serverError = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    final emailBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: t.border),
    );
    final emailFocusedBorder = emailBorder.copyWith(
      borderSide: BorderSide(color: t.borderStrong, width: 1.5),
    );
    final emailErrorBorder = emailBorder.copyWith(
      borderSide: const BorderSide(color: Color(0xFFef4444)),
    );

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: t.border),
                  boxShadow: t.shadow,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: t.surfaceAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: t.border),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'BAP',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: t.text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: t.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use the credentials provided by your admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: t.textDim,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ----- Email -----
                      TextFormField(
                        controller: _emailCtl,
                        focusNode: _focusEmail,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        enabled: !_busy,
                        style: TextStyle(color: t.text, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: t.textMid),
                          filled: true,
                          fillColor: t.surfaceAlt,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: emailBorder,
                          enabledBorder: emailBorder,
                          focusedBorder: emailFocusedBorder,
                          errorBorder: emailErrorBorder,
                          focusedErrorBorder: emailErrorBorder,
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            size: 18,
                            color: t.textMid,
                          ),
                        ),
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Email is required.';
                          final ok = RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(v);
                          if (!ok) return 'Enter a valid email address.';
                          return null;
                        },
                        onFieldSubmitted: (_) => _focusPassword.requestFocus(),
                      ),
                      const SizedBox(height: 14),

                      // ----- Password -----
                      TextFormField(
                        controller: _passwordCtl,
                        focusNode: _focusPassword,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        enabled: !_busy,
                        style: TextStyle(color: t.text, fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: t.textMid),
                          filled: true,
                          fillColor: t.surfaceAlt,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: emailBorder,
                          enabledBorder: emailBorder,
                          focusedBorder: emailFocusedBorder,
                          errorBorder: emailErrorBorder,
                          focusedErrorBorder: emailErrorBorder,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: t.textMid,
                          ),
                          suffixIcon: IconButton(
                            splashRadius: 20,
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: t.textMid,
                            ),
                            onPressed: _busy
                                ? null
                                : () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Password is required.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),

                      if (_serverError != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFfef2f2),
                            border: Border.all(color: const Color(0xFFfecaca)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFb91c1c),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _serverError!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFb91c1c),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 22),
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _busy ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: t.text,
                            foregroundColor: t.bg,
                            disabledBackgroundColor: t.textDim,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _busy
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(t.bg),
                                  ),
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}