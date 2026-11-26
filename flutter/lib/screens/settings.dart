import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/models.dart';
import '../data/store.dart';
import '../data/vault.dart';
import '../l10n/l10n.dart';
import '../content/countries/countries.dart';
import '../services/auth.dart';
import '../services/security.dart';
import '../theme.dart';
import '../widgets.dart';
import 'account.dart';
import 'profile_photo.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.store, required this.auth});
  final AppStore store;
  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([store, auth]),
      builder: (context, _) {
        final s = store;
        final p = s.profile;
        return Scaffold(
          appBar: AppBar(title: Text(t('Settings'))),
          body: ListView(padding: const EdgeInsets.fromLTRB(18, 4, 18, 40), children: [
            // ------------------------------------------------ profile
            Center(
              child: Column(children: [
                const SizedBox(height: 8),
                Stack(clipBehavior: Clip.none, children: [
                  GestureDetector(
                    onTap: () => showPhotoOptions(context, s),
                    child: ProfileAvatar(store: s, size: 104, tilt: false),
                  ),
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: IconButton.filled(
                      tooltip: t('Change profile photo'),
                      style: IconButton.styleFrom(backgroundColor: AppColors.coral, foregroundColor: Colors.white),
                      onPressed: () => showPhotoOptions(context, s),
                      icon: const Icon(Icons.photo_camera_rounded, size: 20),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                Text(p.name.isEmpty ? t('Add your name') : p.name, style: Theme.of(context).textTheme.titleLarge),
                if (p.university.isNotEmpty) Text(p.university, style: smallText),
                const SizedBox(height: 8),
              ]),
            ),
            SectionHeader(t('Profile')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(children: [
                _row(context, Icons.person_rounded, t('Name'), p.name, (v) => s.updateProfile((x) => x.name = v)),
                _row(context, Icons.school_rounded, t('University'), p.university, (v) => s.updateProfile((x) => x.university = v)),
                _row(context, Icons.location_city_rounded, t('City'), p.city, (v) => s.updateProfile((x) => x.city = v)),
                _row(context, Icons.public_rounded, t('Home country'), p.homeCountry, (v) => s.updateProfile((x) => x.homeCountry = v)),
                ListTile(
                  leading: const Icon(Icons.badge_rounded),
                  title: Text(t('Visa expiry')),
                  subtitle: Text(p.visaExpiry == null ? t('Not set') : fmtDate(p.visaExpiry!, year: true)),
                  trailing: const Icon(Icons.edit_calendar_rounded),
                  onTap: () async {
                    final d = await pickDate(context, initial: p.visaExpiry ?? s.now.add(const Duration(days: 365)), first: DateTime(2020));
                    if (d != null) s.updateProfile((x) => x.visaExpiry = d);
                  },
                ),
                if (s.rule.belowDegreeLimit != null)
                  SwitchListTile(
                    secondary: const Icon(Icons.schedule_rounded),
                    title: Text(t('Degree level or above')),
                    subtitle: Text(t('Work limit: {x} per {p}', {'x': s.units(s.workLimit), 'p': t(s.rule.periodName)})),
                    value: p.degreeLevel,
                    onChanged: (v) => s.updateProfile((x) {
                      x.degreeLevel = v;
                      x.weeklyLimit = s.defaultLimit(s.pack, v);
                    }),
                  ),
              ]),
            ),

            // ------------------------------------------------ country & language
            SectionHeader(t('Country & language')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(children: [
                ListTile(
                  leading: Text(s.pack.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(t('Study country')),
                  subtitle: Text(s.pack.fullySupported ? s.pack.name : t('Another country')),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _pickCountry(context, s),
                ),
                if (!s.pack.fullySupported)
                  _row(context, Icons.payments_rounded, t('Currency symbol'), p.currency, (v) => s.updateProfile((x) => x.currency = v)),
                ListTile(
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(t('Language')),
                  subtitle: Text(appLanguages.firstWhere((l) => l.code == currentLanguage).native),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _pickLanguage(context, s),
                ),
              ]),
            ),

            // ------------------------------------------------ account
            SectionHeader(t('Account')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: Text(auth.user == null ? t('Sign in (optional)') : (auth.user!.email ?? t('Signed in'))),
                subtitle: Text(auth.user == null ? t('Google, Facebook or email') : t('Signed in with {p}', {'p': auth.providerName})),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccountScreen(auth: auth))),
              ),
            ),

            // ------------------------------------------------ security
            SectionHeader(t('Privacy & security')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(children: [
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: Text(t('App lock')),
                  subtitle: Text(t('Fingerprint, face or phone PIN to open Landed')),
                  value: s.settings.appLock,
                  onChanged: (v) async {
                    if (v) {
                      if (!await DeviceAuth.available()) {
                        if (context.mounted) toast(context, t('Set up a screen lock on your phone first.'));
                        return;
                      }
                      if (!await DeviceAuth.unlock(t('Confirm to turn on App lock'))) return;
                    }
                    s.updateSettings((x) => x.appLock = v);
                  },
                ),
                if (s.settings.appLock)
                  ListTile(
                    leading: const Icon(Icons.timer_rounded),
                    title: Text(t('Lock after leaving the app')),
                    trailing: DropdownButton<int>(
                      value: s.settings.lockAfterSeconds,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text(t('Immediately'))),
                        DropdownMenuItem(value: 30, child: Text(t('30 seconds'))),
                        DropdownMenuItem(value: 120, child: Text(t('2 minutes'))),
                        DropdownMenuItem(value: 600, child: Text(t('10 minutes'))),
                      ],
                      onChanged: (v) => s.updateSettings((x) => x.lockAfterSeconds = v ?? 30),
                    ),
                  ),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility_off_rounded),
                  title: Text(t('Hide screen in recent apps')),
                  subtitle: Text(t('Also blocks screenshots of Landed')),
                  value: s.settings.hideInRecents,
                  onChanged: (v) {
                    s.updateSettings((x) => x.hideInRecents = v);
                    ScreenPrivacy.setSecure(v);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.policy_rounded),
                  title: Text(t('Privacy policy')),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyScreen())),
                ),
              ]),
            ),

            // ------------------------------------------------ data
            SectionHeader(t('Your data')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.cloud_upload_rounded),
                  title: Text(t('Create encrypted backup')),
                  subtitle: Text(t('Locked with a passphrase you choose')),
                  onTap: () => _exportBackup(context, s),
                ),
                ListTile(
                  leading: const Icon(Icons.restore_rounded),
                  title: Text(t('Restore from backup')),
                  subtitle: Text(t('Paste your backup text')),
                  onTap: () => _importBackup(context, s),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded, color: AppColors.coral),
                  title: Text(t('Erase everything'), style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w700)),
                  subtitle: Text(t('Deletes all data and the encryption key')),
                  onTap: () async {
                    if (await confirm(context, t('Erase everything?'),
                        t('All your data on this phone will be permanently deleted. This can’t be undone unless you have a backup.'),
                        yes: t('Erase'))) {
                      await auth.signOut();
                      await s.eraseEverything();
                      if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
                    }
                  },
                ),
              ]),
            ),

            // ------------------------------------------------ about
            SectionHeader(t('About')),
            SoftCard(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(children: [
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text('Landed 2.0'),
                  subtitle: Text(t('An independent student project. Not affiliated with any government or university.')),
                ),
                ListTile(
                  leading: const Icon(Icons.description_rounded),
                  title: Text(t('Open-source licences')),
                  onTap: () => showLicensePage(context: context, applicationName: 'Landed', applicationVersion: '2.0'),
                ),
              ]),
            ),
          ]),
        );
      },
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value, void Function(String) save) => ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value.isEmpty ? t('Not set') : value),
        trailing: const Icon(Icons.edit_rounded, size: 18),
        onTap: () async {
          final c = TextEditingController(text: value);
          final v = await showDialog<String>(
            context: context,
            builder: (d) => AlertDialog(
              title: Text(label),
              content: TextField(controller: c, autofocus: true, textCapitalization: TextCapitalization.words),
              actions: [
                TextButton(onPressed: () => Navigator.pop(d), child: Text(t('Cancel'))),
                FilledButton(onPressed: () => Navigator.pop(d, c.text.trim()), child: Text(t('Save'))),
              ],
            ),
          );
          if (v != null) save(v);
        },
      );

  Future<void> _pickCountry(BuildContext context, AppStore s) async {
    final code = await showSheet<String>(context, (c) => ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(t('Where are you studying?'), style: Theme.of(c).textTheme.titleLarge),
          ),
          for (final p in countryPacks)
            ListTile(
              leading: Text(p.flag, style: const TextStyle(fontSize: 24)),
              title: Text(p.fullySupported ? p.name : t('Another country')),
              subtitle: Text(p.fullySupported ? p.currencyCode : t('General tools, no country-specific rules yet')),
              trailing: p.code == s.profile.studyCountry ? const Icon(Icons.check_rounded, color: AppColors.coral) : null,
              onTap: () => Navigator.pop(c, p.code),
            ),
        ]));
    if (code == null || code == s.profile.studyCountry || !context.mounted) return;
    final reset = await confirm(context, t('Switch to {c}?', {'c': packFor(code).fullySupported ? packFor(code).name : t('Another country')}),
        t('Your work limit, guides and emergency numbers will change. Replace your arrival checklist with the new country’s too?'),
        yes: t('Replace checklist'), danger: false);
    s.setStudyCountry(code, resetChecklist: reset);
  }

  Future<void> _pickLanguage(BuildContext context, AppStore s) async {
    final code = await showSheet<String>(context, (c) => ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(t('Language'), style: Theme.of(c).textTheme.titleLarge),
          ),
          for (final l in appLanguages)
            ListTile(
              title: Text(l.native),
              subtitle: Text(l.name),
              trailing: l.code == currentLanguage ? const Icon(Icons.check_rounded, color: AppColors.coral) : null,
              onTap: () => Navigator.pop(c, l.code),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(t('Translations are new and may contain mistakes. Guides stay in English for now.'), style: smallText),
          ),
        ]));
    if (code == null) return;
    setCurrentLanguage(code);
    s.setLanguage(code);
  }

  Future<String?> _askPassphrase(BuildContext context, {required bool create}) {
    final a = TextEditingController();
    final b = TextEditingController();
    String? error;
    return showDialog<String>(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (d, set) => AlertDialog(
          title: Text(create ? t('Choose a passphrase') : t('Enter passphrase')),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (create)
              Text(t('You’ll need this to restore. It can’t be recovered if you forget it.'), style: smallText),
            const SizedBox(height: 10),
            TextField(controller: a, obscureText: true, autofocus: true, decoration: InputDecoration(labelText: t('Passphrase'))),
            if (create) ...[
              const SizedBox(height: 10),
              TextField(controller: b, obscureText: true, decoration: InputDecoration(labelText: t('Repeat passphrase'))),
            ],
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error!, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600)),
            ],
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d), child: Text(t('Cancel'))),
            FilledButton(
              onPressed: () {
                if (create && a.text.length < 8) return set(() => error = t('Use at least 8 characters.'));
                if (create && a.text != b.text) return set(() => error = t('Passphrases don’t match.'));
                Navigator.pop(d, a.text);
              },
              child: Text(t('Continue')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportBackup(BuildContext context, AppStore s) async {
    final pass = await _askPassphrase(context, create: true);
    if (pass == null || !context.mounted) return;
    toast(context, t('Encrypting…'));
    try {
      await s.flush();
      final text = await Backup.create(s.toJson(), pass);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/landed-backup-${isoDate(s.now)}.txt');
      await file.writeAsString(text, flush: true);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'text/plain')],
        subject: 'Landed encrypted backup',
        text: 'Landed encrypted backup. Keep it safe; it can only be opened with your passphrase.',
      ));
      // Remove the temporary copy once the share sheet has taken it.
      if (await file.exists()) await file.delete();
    } on Object catch (e) {
      if (context.mounted) toast(context, '${t('Backup failed')}: $e');
    }
  }

  Future<void> _importBackup(BuildContext context, AppStore s) async {
    final clip = await Clipboard.getData(Clipboard.kTextPlain);
    if (!context.mounted) return;
    final text = TextEditingController(text: (clip?.text ?? '').startsWith(Backup.prefix) ? clip!.text : '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(t('Restore backup')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(t('Open your backup file, copy all its text and paste it here. This replaces the data on this phone.'), style: smallText),
          const SizedBox(height: 10),
          TextField(controller: text, maxLines: 4, decoration: const InputDecoration(hintText: 'LANDED-BACKUP-1:…')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, false), child: Text(t('Cancel'))),
          FilledButton(onPressed: () => Navigator.pop(d, true), child: Text(t('Next'))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final pass = await _askPassphrase(context, create: false);
    if (pass == null || !context.mounted) return;
    toast(context, t('Decrypting…'));
    try {
      final data = await Backup.open(text.text, pass);
      await s.restore(data);
      if (context.mounted) toast(context, t('Backup restored'));
    } on VaultException catch (e) {
      if (context.mounted) toast(context, e.message);
    } on Object catch (e) {
      if (context.mounted) toast(context, '${t('Restore failed')}: $e');
    }
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget para(String h, String b) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(h, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(b, style: const TextStyle(height: 1.45, fontSize: 15)),
          ]),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 40), children: [
        para('In short', 'Landed keeps your information on your phone, encrypted. We don’t run ads, use analytics or trackers, or sell data.'),
        para('What stays on your phone',
            'Your profile and photo, checklist, work shifts, spending, deadlines, notes and saved guides. They’re encrypted with AES-256-GCM. The key is held in your phone’s secure Android Keystore. We never receive this data.'),
        para('Optional account',
            'If you choose to sign in, Google Firebase Authentication processes your email address, name and sign-in provider (Google, Facebook or email) so you can sign in. Nothing else is sent. You can delete your account any time in Settings → Account.'),
        para('The helper', 'The Ask helper runs offline. Your questions are not sent anywhere.'),
        para('Location (Food near me)',
            'Only when you tap “Find food near me”, Landed asks for your approximate location, rounds it to about 1 km and sends it to the free OpenStreetMap Overpass service to find nearby places. It isn’t stored. Landed never tracks your location in the background.'),
        para('Links', 'Guides open official websites, maps and partner sites in your browser or apps. Those sites have their own privacy policies. Some bank or SIM links may be referral links and are labelled.'),
        para('Backups', 'Backups are encrypted with a passphrase only you know. Store the file where you like. Without the passphrase it can’t be read, including by us.'),
        para('Your rights', 'Depending on where you live (for example under UK or EU GDPR), you can ask what we hold, correct it or delete it. Because your data stays on your phone, you can see, change and erase it in the app yourself.'),
        para('Contact', 'Landed is a student prototype by Dinakar Nayak N. Questions or requests: open an issue on the project’s GitHub page.'),
        const LinkText('Landed on GitHub', 'https://github.com/Dinakarnayak/settlemate-demo'),
        const SizedBox(height: 12),
        const Text('Last updated 26 November 2026', style: smallText),
      ]),
    );
  }
}
