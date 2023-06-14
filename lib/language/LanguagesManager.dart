import 'dart:async';
import 'dart:ui';

import 'package:fresh_fruit/language/builder/LangBuilder.dart';

import 'builder/EnLangBuilder.dart';
import 'builder/ViLangBuilder.dart';

class LanguagesManager {
  final List<LangBuilder> _langBuilders = [EnLangBuilder(), ViLangBuilder()];
  LangBuilder _currentLangBuilder = ViLangBuilder();

  VoidCallback? _onLocaleChangedCallback;

  LangBuilder get language => _currentLangBuilder;

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  static final LanguagesManager _languagesManager =
      LanguagesManager._internal();

  factory LanguagesManager() {
    return _languagesManager;
  }

  LanguagesManager._internal();
}

//class LocalesDelegate extends LocalizationsDelegate<GlobalLocales> {
//  const LocalesDelegate();
//
//  @override
//  bool isSupported(Locale locale) =>
//      locales.supportedLocales().contains(locale);
//
//  @override
//  Future<GlobalLocales> load(Locale locale) =>
//      locales.setNewLanguage(locale.languageCode);
//
//  @override
//  bool shouldReload(LocalesDelegate old) => false;
//}

final LanguagesManager locale = LanguagesManager();
