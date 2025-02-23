import 'package:flutter/material.dart';
import 'package:makdumanarchitect/src/pages/home/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';

/// Core application constants and configuration values.
///
/// This class provides centralized access to application-wide constants
/// including app identifiers, configuration values, and default providers.
class AppConstants {
  /// The name of the application
  static const String appName = 'makdumanarchitect';

  /// The default font family used throughout the application
  static const String fontFamily = 'fontFamily';

  /// Default providers used for dependency injection throughout the application.
  ///
  /// This list includes all the core providers that should be available
  /// at the root of the application widget tree.
  static final defaultProviders = [
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(),
    ),
  ];

  /// List of supported locales for application localization
  static List<Locale> supportedLocales = const [
    Locale("en", ""),
    Locale("tr", "")
  ];

  /// Path to the locale files for application localization
  static String localePath = "assets/translations";

  /// Fallback locale used when the device locale is not supported
  static const Locale fallbackLocale = Locale("en", "");
}
