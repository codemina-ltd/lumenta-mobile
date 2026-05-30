import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../shared/brand_mark.dart';
import 'auth_controller.dart';
import 'recaptcha_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .login(_email.text.trim(), _password.text);
  }

  String _errorText(AppLocalizations l10n, Object? error) {
    if (error is RecaptchaUnavailable) return l10n.loginNoRecaptcha;
    return l10n.loginError;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E2A25), AppColors.deepForest],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Insets.xxl,
                vertical: Insets.xxxl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppIconMark(size: 72)),
                      const SizedBox(height: Insets.xl),
                      const Center(
                        child: LumentaWordmark(
                          fontSize: 32,
                          color: AppColors.onDarkHigh,
                        ),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.onDarkMed,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: Insets.huge),
                      _Field(
                        controller: _email,
                        label: l10n.emailLabel,
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (v) =>
                            (v == null || !v.contains('@')) ? '—' : null,
                      ),
                      const SizedBox(height: Insets.lg),
                      _Field(
                        controller: _password,
                        label: l10n.passwordLabel,
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscure,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) => _submit(),
                        validator: (v) => (v == null || v.isEmpty) ? '—' : null,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.onDarkMed,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      AnimatedSize(
                        duration: Motion.fast,
                        curve: Motion.standard,
                        child: state.error != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: Insets.lg),
                                child: _ErrorBanner(
                                  message: _errorText(l10n, state.error),
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                      const SizedBox(height: Insets.xxl),
                      FilledButton(
                        onPressed: state.busy ? null : _submit,
                        child: state.busy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: AppColors.deepForest,
                                ),
                              )
                            : Text(l10n.loginButton),
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

/// Dark-surface text field tuned for the forest login backdrop (the global
/// input theme targets the light/dark scaffold, not this fixed-dark screen).
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints,
    this.validator,
    this.onSubmitted,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofillHints: autofillHints,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: AppColors.onDarkHigh, fontSize: 15),
      cursorColor: AppColors.signal,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.onDarkMed),
        floatingLabelStyle: const TextStyle(color: AppColors.signal),
        prefixIcon: Icon(icon, color: AppColors.onDarkMed, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.forest2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.lg,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.forestLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.signal, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.ember),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.field,
          borderSide: const BorderSide(color: AppColors.ember, width: 1.6),
        ),
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.ember.withValues(alpha: 0.14),
        borderRadius: Radii.field,
        border: Border.all(color: AppColors.ember.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.ember,
            size: 20,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.onDarkHigh, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
