import 'package:example/src/pages/home/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Uygulamayla ilgili temel veriler
class AppConstants {
  static const appName = 'AppName';
  static const fontFamily = 'fontFamily';

  static final defaultProviders = [
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
    ),
  ];

  static const String languagePath = "assets/translations";

  static const List<Locale> supportedLocales = [
    Locale("en", ""),
    Locale("tr", "")
  ];

  static const Locale fallbackLocale = Locale("en", "");
}
