const mainPage = """
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:../src/core/services/local/local_service.dart';
import 'package:../src/core/services/purchase/purchase_manager.dart';
import 'package:provider/provider.dart';

import 'src/common/viewModels/language_view_model.dart';
import 'src/common/viewModels/theme_view_model.dart';
import 'src/core/exports/constants_exports.dart';
import 'src/core/services/language/languages/l10n.dart';
import 'src/core/services/navigation/navigation_route.dart';
import 'src/core/services/navigation/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalCaching.init();
  await PurchaseService.instance.init();
  runApp(
    EasyLocalization(
      supportedLocales: AppConstants.supportedLocales,
      path: AppConstants.localePath,
      fallbackLocale: AppConstants.fallbackLocale,
      saveLocale: true,
      useOnlyLangCode: true,
      child: MultiProvider(
        providers: AppConstants.defaultProviders,
        child: const MyApp(),
      ),
    ),
  );

  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        designSize: const Size(430, 932), // TODO change with real design size
        child: MaterialApp(
          title: AppConstants.appName,
          theme: ThemeConstants.lightTheme,
          darkTheme: ThemeConstants.darkTheme,
          debugShowCheckedModeBanner: false,
          themeMode: context.watch<ThemeViewModel>().themeMode,
          initialRoute: NavigationConstants.home,
          onGenerateRoute: NavigationRoute.instance.generateRoute,
          navigatorKey: NavigationService.instance.navigatorKey,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,

          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..animationDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

""";
