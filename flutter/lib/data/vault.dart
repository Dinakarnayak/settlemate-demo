import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';

/// Where the 256-bit data key lives. On Android this is flutter_secure_storage,
/// which wraps the key with the Android Keystore (hardware-backed on most phones).
abstract class KeyStore {
  Future<List<int>?> readKey();
  Future<void> writeKey(List<int> key);
  Future<void> deleteKey();
}

/// Where the encrypted bytes live.
abstract class BlobStore {
  Future<String?> read();
  Future<void> write(String data);
  Future<void> delete();
}

class FileBlobStore implements BlobStore {
  FileBlobStore(this.path);
  final String path;

  @override
  Future<String?> read() async {
    final f = File(path);
    return await f.exists() ? f.readAsString() : null;
  }

  /// Write to a temporary file first, then rename, so a crash never leaves a
  /// half-written vault behind.
  @override
  Future<void> write(String data) async {
    final tmp = File('$path.tmp');
    await tmp.writeAsString(data, flush: true);
    await tmp.rename(path);
  }

  @override
  Future<void> delete() async {
    for (final p in [path, '$path.tmp']) {
      final f = File(p);
      if (await f.exists()) await f.delete();
    }
  }
}

class MemoryKeyStore implements KeyStore {
  List<int>? key;
  @override
  Future<List<int>?> readKey() async => key;
  @override
  Future<void> writeKey(List<int> k) async => key = List.of(k);
  @override
  Future<void> deleteKey() async => key = null;
}

class MemoryBlobStore implements BlobStore {
  String? data;
  @override
  Future<String?> read() async => data;
  @override
  Future<void> write(String d) async => data = d;
  @override
  Future<void> delete() async => data = null;
}

class VaultException implements Exception {
  VaultException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Encrypts all personal data with AES-256-GCM (authenticated encryption).
/// The key never leaves the device and is never shown to anyone, including us.
class Vault {
  Vault(this.keys, this.blobs);
  final KeyStore keys;
  final BlobStore blobs;

  static final _aes = AesGcm.with256bits();

  Future<SecretKey> _key() async {
    final existing = await keys.readKey();
    if (existing != null && existing.length == 32) return SecretKey(existing);
    final fresh = await _aes.newSecretKey();
    await keys.writeKey(await fresh.extractBytes());
    return fresh;
  }

  Future<Map<String, Object?>?> load() async {
    final raw = await blobs.read();
    if (raw == null || raw.isEmpty) return null;
    final stored = await keys.readKey();
    if (stored == null) {
      // Data without its key cannot be opened (e.g. the app was restored from a
      // device backup). Fail closed instead of guessing.
      throw VaultException('This device’s encryption key is missing, so saved data can’t be opened.');
    }
    final box = _decodeBox(raw);
    final clear = await _aes.decrypt(box, secretKey: SecretKey(stored));
    return jsonDecode(utf8.decode(clear)) as Map<String, Object?>;
  }

  Future<void> save(Map<String, Object?> data) async {
    final key = await _key();
    final box = await _aes.encrypt(utf8.encode(jsonEncode(data)), secretKey: key);
    await blobs.write(_encodeBox(box));
  }

  /// Deletes the encrypted data and the key. Without the key, any leftover copy
  /// is unreadable.
  Future<void> wipe() async {
    await blobs.delete();
    await keys.deleteKey();
  }

  static String _encodeBox(SecretBox b) => jsonEncode({
        'v': 1,
        'alg': 'AES-256-GCM',
        'n': base64Encode(b.nonce),
        'c': base64Encode(b.cipherText),
        'm': base64Encode(b.mac.bytes),
      });

  static SecretBox _decodeBox(String raw) {
    final j = jsonDecode(raw) as Map<String, Object?>;
    return SecretBox(
      base64Decode(j['c'] as String),
      nonce: base64Decode(j['n'] as String),
      mac: Mac(base64Decode(j['m'] as String)),
    );
  }
}

/// Passphrase-protected backups the student can keep anywhere (email to self,
/// cloud drive, USB). Without the passphrase the file is useless.
class Backup {
  static const prefix = 'LANDED-BACKUP-1:';
  static const iterations = 120000;
  static final _aes = AesGcm.with256bits();

  static Future<SecretKey> _derive(String passphrase, List<int> salt, int iterations) {
    final kdf = Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: iterations, bits: 256);
    return kdf.deriveKeyFromPassword(password: passphrase, nonce: salt);
  }

  static Future<String> create(Map<String, Object?> data, String passphrase) async {
    if (passphrase.length < 8) throw VaultException('Use a passphrase of at least 8 characters.');
    final salt = SecretKeyData.random(length: 16).bytes;
    final key = await _derive(passphrase, salt, iterations);
    final box = await _aes.encrypt(utf8.encode(jsonEncode(data)), secretKey: key);
    final payload = jsonEncode({
      's': base64Encode(salt),
      'i': iterations,
      'n': base64Encode(box.nonce),
      'c': base64Encode(box.cipherText),
      'm': base64Encode(box.mac.bytes),
    });
    return prefix + base64Url.encode(utf8.encode(payload));
  }

  static Future<Map<String, Object?>> open(String text, String passphrase) async {
    final t = text.trim();
    if (!t.startsWith(prefix)) throw VaultException('This doesn’t look like a Landed backup.');
    try {
      final j = jsonDecode(utf8.decode(base64Url.decode(t.substring(prefix.length)))) as Map<String, Object?>;
      final key = await _derive(passphrase, base64Decode(j['s'] as String), (j['i'] as num).toInt());
      final clear = await _aes.decrypt(
        SecretBox(base64Decode(j['c'] as String),
            nonce: base64Decode(j['n'] as String), mac: Mac(base64Decode(j['m'] as String))),
        secretKey: key,
      );
      return jsonDecode(utf8.decode(clear)) as Map<String, Object?>;
    } on SecretBoxAuthenticationError {
      throw VaultException('Wrong passphrase, or the backup was changed.');
    } on FormatException {
      throw VaultException('The backup text is incomplete. Copy all of it and try again.');
    }
  }
}
