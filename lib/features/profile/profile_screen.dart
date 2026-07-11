import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user.dart';
import '../auth/auth_controller.dart';
import '../shared/widgets.dart';
import 'profile_controller.dart';
import 'profile_options.dart';

/// Mirrors the portal phone validator (`/^[1-9]\d{6,14}$/` on both sides):
/// country code + number, digits only, no leading `+`.
final _phonePattern = RegExp(r'^[1-9]\d{6,14}$');

/// Characters users habitually type into phone fields; stripped before
/// validating/sending, exactly like the portal's normalizer.
final _phoneNoise = RegExp(r'[\s()+-]');

/// The signed-in user's profile — mobile counterpart of the portal's
/// Settings → Profile page: picture, identity, appearance (portal display
/// font), email change, and password change, all against the `/me` API.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _identityKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _phone;
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  late String _locale;
  late String _timezone;

  /// Unsaved font pick; null = show whatever the profile currently has.
  String? _font;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _name = TextEditingController(text: user?.name ?? user?.profileName ?? '');
    _phone = TextEditingController(text: user?.phoneNumber ?? '');
    _locale = user?.locale ?? 'en';
    _timezone = user?.timezone ?? 'UTC';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _errorText(AppLocalizations l10n, String code) {
    switch (code) {
      case 'PASSWORD_INCORRECT':
        return l10n.profilePasswordIncorrect;
      case 'EMAIL_ALREADY_REGISTERED':
        return l10n.profileEmailTaken;
      case 'EMAIL_CHANGE_INVALID':
        return l10n.profileEmailChangeInvalid;
      case 'AVATAR_TOO_LARGE':
        return l10n.profileAvatarTooLarge;
      case 'AVATAR_INVALID_TYPE':
        return l10n.profileAvatarInvalidType;
      default:
        return l10n.profileSaveFailed;
    }
  }

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context);
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // Keep uploads comfortably under the API's 2 MB cap.
      maxWidth: 1440,
      maxHeight: 1440,
      imageQuality: 85,
    );
    if (picked == null) return;
    final size = await picked.length();
    final code = await ref.read(profileControllerProvider.notifier).uploadAvatar(
          filePath: picked.path,
          fileSize: size,
          filename: picked.name,
        );
    if (!mounted) return;
    _snack(code == null ? l10n.profileSaved : _errorText(l10n, code));
  }

  Future<void> _removeAvatar() async {
    final l10n = AppLocalizations.of(context);
    final code =
        await ref.read(profileControllerProvider.notifier).removeAvatar();
    if (!mounted) return;
    if (code != null) _snack(_errorText(l10n, code));
  }

  Future<void> _saveIdentity() async {
    final l10n = AppLocalizations.of(context);
    if (!_identityKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final code = await ref.read(profileControllerProvider.notifier).saveIdentity(
          name: _name.text.trim(),
          phoneNumber: _phone.text.replaceAll(_phoneNoise, ''),
          locale: _locale,
          timezone: _timezone,
        );
    if (!mounted) return;
    // The locale may have just changed — re-read strings for the snackbar.
    final fresh = AppLocalizations.of(context);
    _snack(code == null ? fresh.profileSaved : _errorText(l10n, code));
    if (code == null) setState(() => _font = null); // server may snap the font
  }

  Future<void> _saveFont(String effectiveFont) async {
    final l10n = AppLocalizations.of(context);
    final code = await ref
        .read(profileControllerProvider.notifier)
        .saveFont(effectiveFont);
    if (!mounted) return;
    _snack(code == null ? l10n.profileFontSaved : _errorText(l10n, code));
    if (code == null) setState(() => _font = null);
  }

  Future<void> _changePassword() async {
    final l10n = AppLocalizations.of(context);
    if (!_passwordKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final code =
        await ref.read(profileControllerProvider.notifier).changePassword(
              currentPassword: _currentPassword.text,
              newPassword: _newPassword.text,
            );
    if (!mounted) return;
    if (code == null) {
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      _snack(l10n.profilePasswordUpdated);
    } else {
      _snack(_errorText(l10n, code));
    }
  }

  Future<void> _openTimezonePicker() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _TimezonePickerSheet(current: _timezone),
    );
    if (selected != null) setState(() => _timezone = selected);
  }

  Future<void> _openEmailDialog() async {
    final l10n = AppLocalizations.of(context);
    final sentTo = await showDialog<String>(
      context: context,
      builder: (_) => const _EmailChangeDialog(),
    );
    if (sentTo != null && mounted) {
      _snack(l10n.profileEmailChangeRequested(sentTo));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final busy = ref.watch(profileControllerProvider);

    if (user == null) {
      // Only reachable mid-logout; the router redirects away immediately.
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Insets.lg),
          children: [
            _SectionCard(
              title: l10n.profilePictureTitle,
              child: _AvatarSection(
                user: user,
                busy: busy.avatarBusy,
                onUpload: _pickAvatar,
                onRemove: _removeAvatar,
              ),
            ),
            const SizedBox(height: Insets.lg),
            _SectionCard(
              title: l10n.profileIdentityTitle,
              child: _identityForm(l10n, busy.savingIdentity),
            ),
            const SizedBox(height: Insets.lg),
            _SectionCard(
              title: l10n.profileAppearanceTitle,
              child: _appearanceForm(l10n, user, busy.savingFont),
            ),
            const SizedBox(height: Insets.lg),
            _SectionCard(
              title: l10n.profileEmailTitle,
              child: _emailSection(l10n, user),
            ),
            const SizedBox(height: Insets.lg),
            _SectionCard(
              title: l10n.profilePasswordTitle,
              child: _passwordForm(l10n, busy.changingPassword),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identityForm(AppLocalizations l10n, bool saving) {
    return Form(
      key: _identityKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(l10n.profileFullNameLabel, required: true),
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
            ),
            validator: (v) =>
                (v == null || v.trim().length < 2) ? l10n.profileNameTooShort : null,
          ),
          const SizedBox(height: Insets.lg),
          _FieldLabel(l10n.profilePhoneLabel),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              helperText: l10n.profilePhoneHelper,
              helperMaxLines: 2,
            ),
            validator: (v) {
              final normalized = (v ?? '').replaceAll(_phoneNoise, '');
              if (normalized.isEmpty) return null; // optional
              return _phonePattern.hasMatch(normalized)
                  ? null
                  : l10n.profilePhoneInvalid;
            },
          ),
          const SizedBox(height: Insets.lg),
          _FieldLabel(l10n.profileLanguageLabel),
          DropdownButtonFormField<String>(
            initialValue: _locale,
            items: [
              for (final o in supportedLocales)
                DropdownMenuItem(value: o.code, child: Text(o.label)),
            ],
            onChanged: (v) => setState(() => _locale = v ?? _locale),
          ),
          const SizedBox(height: Insets.lg),
          _FieldLabel(l10n.profileTimezoneLabel),
          _PickerField(
            label: TimezoneOption(id: _timezone, offset: _offsetOf(_timezone))
                .label,
            icon: Icons.public_rounded,
            onTap: _openTimezonePicker,
          ),
          const SizedBox(height: Insets.xl),
          FilledButton(
            onPressed: saving ? null : _saveIdentity,
            child: saving
                ? const _ButtonSpinner()
                : Text(l10n.profileSaveChanges),
          ),
        ],
      ),
    );
  }

  Duration _offsetOf(String id) {
    for (final o in allTimezones()) {
      if (o.id == id) return o.offset;
    }
    return Duration.zero;
  }

  Widget _appearanceForm(AppLocalizations l10n, User user, bool saving) {
    final options = fontsForLocale(user.locale);
    final validKeys = {for (final o in options) o.key};
    final effective = validKeys.contains(_font)
        ? _font!
        : (validKeys.contains(user.font)
            ? user.font!
            : defaultFontForLocale(user.locale));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(l10n.profileFontLabel),
        DropdownButtonFormField<String>(
          // Rebuild when the locale flips the allow-list (ar ↔ latin), so the
          // stale selection can't survive on the widget's internal state.
          key: ValueKey('font-${user.locale}'),
          initialValue: effective,
          items: [
            for (final o in options)
              DropdownMenuItem(value: o.key, child: Text(o.label)),
          ],
          // Arabic has a single allowed font — nothing to choose.
          onChanged: options.length == 1
              ? null
              : (v) => setState(() => _font = v),
        ),
        const SizedBox(height: Insets.sm),
        Text(
          l10n.profileFontHelper,
          style: context.text.bodySmall?.copyWith(
            color: context.scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Insets.xl),
        FilledButton(
          onPressed: saving ? null : () => _saveFont(effective),
          child: saving ? const _ButtonSpinner() : Text(l10n.profileSaveFont),
        ),
      ],
    );
  }

  Widget _emailSection(AppLocalizations l10n, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileCurrentEmail,
          style: context.text.bodySmall?.copyWith(
            color: context.scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Insets.sm),
        StatusPill(
          label: user.email ?? '—',
          color: AppColors.signalDeep,
          icon: Icons.mail_outline_rounded,
        ),
        if (user.pendingEmail != null && user.pendingEmail!.isNotEmpty) ...[
          const SizedBox(height: Insets.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Insets.md),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.hourglass_top_rounded,
                    size: 18, color: AppColors.amber),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    l10n.profileEmailPending(user.pendingEmail!),
                    style: context.text.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: Insets.xl),
        OutlinedButton(
          onPressed: _openEmailDialog,
          child: Text(l10n.profileChangeEmail),
        ),
      ],
    );
  }

  Widget _passwordForm(AppLocalizations l10n, bool saving) {
    return Form(
      key: _passwordKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(l10n.profileCurrentPasswordLabel, required: true),
          _passwordField(
            controller: _currentPassword,
            obscure: _obscureCurrent,
            onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
            validator: (v) =>
                (v == null || v.isEmpty) ? l10n.profileFieldRequired : null,
          ),
          const SizedBox(height: Insets.lg),
          _FieldLabel(l10n.profileNewPasswordLabel, required: true),
          _passwordField(
            controller: _newPassword,
            obscure: _obscureNew,
            onToggle: () => setState(() => _obscureNew = !_obscureNew),
            validator: (v) =>
                (v == null || v.length < 8) ? l10n.profilePasswordMin : null,
          ),
          const SizedBox(height: Insets.lg),
          _FieldLabel(l10n.profileConfirmPasswordLabel, required: true),
          _passwordField(
            controller: _confirmPassword,
            obscure: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            validator: (v) =>
                v != _newPassword.text ? l10n.profilePasswordMismatch : null,
          ),
          const SizedBox(height: Insets.xl),
          FilledButton(
            onPressed: saving ? null : _changePassword,
            child: saving
                ? const _ButtonSpinner()
                : Text(l10n.profileUpdatePassword),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }
}

/// Card with a titled header and divider, echoing the portal's settings cards.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Text(title, style: context.text.titleMedium),
          ),
          const Divider(),
          Padding(padding: const EdgeInsets.all(Insets.lg), child: child),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
      child: Row(
        children: [
          if (required) ...[
            const Text('*', style: TextStyle(color: AppColors.ember)),
            const SizedBox(width: Insets.xs),
          ],
          Text(text, style: context.text.labelLarge),
        ],
      ),
    );
  }
}

/// Read-only "field" that opens a picker on tap (used for the time zone).
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: Radii.field,
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(prefixIcon: Icon(icon, size: 20)),
        child: Row(
          children: [
            Expanded(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Icon(Icons.expand_more_rounded,
                size: 20, color: context.scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.4),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.user,
    required this.busy,
    required this.onUpload,
    required this.onRemove,
  });

  final User user;
  final bool busy;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  String get _initials {
    final source = (user.name?.trim().isNotEmpty ?? false)
        ? user.name!.trim()
        : (user.email ?? '?');
    final parts =
        source.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final avatarUrl = user.avatarUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: busy
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2.4))
              : (avatarUrl == null || avatarUrl.isEmpty)
                  ? InitialsAvatar(initials: _initials, radius: 36)
                  : ClipOval(
                      // The URL is a short-lived signed S3 link and changes on
                      // every /me fetch, so the cache naturally stays fresh.
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) =>
                            InitialsAvatar(initials: _initials, radius: 36),
                      ),
                    ),
        ),
        const SizedBox(width: Insets.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                onPressed: busy ? null : onUpload,
                icon: const Icon(Icons.file_upload_outlined, size: 20),
                label: Text(l10n.profileUploadPicture),
              ),
              if (avatarUrl != null && avatarUrl.isNotEmpty) ...[
                const SizedBox(height: Insets.sm),
                TextButton.icon(
                  onPressed: busy ? null : onRemove,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.ember,
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: Text(l10n.profileRemovePicture),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Searchable IANA time-zone picker (the portal renders a searchable Select
/// over the same list).
class _TimezonePickerSheet extends StatefulWidget {
  const _TimezonePickerSheet({required this.current});

  final String current;

  @override
  State<_TimezonePickerSheet> createState() => _TimezonePickerSheetState();
}

class _TimezonePickerSheetState extends State<_TimezonePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = _query.trim().toLowerCase().replaceAll(' ', '_');
    final zones = allTimezones()
        .where((z) => q.isEmpty || z.id.toLowerCase().contains(q))
        .toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Insets.lg, Insets.xs, Insets.lg, Insets.md),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: l10n.profileTimezoneSearchHint,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: zones.length,
              itemBuilder: (context, i) {
                final zone = zones[i];
                final selected = zone.id == widget.current;
                return ListTile(
                  dense: true,
                  title: Text(zone.id.replaceAll('_', ' ')),
                  trailing: Text(
                    zone.offsetLabel,
                    style: context.text.bodySmall?.copyWith(
                      color: selected
                          ? AppColors.signalDeep
                          : context.scheme.onSurfaceVariant,
                    ),
                  ),
                  leading: selected
                      ? const Icon(Icons.check_rounded,
                          size: 20, color: AppColors.signalDeep)
                      : const SizedBox(width: 20),
                  onTap: () => Navigator.of(context).pop(zone.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// "Change email" dialog — asks for the new address plus the current password
/// (the API requires password confirmation), fires `POST /me/email`, and pops
/// with the new address on success so the caller can show the sent notice.
class _EmailChangeDialog extends ConsumerStatefulWidget {
  const _EmailChangeDialog();

  @override
  ConsumerState<_EmailChangeDialog> createState() => _EmailChangeDialogState();
}

class _EmailChangeDialogState extends ConsumerState<_EmailChangeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _errorCode;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final newEmail = _email.text.trim();
    final code =
        await ref.read(profileControllerProvider.notifier).requestEmailChange(
              newEmail: newEmail,
              currentPassword: _password.text,
            );
    if (!mounted) return;
    if (code == null) {
      Navigator.of(context).pop(newEmail);
    } else {
      setState(() => _errorCode = code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(
      profileControllerProvider.select((s) => s.requestingEmail),
    );

    return AlertDialog(
      title: Text(l10n.profileChangeEmail),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l10n.profileNewEmailLabel,
                prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                return value.isEmpty || !value.contains('@')
                    ? l10n.profileEmailInvalid
                    : null;
              },
            ),
            const SizedBox(height: Insets.lg),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.profileCurrentPasswordLabel,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? l10n.profileFieldRequired : null,
            ),
            if (_errorCode != null) ...[
              const SizedBox(height: Insets.md),
              Text(
                switch (_errorCode) {
                  'PASSWORD_INCORRECT' => l10n.profilePasswordIncorrect,
                  'EMAIL_ALREADY_REGISTERED' => l10n.profileEmailTaken,
                  'EMAIL_CHANGE_INVALID' => l10n.profileEmailChangeInvalid,
                  _ => l10n.profileSaveFailed,
                },
                style: context.text.bodySmall?.copyWith(color: AppColors.ember),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: busy ? null : _submit,
          child: busy ? const _ButtonSpinner() : Text(l10n.profileSendLink),
        ),
      ],
    );
  }
}
