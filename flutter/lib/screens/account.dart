import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../theme.dart';
import '../widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.auth});
  final AuthService auth;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  bool creating = false;
  bool showPassword = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _do(Future<String?> Function() action, {String? success}) async {
    setState(() => busy = true);
    final err = await action();
    if (!mounted) return;
    setState(() => busy = false);
    if (err != null) {
      toast(context, err);
    } else if (success != null) {
      toast(context, success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.auth;
    return ListenableBuilder(
      listenable: a,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
          const Banner2(
            'An account is optional. Signing in doesn’t upload your visa dates, shifts, spending or notes; they stay encrypted on this phone.',
            bg: AppColors.blueSoft,
            fg: AppColors.blue,
            icon: Icons.lock_rounded,
          ),
          if (!AuthService.configured)
            const SoftCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sign-in coming soon', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 6),
                Text('This build has accounts switched off. Everything else works fully without one.', style: TextStyle(height: 1.4)),
              ]),
            )
          else if (a.initError != null)
            Banner2(a.initError!, bg: AppColors.coralSoft, fg: AppColors.coral, icon: Icons.error_rounded)
          else if (a.user != null)
            _signedIn(a)
          else
            _signIn(a),
          if (busy) const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
        ]),
      ),
    );
  }

  Widget _signedIn(AuthService a) {
    final u = a.user!;
    final verified = u.emailVerified || a.providerName != 'Email';
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SoftCard(
        child: Row(children: [
          IconBubble(Icons.person_rounded, bg: AppColors.mintSoft, fg: AppColors.mint, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u.displayName ?? u.email ?? 'Signed in', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              if (u.email != null) Text(u.email!, style: smallText),
              const SizedBox(height: 4),
              Pill('Signed in with ${a.providerName}', bg: AppColors.mintSoft, fg: AppColors.mint),
            ]),
          ),
        ]),
      ),
      if (!verified) ...[
        const Banner2('Please verify your email. We sent you a link.', icon: Icons.mark_email_unread_rounded),
        OutlinedButton(
          onPressed: busy ? null : () => _do(a.resendVerification, success: 'Verification email sent'),
          child: const Text('Resend verification email'),
        ),
        const SizedBox(height: 10),
      ],
      OutlinedButton.icon(
        onPressed: busy ? null : () => a.signOut(),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Sign out'),
      ),
      const SizedBox(height: 10),
      TextButton.icon(
        style: TextButton.styleFrom(foregroundColor: AppColors.coral),
        onPressed: busy
            ? null
            : () async {
                if (await confirm(context, 'Delete account?',
                    'This deletes your sign-in account. Data on this phone is not affected; erase it separately in Settings if you want.')) {
                  await _do(a.deleteAccount, success: 'Account deleted');
                }
              },
        icon: const Icon(Icons.person_remove_rounded),
        label: const Text('Delete my account'),
      ),
    ]);
  }

  Widget _signIn(AuthService a) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _ProviderButton(
        label: 'Continue with Google',
        icon: Icons.g_mobiledata_rounded,
        bg: Colors.white,
        fg: AppColors.ink,
        onTap: busy ? null : () => _do(a.signInWithGoogle),
      ),
      const SizedBox(height: 10),
      _ProviderButton(
        label: 'Continue with Facebook',
        icon: Icons.facebook_rounded,
        bg: const Color(0xFF1877F2),
        fg: Colors.white,
        onTap: busy ? null : () => _do(a.signInWithFacebook),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(children: [
          Expanded(child: Divider()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('or use email', style: smallText)),
          Expanded(child: Divider()),
        ]),
      ),
      TextField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: password,
        obscureText: !showPassword,
        autofillHints: [creating ? AutofillHints.newPassword : AutofillHints.password],
        decoration: InputDecoration(
          labelText: 'Password',
          helperText: creating ? 'At least 8 characters' : null,
          suffixIcon: IconButton(
            tooltip: showPassword ? 'Hide password' : 'Show password',
            onPressed: () => setState(() => showPassword = !showPassword),
            icon: Icon(showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
          ),
        ),
      ),
      const SizedBox(height: 14),
      FilledButton(
        onPressed: busy
            ? null
            : () {
                if (creating && password.text.length < 8) {
                  toast(context, 'Use at least 8 characters for your password.');
                  return;
                }
                _do(
                  () => creating ? a.createEmailAccount(email.text, password.text) : a.signInWithEmail(email.text, password.text),
                  success: creating ? 'Account created. Check your email to verify it.' : null,
                );
              },
        child: Text(creating ? 'Create account' : 'Sign in'),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TextButton(
          onPressed: () => setState(() => creating = !creating),
          child: Text(creating ? 'I already have an account' : 'Create an account'),
        ),
        if (!creating)
          TextButton(
            onPressed: busy
                ? null
                : () {
                    if (email.text.trim().isEmpty) {
                      toast(context, 'Enter your email first.');
                      return;
                    }
                    _do(() => a.resetPassword(email.text), success: 'Password reset email sent');
                  },
            child: const Text('Forgot password?'),
          ),
      ]),
      const SizedBox(height: 8),
      const Text(
        'Sign-in is provided by Google Firebase Authentication. We store only your sign-in identity (email, name and provider). See Settings → Privacy policy.',
        style: smallText,
      ),
    ]);
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({required this.label, required this.icon, required this.bg, required this.fg, required this.onTap});
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: bg == Colors.white ? Border.all(color: AppColors.line, width: 1.5) : null,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: fg, size: 28),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 15)),
            ]),
          ),
        ),
      );
}
