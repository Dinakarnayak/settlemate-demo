# Landed Android: one-time setup

Everything here is free. You only need to do it once.

## 1. Release signing key (so updates install over the old app)

1. Open **GitHub → settlemate-demo → Settings → Secrets and variables → Actions → New repository secret**.
2. Add two secrets:
   - `LANDED_KEYSTORE_BASE64`: paste the whole contents of `landed-release.jks.base64.txt`
   - `LANDED_KEYSTORE_PASSWORD`: paste the password from `password.txt`
3. Keep `landed-release.jks` and the password somewhere safe (e.g. a password manager). If you lose them you can't publish updates to the same app.

Until these secrets exist, the build signs with a temporary key and you'll need to uninstall the old version before installing a new one.

Fingerprints of the Landed release key (needed for Firebase in step 2):

- SHA-1: `3F:81:5E:D7:1D:40:D7:F0:65:74:98:9A:A1:65:72:CC:F5:4A:57:D1`
- SHA-256: `2C:CA:A6:C0:29:C2:B4:39:AB:3D:E4:28:04:B1:42:2B:08:5D:20:90:EE:7C:2C:31:37:22:65:D4:F1:F9:12:F2`

## 2. Optional sign-in (Google, Facebook, email) with Firebase

Firebase Authentication's no-cost Spark plan needs no payment card. Don't upgrade to Blaze, and don't enable phone-number sign-in (that's the paid part).

1. Go to <https://console.firebase.google.com>, **Create a project** called `landed`. You can turn Google Analytics **off** (Landed doesn't use it).
2. **Add app → Android**. Package name: `com.dinakarnayak.landed`. Paste the SHA-1 above, then add the SHA-256 in **Project settings → Your apps → Add fingerprint**.
3. Download nothing; instead open **Project settings → General** and note:
   - Web API key → secret `FIREBASE_API_KEY`
   - Android **App ID** (looks like `1:1234:android:abcd`) → secret `FIREBASE_APP_ID`
   - Project number / Sender ID → secret `FIREBASE_SENDER_ID`
   - Project ID → secret `FIREBASE_PROJECT_ID`
4. **Build → Authentication → Get started → Sign-in method**, enable:
   - **Email/Password**
   - **Google** (choose a support email)
   - **Facebook**: needs an App ID and App secret from <https://developers.facebook.com> (create a *Consumer* app, add *Facebook Login*). Paste the OAuth redirect URI Firebase shows into the Facebook app's **Valid OAuth Redirect URIs**. Facebook also needs a privacy policy URL; you can use the in-app policy text on a public page.
5. Add the four `FIREBASE_*` secrets to GitHub (same place as step 1) and push any change, or re-run the **Android APK** workflow.

Sign-in only stores the student's email, name and provider in Firebase. Personal data stays encrypted on the phone.

## 3. Referral links

Edit `flutter/lib/content/referrals.dart` and paste links into `referralUrl`. Links are shown with a "Referral" label and a disclosure. Check with the university's international student advice team before earning rewards while on a Student visa.

## 4. Getting the APK

Every push to `feat/settlemate-android-apk` builds **Landed.apk** under **Actions → Android APK → Artifacts → Landed-Android**. The **Demo video** workflow records a screen video of the app running on an emulator.
