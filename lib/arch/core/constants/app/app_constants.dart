const appConstants = """
import 'package:flutter/material.dart';
import '/src/pages/home/viewModel/home_view_model.dart';
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

  static List<Locale> supportedLocales = const [
    Locale("en", ""),
    Locale("tr", "")
  ];

  static String localePath = "assets/translations";

  static const Locale fallbackLocale = Locale("en", "");
}



""";
