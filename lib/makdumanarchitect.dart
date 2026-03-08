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
  json_serializable: ^6.7.1
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

class DependencyConfig {
  const DependencyConfig({
    required this.name,
    required this.isDev,
    required this.isCore,
    required this.description,
  });

  final String name;
  final bool isDev;
  final bool isCore;
  final String description;
}

/// Tracks which optional packages were selected (key = offered name, value = package to add or null if skipped).
class SelectedPackages {
  const SelectedPackages({required this.optionalChoices});

  final Map<String, String?> optionalChoices;

  bool has(String packageName) => optionalChoices[packageName] != null;
}

DependencyConfig _buildDependencyConfig(String name, {required bool isDev}) {
  switch (name) {
    case 'provider':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'State management with Provider.',
      );
    case 'dio':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'HTTP client for network requests.',
      );
    case 'hive_flutter':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Local storage with Hive.',
      );
    case 'connectivity_plus':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Network connectivity status.',
      );
    case 'json_annotation':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Model annotations for JSON serialization.',
      );
    case 'flutter_easyloading':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Loading indicator widgets.',
      );
    case 'flutter_screenutil':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Responsive layout utilities.',
      );
    case 'flutter_svg':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'SVG image rendering.',
      );
    case 'build_runner':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Code generation runner.',
      );
    case 'flutter_lints':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Recommended lints for Flutter projects.',
      );
    case 'json_serializable':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'JSON serialization code generator.',
      );
    case 'flutter_gen':
    case 'flutter_gen_runner':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Asset generation utilities.',
      );
    case 'hive_generator':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Hive type adapter generator.',
      );
    case 'easy_localization':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Localization and translation support.',
      );
    case 'awesome_notifications':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Local notification management.',
      );
    case 'firebase_messaging':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Firebase Cloud Messaging (push notifications).',
      );
    case 'in_app_review':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'In-app review prompts.',
      );
    case 'firebase_remote_config':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Remote configuration from Firebase.',
      );
    case 'firebase_crashlytics':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Crash reporting with Firebase Crashlytics.',
      );
    case 'firebase_analytics':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Analytics with Firebase Analytics.',
      );
    case 'app_tracking_transparency':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'App tracking transparency (iOS ATT).',
      );
    case 'purchases_flutter':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'In-app purchases and subscriptions.',
      );
    case 'flutter_native_splash':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'Native splash screen generation.',
      );
    case 'flutter_launcher_icons':
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: false,
        description: 'App launcher icon generation.',
      );
    default:
      return DependencyConfig(
        name: name,
        isDev: isDev,
        isCore: true,
        description: 'Dependency used by the generated architecture.',
      );
  }
}

/// Code generator that creates a clean architecture scaffold in a Flutter project.
class Architecture {
  /// Generates the folder structure, core files, and configuration into the current Flutter project.
  static Future<void> createArchitecture() async {
    final String bundleId = _askForBundleId();
    final String appName = _askForAppName();
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

    const buildGradleKtsPath = './android/app/build.gradle.kts';
    const buildGradlePath = './android/app/build.gradle';
    final File androidBuildFile = File(buildGradleKtsPath).existsSync()
        ? File(buildGradleKtsPath)
        : File(buildGradlePath);
    final List<String> lines = await androidBuildFile.readAsLines();
    final List<String> tempLines = List<String>.from(lines);
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('minSdk =')) {
        tempLines[i] = '        minSdk = 21';
      } else if (lines[i].contains('minSdkVersion')) {
        tempLines[i] = '        minSdkVersion 21';
      } else if (lines[i].contains('applicationId =')) {
        tempLines[i] = '        applicationId = "$bundleId"';
      } else if (lines[i].contains('applicationId "')) {
        tempLines[i] = '        applicationId "$bundleId"';
      }
    }
    await androidBuildFile.writeAsString(tempLines.join('\n'));

    await _applyAndroidAppName(appName);
    await _applyIosBundleIdAndFixBridgingHeaderError(bundleId, appName);

    const String podfileFile = './ios/Podfile';
    final File podfile = File(podfileFile);
    if (podfile.existsSync()) {
      final List<String> podfileLines = await podfile.readAsLines();
      final List<String> tempPodfileLines = List<String>.from(podfileLines);
      for (int i = 0; i < podfileLines.length; i++) {
        final String trimmed = podfileLines[i].trim();
        if (trimmed.startsWith('# platform :ios') ||
            trimmed.startsWith('platform :ios')) {
          tempPodfileLines[i] = "platform :ios, '15.0'";
          break;
        }
      }
      await podfile.writeAsString(tempPodfileLines.join('\n'));
    }

    final SelectedPackages selected = await changePubspecYaml();
    await createTranslationJsons(selected);
    await createCommon();
    await createCore(selected);
    await createPages();
    await createMain(selected);
    await createScripts();
  }

  static Future<SelectedPackages> changePubspecYaml() async {
    final List<DependencyConfig> dependencyConfigs = <DependencyConfig>[];
    final Map<String, String> packageVersions = <String, String>{};

    bool inDependencies = false;
    bool inDevDependencies = false;

    for (final String line in pubspec.split('\n')) {
      final String trimmedLine = line.trim();

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

      if (!line.startsWith(' ') &&
          !line.startsWith('\t') &&
          trimmedLine.endsWith(':') &&
          trimmedLine != 'dependencies:' &&
          trimmedLine != 'dev_dependencies:') {
        inDependencies = false;
        inDevDependencies = false;
        continue;
      }

      if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
        continue;
      }

      if (!inDependencies && !inDevDependencies) {
        continue;
      }

      if (trimmedLine.contains('sdk:')) {
        continue;
      }

      if (trimmedLine == 'flutter:') {
        continue;
      }

      if (trimmedLine.startsWith('flutter_test:')) {
        continue;
      }

      if (trimmedLine.contains(':')) {
        final int colonIndex = trimmedLine.indexOf(':');
        if (colonIndex > 0) {
          final String packageName = trimmedLine.substring(0, colonIndex).trim();
          final String versionPart = trimmedLine.substring(colonIndex + 1).trim();

          if (packageName.isEmpty ||
              packageName == 'flutter' ||
              packageName == 'flutter_test' ||
              packageName.contains(' ')) {
            continue;
          }

          if (!RegExp(r'^[a-z][a-z0-9_\-]*$').hasMatch(packageName)) {
            continue;
          }

          if (versionPart.isEmpty ||
              versionPart.contains('sdk') ||
              versionPart.trim().isEmpty) {
            continue;
          }

          if (versionPart.startsWith('^') ||
              versionPart.startsWith('~') ||
              RegExp(r'^\d+\.\d+').hasMatch(versionPart)) {
            final DependencyConfig config = _buildDependencyConfig(
              packageName,
              isDev: inDevDependencies,
            );
            dependencyConfigs.add(config);
            packageVersions[packageName] = versionPart.trim();
          }
        }
      }
    }

    final List<String> dependencies = <String>[];
    final List<String> devDependencies = <String>[];
    final Map<String, String?> optionalChoices = <String, String?>{};

    for (final DependencyConfig config in dependencyConfigs) {
      if (!config.isCore) {
        continue;
      }

      if (config.isDev) {
        devDependencies.add(config.name);
      } else {
        dependencies.add(config.name);
      }
    }

    for (final DependencyConfig config in dependencyConfigs) {
      if (config.isCore) {
        continue;
      }

      final String? selectedName = _askUserForOptionalDependency(config);
      optionalChoices[config.name] = selectedName;
      if (selectedName == null || selectedName.isEmpty) {
        continue;
      }

      if (config.isDev) {
        devDependencies.add(selectedName);
      } else {
        dependencies.add(selectedName);
      }
    }

    final List<String> uniqueDependencies = dependencies.toSet().toList();
    final List<String> uniqueDevDependencies = devDependencies.toSet().toList();

    final List<String> depArgs = uniqueDependencies
        .map((String p) => packageVersions.containsKey(p)
            ? '$p:${packageVersions[p]}'
            : p)
        .toList();
    final List<String> devDepArgs = uniqueDevDependencies
        .map((String p) => packageVersions.containsKey(p)
            ? '$p:${packageVersions[p]}'
            : p)
        .toList();

    // ignore: avoid_print
    print('Parsed dependencies: ${uniqueDependencies.join(', ')}');
    // ignore: avoid_print
    print('Parsed dev_dependencies: ${uniqueDevDependencies.join(', ')}');

    if (depArgs.isNotEmpty) {
      ProcessResult result = await Process.run(
        'flutter',
        <String>['pub', 'add', ...depArgs],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        // ignore: avoid_print
        print('Batch add failed, trying one-by-one...');
        for (final String pkg in uniqueDependencies) {
          final String arg =
              packageVersions.containsKey(pkg) ? '$pkg:${packageVersions[pkg]}' : pkg;
          result = await Process.run(
            'flutter',
            <String>['pub', 'add', arg],
            workingDirectory: Directory.current.path,
          );
          if (result.exitCode != 0) {
            // ignore: avoid_print
            print('Warning: Could not add $pkg: ${result.stderr}');
          }
        }
      }
    }

    if (devDepArgs.isNotEmpty) {
      ProcessResult result = await Process.run(
        'flutter',
        <String>['pub', 'add', '--dev', ...devDepArgs],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        // ignore: avoid_print
        print('Batch add failed, trying one-by-one...');
        for (final String pkg in uniqueDevDependencies) {
          final String arg =
              packageVersions.containsKey(pkg) ? '$pkg:${packageVersions[pkg]}' : pkg;
          result = await Process.run(
            'flutter',
            <String>['pub', 'add', '--dev', arg],
            workingDirectory: Directory.current.path,
          );
          if (result.exitCode != 0) {
            // ignore: avoid_print
            print('Warning: Could not add $pkg: ${result.stderr}');
          }
        }
      }
    }

    await _ensureFlutterAssetsInPubspec();
    return SelectedPackages(optionalChoices: optionalChoices);
  }

  static Future<void> _ensureFlutterAssetsInPubspec() async {
    final File pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      return;
    }

    final List<String> lines = await pubspecFile.readAsLines();
    final List<String> updatedLines = List<String>.from(lines);

    const String flutterHeader = 'flutter:';
    const String assetsHeader = '  assets:';
    const List<String> desiredAssets = <String>[
      '    - assets/icons/',
      '    - assets/images/',
      '    - assets/translations/',
    ];

    final int flutterIndex = updatedLines.indexWhere(
      (String line) => line.trim() == flutterHeader,
    );

    if (flutterIndex == -1) {
      updatedLines.add('');
      updatedLines.add(flutterHeader);
      updatedLines.add(assetsHeader);
      updatedLines.addAll(desiredAssets);
      await pubspecFile.writeAsString(updatedLines.join('\n'));
      return;
    }

    int insertIndex = flutterIndex + 1;
    int index = flutterIndex + 1;
    int assetsIndex = -1;

    while (index < updatedLines.length) {
      final String line = updatedLines[index];
      if (!line.startsWith(' ') && line.trim().isNotEmpty) {
        insertIndex = index;
        break;
      }

      if (line.trim() == 'assets:' && line.startsWith('  ')) {
        assetsIndex = index;
      }

      index++;
    }

    final Set<String> existingAssets = <String>{};

    if (assetsIndex != -1) {
      int assetLineIndex = assetsIndex + 1;
      while (assetLineIndex < updatedLines.length &&
          updatedLines[assetLineIndex].startsWith('    - ')) {
        existingAssets.add(updatedLines[assetLineIndex].trim());
        assetLineIndex++;
      }

      final List<String> missingAssets = <String>[];
      for (final String assetEntry in desiredAssets) {
        if (!existingAssets.contains(assetEntry.trim())) {
          missingAssets.add(assetEntry);
        }
      }

      if (missingAssets.isEmpty) {
        return;
      }

      updatedLines.insertAll(assetLineIndex, missingAssets);
      await pubspecFile.writeAsString(updatedLines.join('\n'));
      return;
    }

    updatedLines.insert(insertIndex, assetsHeader);
    updatedLines.insertAll(insertIndex + 1, desiredAssets);
    await pubspecFile.writeAsString(updatedLines.join('\n'));
  }

  static String? _askUserForOptionalDependency(DependencyConfig config) {
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print(
      'Package: ${config.name} (${config.isDev ? 'dev' : 'runtime'})\n'
      'Description: ${config.description}',
    );
    // ignore: avoid_print
    print(
      'Add this package? [y]es / [n]o / [c]ustom package instead:',
    );

    final String answer = stdin.readLineSync()?.trim().toLowerCase() ?? '';

    if (answer == 'n' || answer == 'no') {
      return null;
    }

    if (answer == 'c' || answer == 'custom') {
      // ignore: avoid_print
      print(
        'Enter the package to add (for example `easy_localization` or `easy_localization:^3.0.7+1`).\n'
        'Leave empty to skip:',
      );
      final String custom = stdin.readLineSync()?.trim() ?? '';
      if (custom.isEmpty) {
        return null;
      }
      return custom;
    }

    return config.name;
  }

  static Future<void> createTranslationJsons(SelectedPackages selected) async {
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

  static Future<void> createCore(SelectedPackages selected) async {
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

    // analytics service (firebase_analytics)
    if (selected.has('firebase_analytics')) {
      const analyticsServicePath = '$services/analytics';
      await Directory(analyticsServicePath).create();
      await File('$analyticsServicePath/analytics_service.dart').writeAsString(analyticsService);
    }

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

    // purchase service (purchases_flutter)
    if (selected.has('purchases_flutter')) {
      const purchaseServicePath = '$services/purchase';
      await Directory(purchaseServicePath).create();
      await File('$purchaseServicePath/purchase_manager.dart').writeAsString(purchaseManager);
    }

    // remote config service (firebase_remote_config)
    if (selected.has('firebase_remote_config')) {
      const remoteConfigService = '$services/remote_config';
      await Directory(remoteConfigService).create();
      await File('$remoteConfigService/remote_config_service.dart')
          .writeAsString(remoteConfigServiceString);
    }

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

  static Future<void> createMain(SelectedPackages selected) async {
    final String content = _buildMainPageContent(selected);
    await File('lib/main.dart').writeAsString(content);
  }

  static String _buildMainPageContent(SelectedPackages selected) {
    final bool useEasyLocalization = selected.has('easy_localization');
    final bool usePurchaseManager = selected.has('purchases_flutter');

    final StringBuffer imports = StringBuffer()
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:flutter_easyloading/flutter_easyloading.dart';")
      ..writeln("import 'package:flutter_screenutil/flutter_screenutil.dart';")
      ..writeln("import 'package:provider/provider.dart';")
      ..writeln()
      ..writeln("import 'src/core/exports/constants_exports.dart';")
      ..writeln("import 'src/core/services/local/local_service.dart';")
      ..writeln("import 'src/core/services/navigation/navigation_route.dart';")
      ..writeln("import 'src/core/services/navigation/navigation_service.dart';");
    if (useEasyLocalization) {
      imports.writeln("import 'package:easy_localization/easy_localization.dart';");
    }
    if (usePurchaseManager) {
      imports.writeln("import 'src/core/services/purchase/purchase_manager.dart';");
    }

    final StringBuffer mainBody = StringBuffer()
      ..writeln('void main() async {')
      ..writeln('  WidgetsFlutterBinding.ensureInitialized();');
    if (useEasyLocalization) {
      mainBody.writeln('  await EasyLocalization.ensureInitialized();');
    }
    mainBody.writeln('  await LocalCaching.init();');
    if (usePurchaseManager) {
      mainBody.writeln('  await PurchaseManager.initRevenueCat();');
    }
    mainBody.writeln('  runApp(');

    if (useEasyLocalization) {
      mainBody.writeln('    EasyLocalization(');
      mainBody.writeln('      supportedLocales: AppConstants.supportedLocales,');
      mainBody.writeln('      path: AppConstants.localePath,');
      mainBody.writeln('      fallbackLocale: AppConstants.fallbackLocale,');
      mainBody.writeln('      saveLocale: true,');
      mainBody.writeln('      useOnlyLangCode: true,');
      mainBody.writeln('      child: MultiProvider(');
    } else {
      mainBody.writeln('    MultiProvider(');
    }
    mainBody.writeln('        providers: AppConstants.defaultProviders,');
    mainBody.writeln('        child: const MyApp(),');
    mainBody.writeln('      ),');
    if (useEasyLocalization) {
      mainBody.writeln('    ),');
    }
    mainBody.writeln('  );');
    mainBody.writeln();
    mainBody.writeln('  configLoading();');
    mainBody.writeln('}');

    final StringBuffer materialAppParams = StringBuffer()
      ..writeln('          title: AppConstants.appName,')
      ..writeln('          theme: ThemeConstants.lightTheme,')
      ..writeln('          darkTheme: ThemeConstants.darkTheme,')
      ..writeln('          debugShowCheckedModeBanner: false,')
      ..writeln('          initialRoute: NavigationConstants.home,')
      ..writeln('          onGenerateRoute: NavigationRoute.instance.generateRoute,')
      ..writeln('          navigatorKey: NavigationService.instance.navigatorKey,');
    if (useEasyLocalization) {
      materialAppParams.writeln('          supportedLocales: context.supportedLocales,');
      materialAppParams.writeln('          locale: context.locale,');
      materialAppParams.writeln('          localizationsDelegates: context.localizationDelegates,');
    }
    materialAppParams.writeln('          builder: EasyLoading.init(),');

    return '''
$imports

$mainBody

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        designSize: const Size(430, 932), // TODO change with real design size
        child: MaterialApp(
$materialAppParams
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
''';
  }

  static Future<void> createScripts() async {
    const scripts = 'scripts';
    await Directory(scripts).create();
    await File('$scripts/build.sh').writeAsString(script);
  }

  static String _askForBundleId() {
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print(
      'Enter your app Bundle ID / Application ID (e.g. com.company.appname):',
    );
    // ignore: avoid_print
    print('Leave empty to keep default (com.example.example):');
    final String input = stdin.readLineSync()?.trim() ?? '';
    if (input.isEmpty) {
      return 'com.example.example';
    }
    return input;
  }

  static String _askForAppName() {
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('Enter your app name (display name for iOS and Android):');
    // ignore: avoid_print
    print('Leave empty to keep default (AppName):');
    final String input = stdin.readLineSync()?.trim() ?? '';
    if (input.isEmpty) {
      return 'AppName';
    }
    return input;
  }

  static Future<void> _applyIosBundleIdAndFixBridgingHeaderError(
    String bundleId,
    String appName,
  ) async {
    await _applyIosBundleId(
      pbxFile: File('ios/Runner.xcodeproj/project.pbxproj'),
      bundleId: bundleId,
    );
    await _applyIosAppName(appName);
    await _addBuildLibraryForDistributionFix();
    await _addPodfileBuildLibraryFix();
  }

  static Future<void> _applyIosBundleId({
    required File pbxFile,
    required String bundleId,
  }) async {
    if (!pbxFile.existsSync()) {
      return;
    }
    final List<String> lines = await pbxFile.readAsLines();
    final List<String> updated = <String>[];
    for (final String line in lines) {
      if (line.contains('PRODUCT_BUNDLE_IDENTIFIER = ')) {
        updated.add(
          line.replaceFirst(
            RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]+'),
            'PRODUCT_BUNDLE_IDENTIFIER = $bundleId',
          ),
        );
        continue;
      }
      updated.add(line);
    }
    await pbxFile.writeAsString(updated.join('\n'));
  }

  static Future<void> _addBuildLibraryForDistributionFix() async {
    final File pbxFile = File('ios/Runner.xcodeproj/project.pbxproj');
    if (!pbxFile.existsSync()) {
      return;
    }
    String content = await pbxFile.readAsString();
    if (content.contains('BUILD_LIBRARY_FOR_DISTRIBUTION')) {
      return;
    }
    content = content.replaceAll(
      'SWIFT_VERSION = 5.0;',
      'BUILD_LIBRARY_FOR_DISTRIBUTION = NO;\n\t\t\t\t\t\tSWIFT_VERSION = 5.0;',
    );
    await pbxFile.writeAsString(content);
  }

  static Future<void> _applyAndroidAppName(String appName) async {
    final File manifestFile = File('android/app/src/main/AndroidManifest.xml');
    if (!manifestFile.existsSync()) {
      return;
    }

    final List<String> lines = await manifestFile.readAsLines();
    final List<String> updated = <String>[];

    for (final String line in lines) {
      if (line.contains('android:label=')) {
        updated.add(
          line.replaceFirst(
            RegExp(r'android:label=\"[^\"]*\"'),
            'android:label=\"$appName\"',
          ),
        );
        continue;
      }
      updated.add(line);
    }

    await manifestFile.writeAsString(updated.join('\n'));
  }

  static Future<void> _applyIosAppName(String appName) async {
    final File infoPlist = File('ios/Runner/Info.plist');
    if (!infoPlist.existsSync()) {
      return;
    }
    String content = await infoPlist.readAsString();

    if (content.contains('<key>CFBundleName</key>')) {
      content = content.replaceFirst(
        RegExp(r'<key>CFBundleName</key>\s*<string>[^<]*</string>'),
        '<key>CFBundleName</key>\n\t<string>$appName</string>',
      );
    }

    if (content.contains('<key>CFBundleDisplayName</key>')) {
      content = content.replaceFirst(
        RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]*</string>'),
        '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
      );
    } else {
      content = content.replaceFirst(
        '</dict>',
        '\t<key>CFBundleDisplayName</key>\n'
        '\t<string>$appName</string>\n'
        '</dict>',
      );
    }

    await infoPlist.writeAsString(content);
  }

  static Future<void> _addPodfileBuildLibraryFix() async {
    final File podfile = File('ios/Podfile');
    if (!podfile.existsSync()) {
      return;
    }
    String content = await podfile.readAsString();
    if (content.contains("BUILD_LIBRARY_FOR_DISTRIBUTION")) {
      return;
    }
    const String toInsert =
        '\n    target.build_configurations.each do |config|\n'
        '      config.build_settings[\'BUILD_LIBRARY_FOR_DISTRIBUTION\'] = \'NO\'\n'
        '    end';
    const String search = 'flutter_additional_ios_build_settings(target)';
    final String replacement = search + toInsert;
    if (content.contains(search)) {
      content = content.replaceFirst(search, replacement);
      await podfile.writeAsString(content);
    }
  }
}
