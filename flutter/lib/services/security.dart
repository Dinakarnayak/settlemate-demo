import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../data/vault.dart';

/// Keeps the data key in the Android Keystore via flutter_secure_storage.
class SecureKeyStore implements KeyStore {
  static const _name = 'landed.vault.key.v1';
  final _storage = FlutterSecureStorage(aOptions: AndroidOptions());

  @override
  Future<List<int>?> readKey() async {
    final v = await _storage.read(key: _name);
    if (v == null) return null;
    return [for (var i = 0; i < v.length; i += 2) int.parse(v.substring(i, i + 2), radix: 16)];
  }

  @override
  Future<void> writeKey(List<int> key) =>
      _storage.write(key: _name, value: key.map((b) => b.toRadixString(16).padLeft(2, '0')).join());

  @override
  Future<void> deleteKey() => _storage.delete(key: _name);
}

/// Native switches implemented in MainActivity.kt.
class ScreenPrivacy {
  static const _channel = MethodChannel('landed/security');

  /// When on, Android blocks screenshots and hides the app preview in Recents.
  static Future<void> setSecure(bool on) async {
    try {
      await _channel.invokeMethod('setSecure', on);
    } on Object {
      // Not available (tests, other platforms). Safe to ignore.
    }
  }
}

/// Fingerprint / face / device PIN unlock.
class DeviceAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> available() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  static Future<bool> unlock(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } on Object {
      return false;
    }
  }
}
