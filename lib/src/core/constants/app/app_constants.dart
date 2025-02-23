import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/viewModels/language_view_model.dart';
import '../../../common/viewModels/theme_view_model.dart';

// Uygulamayla ilgili temel veriler
class AppConstants {
  static const appName = 'AppName';
  static const fontFamily = 'fontFamily';

  static final defaultProviders = [
    ChangeNotifierProvider<ThemeViewModel>(
      create: (context) => ThemeViewModel(),
    ),
    ChangeNotifierProvider<LanguageViewModel>(
      create: (context) => LanguageViewModel(),
    ),
  ];

  static List<Locale> supportedLocales = const [
    Locale("en", ""),
    Locale("tr", "")
  ];

  static String localePath = "assets/translations";

  static const Locale fallbackLocale = Locale("en", "");
}
