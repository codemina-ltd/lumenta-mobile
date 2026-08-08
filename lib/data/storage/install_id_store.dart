import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stable per-install identifier sent with FCM device registration so the
/// server can recognise "same physical device, new token" after a token
/// rotation and retire the stale row (instead of pushing to both tokens —
/// the duplicate-notification bug). Generated once and persisted in secure
/// storage; on iOS the Keychain survives reinstalls, which is exactly the
/// case where a rotated token would otherwise leave a live duplicate.
class InstallIdStore {
  static const _storage = FlutterSecureStorage();
  static const _key = 'install_id';

  String? _cached;

  Future<String> get() async {
    final cached = _cached;
    if (cached != null) return cached;
    var id = await _storage.read(key: _key);
    if (id == null || id.isEmpty) {
      id = _generate();
      await _storage.write(key: _key, value: id);
    }
    _cached = id;
    return id;
  }

  static String _generate() {
    final rand = Random.secure();
    const hex = '0123456789abcdef';
    return List.generate(32, (_) => hex[rand.nextInt(16)]).join();
  }
}
