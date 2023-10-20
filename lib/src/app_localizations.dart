import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmkv/mmkv.dart';

class AppLocale {
  final Locale locale;
  AppLocale(this.locale);

  static AppLocale? _current;

  static AppLocale get current {
    assert(_current != null,
        'No instance of M was loaded. Try to initialize the M delegate before accessing M.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Map<String, Map<String, String>> _localizations = {};
  static AppLocale of(BuildContext context) {
    final instance = AppLocale.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocale? maybeOf(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale);
  }

  Future<void> loadJson() async {
    if (_localizations.isNotEmpty) {
      return;
    }
    final json = await rootBundle.loadString('assets/json/i18n.json');
    debugPrint(json);
    Map<String, dynamic> map = jsonDecode(json);
    _localizations =
        map.map((key, value) => MapEntry(key, value.cast<String, String>()));
  }

  static Future<AppLocale> load(Locale locale) async {
    final appLocal = AppLocale(locale);
    await appLocal.loadJson();
    AppLocale._current = appLocal;
    final mmkv = MMKV.defaultMMKV();
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    mmkv.encodeString('language', name);
    return appLocal;
  }

  static Locale? get defaultLocale {
    final mmkv = MMKV.defaultMMKV();
    final name = mmkv.decodeString('language') ?? '';
    if (name.isEmpty) {
      return null;
    }
    if (name.contains('_')) {
      final list = name.split('_');
      return Locale(list.first, list.last);
    }
    return Locale(name);
  }

  String get title => _localizations[locale.languageCode]!['title']!;
  String get settingLanguageEnglish =>
      _localizations[locale.languageCode]!['settingLanguageEnglish']!;
  String get settingLanguageChinese =>
      _localizations[locale.languageCode]!['settingLanguageChinese']!;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocale> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocale> load(Locale locale) => AppLocale.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) {
    return true;
  }
}
