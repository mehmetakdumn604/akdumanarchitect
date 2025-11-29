// ignore_for_file: avoid_classes_with_only_static_members

library makdumanarchitect;

import 'dart:io';

import 'package:makdumanarchitect/arch/core/services/analytics/analytics_service.dart';
import 'package:makdumanarchitect/arch/core/services/purchase/purchase_manager.dart';
import 'package:makdumanarchitect/arch/core/services/remote_config/remote_config_service.dart';

import 'arch/core/base/model/base_model.dart';
import 'arch/core/base/view/base_view.dart';
import 'arch/core/base/viewModel/base_view_model.dart';
import 'arch/core/constants/app/app_constants.dart';
import 'arch/core/constants/colors/color_constants.dart';
import 'arch/core/constants/endPoints/end_point_constants.dart';
import 'arch/core/constants/enums/app_themes_enums.dart';
import 'arch/core/constants/enums/http_types_enums.dart';
import 'arch/core/constants/enums/network_results_enums.dart';
import 'arch/core/constants/local/local_constants.dart';
import 'arch/core/constants/navigation/navigation_constants.dart';
import 'arch/core/constants/textStyles/text_style_constants.dart';
import 'arch/core/constants/theme/theme_constants.dart';
import 'arch/core/exports/constants_exports.dart';
import 'arch/core/extensions/context_extension.dart';
import 'arch/core/extensions/sized_box_extension.dart';
import 'arch/core/mixins/device_orientation.dart';
import 'arch/core/mixins/show_bar.dart';
import 'arch/core/services/local/local_service.dart';
import 'arch/core/services/navigation/navigation_route.dart';
import 'arch/core/services/navigation/navigation_service.dart';
import 'arch/main.dart';
import 'arch/pages/home/model/post_model.dart';
import 'arch/pages/home/model/post_model.g.dart';
import 'arch/pages/home/view/home_view.dart';
import 'arch/pages/home/viewModel/home_view_model.dart';
import 'arch/pages/home/widget/one_item.dart';
import 'scripts/build_sh.dart';

const pubspec = """
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter

  # state management
  provider: ^6.1.1

  # network request
  dio: ^5.4.0

  # local storage
  hive_flutter: ^1.1.0

  # internet connection
  connectivity_plus: ^5.0.2

  # create model easily
  json_annotation: ^4.8.1

  # local notifications
  awesome_notifications: ^0.8.2

  #firebase notifications
  firebase_messaging: ^14.7.10

  # language support
  flutter_localizations:
    sdk: flutter
  easy_localization: ^3.0.7+1

  # in app review package 
  in_app_review: ^2.0.9
  # loading spinner package
  flutter_easyloading: ^3.0.5
  # responsive package
  flutter_screenutil: ^5.9.0
  # svg image package
  flutter_svg: ^2.0.9
  firebase_remote_config: ^4.3.8
  firebase_crashlytics: ^3.4.9
  firebase_analytics: ^10.7.4
  app_tracking_transparency: ^2.0.6
  # purchase package
  purchases_flutter: ^8.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.5
  flutter_lints: ^2.0.1
  json_serializable: ^6.7.0
  # Asset generation
  flutter_gen: ^5.4.0
  flutter_gen_runner:
  # native splash screen
  flutter_native_splash: ^2.4.0
  # app icon
  flutter_launcher_icons: ^0.13.1
  # cache model generator
  hive_generator: ^2.0.1
  # package name change
  #package_rename: ^1.6.0



flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/icons/
    - assets/images/
    - assets/translations/

#To run this package use this command 'flutter pub run build_runner build'
flutter_gen:
  output: lib/src/core/assets_gen/
  line_length: 80

  integrations:
    flutter_svg: true
    lottie: true
    # flare_flutter: true
    # rive: true

# To run this package use this command 'flutter pub run flutter_native_splash:create'
flutter_native_splash:
  color: "#D93B6A"
  image: "assets/images/app_logo.png"
  android: true
  ios: true
  android_gravity: center
  ios_content_mode: center
  fullscreen: true

# To run this package use this command 'flutter pub run flutter_launcher_icons:main'
flutter_launcher_icons:
  android: "ic_launcher"
  ios: true
  image_path: "assets/images/app_logo.png"
  min_sdk_android: 21
  remove_alpha_ios: true

# To run this package use this command 'flutter pub run flutter_package_rename:main'
package_rename_config:
  android:
    app_name: New App Name
    package_name: com.new.app
    override_old_package: com.old.app
  ios:
    app_name: # (String) The display name of the ios app
    bundle_name: # (String) The bundle name of the ios app
    package_name: # (String) The product bundle identifier of the ios app

  """;

class Architecture {
  static Future<void> createArchitecture() async {
    const srcFolder = 'lib/src';
    await Directory(srcFolder).create();
    const assetsFolder = 'assets/';
    await Directory(assetsFolder).create();
    const assetsImagesFolder = 'assets/images/';
    await Directory(assetsImagesFolder).create();
    const assetsIconsFolder = 'assets/icons/';
    await Directory(assetsIconsFolder).create();
    const assetsTranslationsFolder = 'assets/translations/';
    await Directory(assetsTranslationsFolder).create();

    const buildGradleFile = './android/app/build.gradle';
    var lines = await File(buildGradleFile).readAsLines();
    var tempLines = [];
    tempLines.addAll(lines);
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('minSdkVersion')) {
        tempLines[i] = '        minSdkVersion 21';
      }
    }

    await File(buildGradleFile).writeAsString(tempLines.join('\n'));

    const podfileFile = './ios/Podfile';
    var podfileLines = await File(podfileFile).readAsLines();
    var tempPodfileLines = [];
    tempPodfileLines.addAll(podfileLines);
    for (int i = 0; i < podfileLines.length; i++) {
      if (podfileLines[i].contains('#platform :ios, \'12.0\'')) {
        tempPodfileLines[i] = 'platform :ios, \'13.0\'';
        break;
      }
    }

    await File(podfileFile).writeAsString(tempPodfileLines.join('\n'));

    await changePubspecYaml();
    await createTranslationJsons();
    await createCommon();
    await createCore();
    await createPages();
    await createMain();
    await createScripts();
  }

  static Future<void> changePubspecYaml() async {
    // Parse packages from pubspec string
    final List<String> dependencies = [];
    final List<String> devDependencies = [];

    bool inDependencies = false;
    bool inDevDependencies = false;

    for (final line in pubspec.split('\n')) {
      final trimmedLine = line.trim();

      if (trimmedLine == 'dependencies:') {
        inDependencies = true;
        inDevDependencies = false;
        continue;
      }

      if (trimmedLine == 'dev_dependencies:') {
        inDependencies = false;
        inDevDependencies = true;
        continue;
      }

      if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
        continue;
      }

      // Skip flutter SDK dependencies
      if (trimmedLine.contains('sdk:') || trimmedLine.contains('flutter:')) {
        continue;
      }

      // Extract package name (format: package_name: version)
      if (trimmedLine.contains(':')) {
        final packageName = trimmedLine.split(':')[0].trim();
        if (packageName.isNotEmpty) {
          if (inDependencies) {
            dependencies.add(packageName);
          } else if (inDevDependencies) {
            devDependencies.add(packageName);
          }
        }
      }
    }

    // Run flutter pub add for dependencies
    if (dependencies.isNotEmpty) {
      final result = await Process.run(
        'flutter',
        ['pub', 'add', ...dependencies],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        print('Error adding dependencies: ${result.stderr}');
      }
    }

    // Run flutter pub add --dev for dev_dependencies
    if (devDependencies.isNotEmpty) {
      final result = await Process.run(
        'flutter',
        ['pub', 'add', '--dev', ...devDependencies],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        print('Error adding dev dependencies: ${result.stderr}');
      }
    }
  }

  static Future<void> createTranslationJsons() async {
    const translationsFolder = 'assets/translations/';

    // viewModels
    const enJson = '$translationsFolder/en.json';
    await File(enJson).create();
    await File(enJson).writeAsString("""
{
  "hello": "Hello"
}
""");

    const trJson = '$translationsFolder/tr.json';
    await File(trJson).create();
    await File(trJson).writeAsString("""
{
  "hello": "Merhaba"
}
""");

    const controllers2 = '$translationsFolder/tr.json';
    await File(controllers2).create();
    await File(controllers2).writeAsString("""
{
  "hello": "Merhaba"
}
""");
  }

  static Future<void> createCommon() async {
    const common = 'lib/src/common';
    await Directory(common).create();

    // viewModels
    const controllers = '$common/viewModels';
    await Directory(controllers).create();

    // widgets
    const widgets = '$common/widgets';
    await Directory(widgets).create();

    // models
    const models = '$common/models';
    await Directory(models).create();
  }

  static Future<void> createCore() async {
    const core = 'lib/src/core';
    await Directory(core).create();

    // base
    const base = '$core/base';
    await Directory(base).create();

    // base model
    const baseModelI = '$base/model';
    await Directory(baseModelI).create();
    await File('$baseModelI/base_model.dart').writeAsString(baseModel);

    // base view
    const baseViewI = '$base/view';
    await Directory(baseViewI).create();
    await File('$baseViewI/base_view.dart').writeAsString(baseView);

    // base view model
    const baseViewModelI = '$base/viewModel';
    await Directory(baseViewModelI).create();
    await File('$baseViewModelI/base_view_model.dart').writeAsString(baseViewModel);

    // constants
    const constants = '$core/constants';
    await Directory(constants).create();

    // app constants
    const appConstantsI = '$constants/app';
    await Directory(appConstantsI).create();
    await File('$appConstantsI/app_constants.dart').writeAsString(appConstants);

    // color constants
    const colorConstantsI = '$constants/colors';
    await Directory(colorConstantsI).create();
    await File('$colorConstantsI/color_constants.dart').writeAsString(colorConstants);

    // endPoint constants
    const endPointConstantsI = '$constants/endPoints';
    await Directory(endPointConstantsI).create();
    await File('$endPointConstantsI/end_point_constants.dart').writeAsString(endPointConstants);

    // enums
    const enums = '$constants/enums';
    await Directory(enums).create();
    await File('$enums/app_themes_enums.dart').writeAsString(appThemesEnums);
    await File('$enums/http_types_enums.dart').writeAsString(httpTypesEnums);
    await File('$enums/network_results_enums.dart').writeAsString(networkResultEnums);

    // navigation constants
    const navigationConstantsI = '$constants/navigation';
    await Directory(navigationConstantsI).create();
    await File('$navigationConstantsI/navigation_constants.dart')
        .writeAsString(navigationConstants);

    // text styles constants
    const testStyleConstantsI = '$constants/textStyles';
    await Directory(testStyleConstantsI).create();
    await File('$testStyleConstantsI/text_style_constants.dart').writeAsString(textStyleConstants);

    // theme constants
    const themeConstantsI = '$constants/theme';
    await Directory(themeConstantsI).create();
    await File('$themeConstantsI/theme_constants.dart').writeAsString(themeConstants);

    // local constants
    const localConstantsI = '$constants/local';
    await Directory(localConstantsI).create();
    await File('$localConstantsI/local_constants.dart').writeAsString(localConstants);

    // // image constants
    // const notificationConstantsI = '$constants/notification';
    // await Directory(notificationConstantsI).create();
    // await File('$notificationConstantsI/notification_constants.dart').writeAsString(notificationConstants);

    // exports
    const exports = '$core/exports';
    await Directory(exports).create();
    await File('$exports/constants_exports.dart').writeAsString(constantExports);

    // extensions
    const extensions = '$core/extensions';
    await Directory(extensions).create();
    await File('$extensions/context_extension.dart').writeAsString(contextExtension);
    await File('$extensions/sized_box_extension.dart').writeAsString(sizedBoxExtension);

    // mixins
    const mixins = '$core/mixins';
    await Directory(mixins).create();
    await File('$mixins/device_orientation.dart').writeAsString(deviceOrientation);
    await File('$mixins/show_bar.dart').writeAsString(showBar);

    // services
    const services = '$core/services';
    await Directory(services).create();

    // analytics service
    const analyticsServicePath = '$services/analytics';
    await Directory(analyticsServicePath).create();
    await File('$analyticsServicePath/analytics_service.dart').writeAsString(analyticsService);

    // connection service
    /*
    const connectionServiceI = '$services/connection';
    await Directory(connectionServiceI).create();
    await File('$connectionServiceI/connection_service.dart')
        .writeAsString(connectionService);

    const connectionServicesPackages = '$connectionServiceI/packages';
    await Directory(connectionServicesPackages).create();
    await File('$connectionServicesPackages/connectivity_service.dart')
        .writeAsString(connectivityService);
    await File(
            '$connectionServicesPackages/internet_connection_checker_service.dart')
        .writeAsString(internetConnectionCheckerService);
     */

    // local service
    const localServiceI = '$services/local';
    await Directory(localServiceI).create();
    await File('$localServiceI/local_service.dart').writeAsString(localService);

    // navigation service
    const navigationServiceI = '$services/navigation';
    await Directory(navigationServiceI).create();
    await File('$navigationServiceI/navigation_service.dart').writeAsString(navigationService);
    await File('$navigationServiceI/navigation_route.dart').writeAsString(navigationRoute);

    // purchase service
    const purchaseServicePath = '$services/purchase';
    await Directory(purchaseServicePath).create();
    await File('$purchaseServicePath/purchase_manager.dart').writeAsString(purchaseManager);

    // remote config service
    const remoteConfigService = '$services/remote_config';
    await Directory(remoteConfigService).create();
    await File('$remoteConfigService/remote_config_service.dart')
        .writeAsString(remoteConfigServiceString);

    // // theme service
    // const themeServiceI = '$services/theme';
    // await Directory(themeServiceI).create();
    // await File('$themeServiceI/theme_service.dart').writeAsString(themeService);
  }

  static Future<void> createPages() async {
    const pages = 'lib/src/pages';
    await Directory(pages).create();

    // home page
    const homePage = '$pages/home';
    await Directory(homePage).create();

    // home model
    const homeModel = '$homePage/model';
    await Directory(homeModel).create();
    await File('$homeModel/post_model.dart').writeAsString(postModel);
    await File('$homeModel/post_model.g.dart').writeAsString(postModelG);

    // home view
    const homeViewI = '$homePage/view';
    await Directory(homeViewI).create();
    await File('$homeViewI/home_view.dart').writeAsString(homeView);

    // home viewModel
    const homeViewModelI = '$homePage/viewModel';
    await Directory(homeViewModelI).create();
    await File('$homeViewModelI/home_view_model.dart').writeAsString(homeViewModel);

    // home widget
    const homeWidget = '$homePage/widget';
    await Directory(homeWidget).create();
    await File('$homeWidget/one_item.dart').writeAsString(oneItem);
  }

  static Future<void> createMain() async {
    await File('lib/main.dart').writeAsString(mainPage);
  }

  static Future<void> createScripts() async {
    const scripts = 'scripts';
    await Directory(scripts).create();
    await File('$scripts/build.sh').writeAsString(script);
  }
}
