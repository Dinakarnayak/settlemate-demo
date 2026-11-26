import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Optional sign-in with Firebase Authentication (free Spark plan).
///
/// Sign-in only creates an identity. Personal data (visa dates, shifts, money)
/// still stays encrypted on the phone and is NOT uploaded.
///
/// Configuration comes from build-time values, so no keys are hard-coded:
///   --dart-define=FIREBASE_API_KEY=...
///   --dart-define=FIREBASE_APP_ID=...
///   --dart-define=FIREBASE_SENDER_ID=...
///   --dart-define=FIREBASE_PROJECT_ID=...
/// If they're missing, accounts are switched off and the app works offline.
class AuthService extends ChangeNotifier {
  static const _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');

  static bool get configured => _apiKey != '' && _appId != '' && _projectId != '';

  bool ready = false;
  String? initError;
  User? user;

  Future<void> init() async {
    if (!configured) return;
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: _apiKey,
          appId: _appId,
          messagingSenderId: _senderId,
          projectId: _projectId,
        ),
      );
      FirebaseAuth.instance.authStateChanges().listen((u) {
        user = u;
        notifyListeners();
      });
      user = FirebaseAuth.instance.currentUser;
      ready = true;
    } on Object catch (e) {
      initError = 'Sign-in is unavailable right now ($e).';
    }
    notifyListeners();
  }

  String get providerName {
    final ids = user?.providerData.map((p) => p.providerId).toList() ?? const [];
    if (ids.contains('google.com')) return 'Google';
    if (ids.contains('facebook.com')) return 'Facebook';
    return 'Email';
  }

  Future<String?> _run(Future<void> Function() action) async {
    if (!ready) return 'Sign-in isn’t set up in this build yet.';
    try {
      await action();
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendly(e);
    } on Object catch (e) {
      return 'Something went wrong: $e';
    }
  }

  Future<String?> signInWithGoogle() => _run(() async {
        final p = GoogleAuthProvider()..setCustomParameters({'prompt': 'select_account'});
        await FirebaseAuth.instance.signInWithProvider(p);
      });

  Future<String?> signInWithFacebook() => _run(() async {
        await FirebaseAuth.instance.signInWithProvider(FacebookAuthProvider());
      });

  Future<String?> signInWithEmail(String email, String password) => _run(() async {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password);
      });

  Future<String?> createEmailAccount(String email, String password) => _run(() async {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password);
        await cred.user?.sendEmailVerification();
      });

  Future<String?> resetPassword(String email) => _run(() async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      });

  Future<String?> resendVerification() => _run(() async {
        await user?.sendEmailVerification();
      });

  Future<void> signOut() async {
    if (ready) await FirebaseAuth.instance.signOut();
  }

  /// Deletes the account from Firebase. Local data is handled separately.
  Future<String?> deleteAccount() => _run(() async {
        await user?.delete();
      });

  String _friendly(FirebaseAuthException e) => switch (e.code) {
        'invalid-email' => 'That email address doesn’t look right.',
        'user-disabled' => 'This account has been disabled.',
        'user-not-found' || 'wrong-password' || 'invalid-credential' => 'Email or password is incorrect.',
        'email-already-in-use' => 'An account already uses this email. Try signing in.',
        'weak-password' => 'Choose a stronger password (at least 8 characters).',
        'too-many-requests' => 'Too many attempts. Wait a few minutes and try again.',
        'network-request-failed' => 'No internet connection.',
        'account-exists-with-different-credential' => 'You already signed up with another method for this email. Use that one.',
        'requires-recent-login' => 'For safety, sign in again and then retry.',
        'operation-not-allowed' => 'This sign-in method isn’t switched on yet.',
        'web-context-canceled' || 'canceled' => 'Sign-in was cancelled.',
        _ => e.message ?? 'Sign-in failed (${e.code}).',
      };
}
