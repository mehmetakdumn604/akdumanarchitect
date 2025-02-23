import 'package:easy_localization/easy_localization.dart';
import 'package:example/src/core/services/local/local_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/exports/constants_exports.dart';
import 'src/core/services/navigation/navigation_route.dart';
import 'src/core/services/navigation/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalCaching.init();
  runApp(
    EasyLocalization(
      path: AppConstants.languagePath,
      supportedLocales: AppConstants.supportedLocales,
      fallbackLocale: AppConstants.fallbackLocale,
      saveLocale: true,
      useOnlyLangCode: true,
      child: MultiProvider(
        providers: AppConstants.defaultProviders,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
        debugShowCheckedModeBanner: false,
        //builder: (context, child) => BuilderWidget(child: child),
        initialRoute: NavigationConstants.home,
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
      ),
    );
  }
}
