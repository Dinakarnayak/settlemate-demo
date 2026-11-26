import 'translations.dart';

/// App languages. Translations are machine-assisted and marked for review by
/// native speakers; English is the fallback for anything missing.
class AppLanguage {
  const AppLanguage(this.code, this.name, this.native, {this.rtl = false});
  final String code;
  final String name;
  final String native;
  final bool rtl;
}

const appLanguages = [
  AppLanguage('en', 'English', 'English'),
  AppLanguage('hi', 'Hindi', 'हिन्दी'),
  AppLanguage('zh', 'Chinese (Simplified)', '简体中文'),
  AppLanguage('es', 'Spanish', 'Español'),
  AppLanguage('ar', 'Arabic', 'العربية', rtl: true),
  AppLanguage('fr', 'French', 'Français'),
];

String _lang = 'en';
String get currentLanguage => _lang;
void setCurrentLanguage(String code) => _lang = appLanguages.any((l) => l.code == code) ? code : 'en';
bool get isRtl => appLanguages.firstWhere((l) => l.code == _lang).rtl;

/// Translates an English UI string. Use {name} placeholders for values:
///   t('{n} left this week', {'n': '6h'})
String t(String english, [Map<String, String>? args]) {
  var s = _lang == 'en' ? english : (translations[_lang]?[english] ?? english);
  if (args != null) {
    args.forEach((k, v) => s = s.replaceAll('{$k}', v));
  }
  return s;
}
