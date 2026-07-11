import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../auth/auth_controller.dart';

/// Per-section busy flags so each profile card shows its own spinner without
/// blocking the others (the portal renders five independent cards too).
@immutable
class ProfileState {
  const ProfileState({
    this.savingIdentity = false,
    this.savingFont = false,
    this.avatarBusy = false,
    this.requestingEmail = false,
    this.changingPassword = false,
  });

  final bool savingIdentity;
  final bool savingFont;
  final bool avatarBusy;
  final bool requestingEmail;
  final bool changingPassword;

  ProfileState copyWith({
    bool? savingIdentity,
    bool? savingFont,
    bool? avatarBusy,
    bool? requestingEmail,
    bool? changingPassword,
  }) {
    return ProfileState(
      savingIdentity: savingIdentity ?? this.savingIdentity,
      savingFont: savingFont ?? this.savingFont,
      avatarBusy: avatarBusy ?? this.avatarBusy,
      requestingEmail: requestingEmail ?? this.requestingEmail,
      changingPassword: changingPassword ?? this.changingPassword,
    );
  }
}

/// Drives the `/me` mutations behind the profile screen. Every method returns
/// `null` on success or an API error code (e.g. `PASSWORD_INCORRECT`) the
/// screen maps to a localized message; profile-returning calls also push the
/// fresh [User] into [AuthController] so locale/avatar update app-wide.
class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._ref) : super(const ProfileState());

  final Ref _ref;

  /// `POST /me/avatar` caps uploads at 2 MB (`AVATAR_TOO_LARGE`).
  static const maxAvatarBytes = 2 * 1024 * 1024;

  Future<String?> saveIdentity({
    required String name,
    required String phoneNumber,
    required String locale,
    required String timezone,
  }) async {
    state = state.copyWith(savingIdentity: true);
    try {
      final user = await _ref.read(authRepoProvider).updateMe(
            name: name,
            // An empty string fails the API's phone validator — omit it
            // instead, like the portal does (phone can't be cleared).
            phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
            locale: locale,
            timezone: timezone,
          );
      _ref.read(authControllerProvider.notifier).applyUser(user);
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(savingIdentity: false);
    }
  }

  Future<String?> saveFont(String font) async {
    state = state.copyWith(savingFont: true);
    try {
      final user = await _ref.read(authRepoProvider).updateMe(font: font);
      _ref.read(authControllerProvider.notifier).applyUser(user);
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(savingFont: false);
    }
  }

  Future<String?> uploadAvatar({
    required String filePath,
    required int fileSize,
    String? filename,
  }) async {
    if (fileSize > maxAvatarBytes) return 'AVATAR_TOO_LARGE';
    state = state.copyWith(avatarBusy: true);
    try {
      final user = await _ref
          .read(authRepoProvider)
          .uploadAvatar(filePath: filePath, filename: filename);
      _ref.read(authControllerProvider.notifier).applyUser(user);
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(avatarBusy: false);
    }
  }

  Future<String?> removeAvatar() async {
    state = state.copyWith(avatarBusy: true);
    try {
      final user = await _ref.read(authRepoProvider).removeAvatar();
      _ref.read(authControllerProvider.notifier).applyUser(user);
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(avatarBusy: false);
    }
  }

  Future<String?> requestEmailChange({
    required String newEmail,
    required String currentPassword,
  }) async {
    state = state.copyWith(requestingEmail: true);
    try {
      await _ref.read(authRepoProvider).requestEmailChange(
            newEmail: newEmail,
            currentPassword: currentPassword,
          );
      // `pendingEmail` is set server-side; re-fetch so the card shows it.
      final user = await _ref.read(authRepoProvider).me();
      _ref.read(authControllerProvider.notifier).applyUser(user);
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(requestingEmail: false);
    }
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(changingPassword: true);
    try {
      await _ref.read(authRepoProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );
      return null;
    } on DioException catch (e) {
      return _errorCode(e);
    } finally {
      state = state.copyWith(changingPassword: false);
    }
  }

  /// The API reports failures as `{ message: 'CODE' }` (class-validator
  /// errors arrive as a list — take the first). Anything unshaped becomes
  /// `UNKNOWN` and surfaces as the generic failure message.
  static String _errorCode(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
    }
    return 'UNKNOWN';
  }
}

final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
  return ProfileController(ref);
});
