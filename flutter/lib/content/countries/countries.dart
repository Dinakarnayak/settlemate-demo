import 'au.dart';
import 'ca.dart';
import 'country.dart';
import 'de.dart';
import 'fr.dart';
import 'gb.dart';
import 'ie.dart';
import 'nz.dart';
import 'other.dart';
import 'us.dart';

export 'country.dart';

/// Study countries with checked packs, most popular first, then "another country".
const countryPacks = <CountryPack>[gbPack, usPack, caPack, auPack, dePack, iePack, frPack, nzPack, otherPack];

CountryPack packFor(String code) {
  for (final p in countryPacks) {
    if (p.code == code) return p;
  }
  return otherPack;
}
