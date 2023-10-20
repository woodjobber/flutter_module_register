import 'package:flutter/material.dart';
import 'app_localizations.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = AppLocale.defaultLocale ?? const Locale('zh');

  void updateLanguage(String language) async {
    debugPrint('+++++++++++++$language');
    if (language.isEmpty) {
      return;
    }
    if (!AppLocale.delegate.isSupported(Locale(language))) {
      return;
    }
    await AppLocale.load(Locale(language));

    _locale = AppLocale.current.locale;
    notifyListeners();
  }

  Locale get locale => _locale;
}
