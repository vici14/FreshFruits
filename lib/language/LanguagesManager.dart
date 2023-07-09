import 'dart:async';
import 'dart:ui';

import 'package:fresh_fruit/const.dart';
import 'package:fresh_fruit/language/builder/LangBuilder.dart';
import 'package:fresh_fruit/service/storage_service.dart';
import 'package:fresh_fruit/utils/StringUtils.dart';

import 'builder/EnLangBuilder.dart';
import 'builder/ViLangBuilder.dart';

class LanguagesManager {
  final Map<String, dynamic> _langBuilders = {
    'vi_VN': ViLangBuilder(),
    'en_EN': EnLangBuilder(),
  };
  LangBuilder _currentLangBuilder = ViLangBuilder();

  VoidCallback? _onLocaleChangedCallback;

  LangBuilder get language => _currentLangBuilder;

  set onLocaleChangedCallback(VoidCallback callback) {
    _onLocaleChangedCallback = callback;
  }

  Future<bool> init() async {
    String? cacheLanguage = StorageService.shared.getString(LANGUAGE_CODE);
    if (cacheLanguage.isNotNullAndEmpty()) {
      _currentLangBuilder = _langBuilders[cacheLanguage];
    } else {
      await StorageService.shared.setString(
        LANGUAGE_CODE,
        _langBuilders.keys.firstWhere(
          (lang) => _langBuilders[lang] == _currentLangBuilder,
          orElse: () => _langBuilders.keys.first,
        ),
      );
    }
    return cacheLanguage == _langBuilders.keys.first ? true : false;
  }

  void changeLanguage(bool value) {
    _currentLangBuilder = value ? ViLangBuilder() : EnLangBuilder();
    StorageService.shared.setString(
      LANGUAGE_CODE,
      value ? _langBuilders.keys.first : _langBuilders.keys.last,
    );
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
