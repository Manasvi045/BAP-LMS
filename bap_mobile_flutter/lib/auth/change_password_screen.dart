// lib/auth/change_password_screen.dart
// ============================================================================
// Forced password-rotation screen. Shown when the persisted session
// (or fresh login) reports `mustChangePassword == true`.
//
// Posts to /api/auth/change-password via AuthService. On success the
// service flips the local "must change" flag to false and the parent
// gate re-resolves the session and routes into the actual app.
// ============================================================================

import 'package:flutter/material.dart';

import '../theme/theme_builder.dart';
import 'auth_models.dart';
import 'auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  final AuthService authService;
  final VoidCallback onChanged;

  /// When `true`, the screen runs in self-service mode: after a
  /// successful password change it shows a confirmation snackbar and
  /// pops itself instead of calling [onChanged]. Used when the screen
  /// is launched from the admin profile.
  final bool standalone;

  /// Optional title override (defaults to "Set a new password" in
  /// forced-rotation mode and "Change password" in standalone mode).
  final String? titleOverride;

  const ChangePasswordScreen({
    super.key,
    required this.authService,
    required this.onChanged,
    this.standalone = false,
    this.titleOverride,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtl = TextEditingController();
  final _newCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _busy = false;
  String? _serverError;

  @override
  void dispose() {
    _currentCtl.dispose();
    _newCtl.dispose();
    _confirmCtl.dispose();
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
      await widget.authService.changePassword(
        currentPassword: _currentCtl.text,
        newPassword: _newCtl.text,
        confirmPassword: _confirmCtl.text,
      );
      if (!mounted) return;
      if (widget.standalone) {
        // Self-service: pop back with a success snackbar so the caller
        // doesn't have to manage state. We deliberately do NOT call
        // onChanged — that re-runs the gate's resolver.
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('Password updated.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        widget.onChanged();
      }
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

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    final t = context.t;
    final base = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: t.border),
    );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: t.textMid),
      filled: true,
      fillColor: t.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: base,
      enabledBorder: base,
      focusedBorder: base.copyWith(
        borderSide: BorderSide(color: t.borderStrong, width: 1.5),
      ),
      errorBorder: base.copyWith(
        borderSide: const BorderSide(color: Color(0xFFef4444)),
      ),
      focusedErrorBorder: base.copyWith(
        borderSide: const BorderSide(color: Color(0xFFef4444)),
      ),
      prefixIcon: Icon(icon, size: 18, color: t.textMid),
      suffixIcon: IconButton(
        splashRadius: 20,
        icon: Icon(
          obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: t.textMid,
        ),
        onPressed: _busy ? null : onToggleObscure,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

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
                          child: Icon(
                            Icons.lock_reset,
                            color: t.textMid,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.titleOverride ??
                            (widget.standalone
                                ? 'Change password'
                                : 'Set a new password'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: t.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.standalone
                            ? 'Enter your current password and choose a new '
                                'one that is at least 8 characters long.'
                            : 'You need to change your password before you can '
                                'continue. Choose something at least 8 characters long.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: t.textDim,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Current password
                      TextFormField(
                        controller: _currentCtl,
                        obscureText: !_showCurrent,
                        enabled: !_busy,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: t.text, fontSize: 14),
                        decoration: _decoration(
                          label: 'Current password',
                          icon: Icons.lock_outline,
                          obscure: !_showCurrent,
                          onToggleObscure: () => setState(
                            () => _showCurrent = !_showCurrent,
                          ),
                        ),
                        validator: (v) => (v ?? '').isEmpty
                            ? 'Enter your current password.'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // New password
                      TextFormField(
                        controller: _newCtl,
                        obscureText: !_showNew,
                        enabled: !_busy,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: t.text, fontSize: 14),
                        decoration: _decoration(
                          label: 'New password',
                          icon: Icons.lock_outline,
                          obscure: !_showNew,
                          onToggleObscure: () => setState(
                            () => _showNew = !_showNew,
                          ),
                        ),
                        validator: (v) {
                          final s = v ?? '';
                          if (s.length < 8) {
                            return 'Password must be at least 8 characters.';
                          }
                          if (s == _currentCtl.text) {
                            return 'New password must differ from the current one.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirm
                      TextFormField(
                        controller: _confirmCtl,
                        obscureText: !_showConfirm,
                        enabled: !_busy,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: t.text, fontSize: 14),
                        decoration: _decoration(
                          label: 'Confirm new password',
                          icon: Icons.lock_outline,
                          obscure: !_showConfirm,
                          onToggleObscure: () => setState(
                            () => _showConfirm = !_showConfirm,
                          ),
                        ),
                        validator: (v) =>
                            (v ?? '') != _newCtl.text
                            ? 'Passwords do not match.'
                            : null,
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
                              : Text(
                                  widget.standalone
                                      ? 'Change password'
                                      : 'Update password',
                                  style: const TextStyle(
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