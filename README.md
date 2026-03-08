# MakdumanArchitect

A powerful Flutter package that implements Clean Architecture principles, providing a robust and scalable project structure with essential features out of the box.

[![Pub Version](https://img.shields.io/pub/v/makdumanarchitect.svg)](https://pub.dev/packages/makdumanarchitect)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features 🚀

- ✅ Clean Architecture folder structure
- ✅ **Automatic package installation** - Uses `flutter pub add` for automatic version resolution
- ✅ Pre-configured state management with Provider
- ✅ Network handling with Dio
- ✅ Local storage with Hive
- ✅ Internet connectivity management
- ✅ Firebase integration (Remote Config, Analytics, Crashlytics)
- ✅ Push notifications (Firebase Messaging & Awesome Notifications)
- ✅ Internationalization support with easy_localization
- ✅ In-app review integration
- ✅ Responsive design utilities with flutter_screenutil
- ✅ SVG support with flutter_svg
- ✅ Loading indicators with flutter_easyloading

## Installation 📦

Add `makdumanarchitect` to your `pubspec.yaml`:

```yaml
dev_dependencies:
  makdumanarchitect: ^2.0.0+1
```

Run:
```bash
flutter pub get
```

## Quick Start 🏃‍♂️

Generate the project structure:
```bash
flutter pub run makdumanarchitect:main
```

This command will:
- Create the complete Clean Architecture folder structure
- **Automatically install all required packages** using `flutter pub add` (no version conflicts!)
- Configure Android and iOS settings
- Set up translation files
- Generate base classes and services

## Project Structure 📁

The package creates a well-organized project structure following Clean Architecture principles:

```
│   ├── scripts
│   │   └── build_sh.dart (<1 KB)
│   └── src
│       ├── core
│       │   ├── base
│       │   │   ├── model
│       │   │   │   └── base_model.dart (<1 KB)
│       │   │   ├── view
│       │   │   │   └── base_view.dart (1 KB)
│       │   │   └── viewModel
│       │   │       └── base_view_model.dart (<1 KB)
│       │   ├── constants
│       │   │   ├── app
│       │   │   │   └── app_constants.dart (<1 KB)
│       │   │   ├── colors
│       │   │   │   └── color_constants.dart (<1 KB)
│       │   │   ├── endPoints
│       │   │   │   └── end_point_constants.dart (<1 KB)
│       │   │   ├── enums
│       │   │   │   ├── app_themes_enums.dart (<1 KB)
│       │   │   │   ├── http_types_enums.dart (<1 KB)
│       │   │   │   └── network_results_enums.dart (<1 KB)
│       │   │   ├── local
│       │   │   │   └── local_constants.dart (<1 KB)
│       │   │   ├── navigation
│       │   │   │   └── navigation_constants.dart (<1 KB)
│       │   │   ├── notification
│       │   │   │   └── notification_constants.dart (<1 KB)
│       │   │   ├── textStyles
│       │   │   │   └── text_style_constants.dart (3 KB)
│       │   │   └── theme
│       │   │       └── theme_constants.dart (<1 KB)
│       │   ├── exports
│       │   │   └── constants_exports.dart (<1 KB)
│       │   ├── extensions
│       │   │   ├── context_extension.dart (2 KB)
│       │   │   └── sized_box_extension.dart (<1 KB)
│       │   ├── mixins
│       │   │   ├── device_orientation.dart (<1 KB)
│       │   │   └── show_bar.dart (1 KB)
│       │   └── services
│       │       ├── analytics
│       │       │   └── analytics_service.dart (2 KB)
│       │       ├── local
│       │       │   └── local_service.dart (1 KB)
│       │       ├── navigation
│       │       │   ├── navigation_route.dart (<1 KB)
│       │       │   └── navigation_service.dart (1 KB)
│       │       ├── network
│       │       │   ├── network_exception.dart (2 KB)
│       │       │   ├── network_service.dart (3 KB)
│       │       │   └── response_parser.dart (<1 KB)
│       │       ├── purchase
│       │       │   └── purchase_manager.dart (5 KB)
│       │       ├── remote_config
│       │       │   └── remote_config_service.dart (1 KB)
│       │       ├── size
│       │       │   └── size_service.dart (<1 KB)
│       │       └── theme
│       │           └── theme_service.dart (<1 KB)
│       └── pages
│           └── home
│               ├── model
│               │   ├── post_model.dart (<1 KB)
│               │   └── post_model.g.dart (<1 KB)
│               ├── view
│               │   └── home_view.dart (1 KB)
│               ├── viewModel
│               │   └── home_view_model.dart (1 KB)
│               └── widget
│                   └── one_item.dart (<1 KB)
├── pubspec.yaml (2 KB)
└── scripts
    └── build.sh (<1 KB)

Total compressed archive size: 71 KB
```

### Core Features Breakdown 🛠

#### Base Classes
- `BaseModel` - Foundation for all models with JSON serialization
- `BaseView` - Template for all views with lifecycle management
- `BaseViewModel` - Base for all ViewModels with state management

#### Services
- **Network Service** - Dio-based HTTP client with interceptors
- **Local Storage** - Hive implementation for persistent storage
- **Navigation Service** - Clean navigation management
- **Analytics Service** - Firebase Analytics integration
- **Remote Config** - Firebase Remote Config setup
- **Purchase Manager** - In-app purchase handling
- **Notification Service** - Push notification management

#### Utils
- Context extensions for responsive design
- SizedBox extensions for cleaner spacing
- Device orientation utilities
- Snackbar and dialog mixins

## Key Improvements in v1.0.3 🎯

### Automatic Dependency Management

The package now uses `flutter pub add` to automatically install dependencies, which means:

- ✅ **No version conflicts** - Flutter automatically resolves compatible versions
- ✅ **Always up-to-date** - Gets the latest compatible versions
- ✅ **Simplified maintenance** - No need to manually update version constraints
- ✅ **Better compatibility** - Works seamlessly with Flutter SDK dependencies

When you run the generator, it will execute:
```bash
flutter pub add provider dio hive_flutter connectivity_plus ...
flutter pub add --dev build_runner flutter_lints json_serializable ...
```

This ensures all packages are installed with versions compatible with your Flutter SDK version.

## Customization ⚙️

### Assets section in pubspec.yaml

When you run the generator, it will make sure your project `pubspec.yaml` contains the following under `flutter.assets` (if they are missing, they are added; if they already exist, they are left untouched):

```yaml
flutter:
  assets:
    - assets/icons/
    - assets/images/
    - assets/translations/
```

This behavior is **idempotent**, so you can safely re-run the generator without duplicating entries.

### Interactive optional dependencies

Some integrations are optional (for example Firebase, notifications, in-app review, purchases, localization).  
For each of these, the generator will ask you in the terminal:

```text
Package: easy_localization (runtime)
Description: Localization and translation support.
Add this package? [y]es / [n]o / [c]ustom package instead:
```

- If you answer **y** or just press Enter, the package is added.
- If you answer **n**, that package is skipped.
- If you answer **c**, you can type your own package (for example another localization package) and that will be added instead.

### Conditional code generation

The generated project structure and code depend on your package choices:

- **easy_localization** not selected → `main.dart` is generated without `EasyLocalization` wrapper and locale-related `MaterialApp` parameters.
- **purchases_flutter** not selected → `main.dart` omits `PurchaseManager` import and `initRevenueCat()`, and the `purchase_manager` service is not created.
- **firebase_analytics** not selected → the `analytics` service folder and `analytics_service.dart` are not created.
- **firebase_remote_config** not selected → the `remote_config` service folder and `remote_config_service.dart` are not created.

### Bundle ID / Application ID

At the start of generation, you are prompted for your app Bundle ID (iOS) / Application ID (Android):

```text
Enter your app Bundle ID / Application ID (e.g. com.company.appname):
Leave empty to keep default (com.example.example):
```

The value is applied to both `android/app/build.gradle.kts` (`applicationId`) and `ios/Runner.xcodeproj/project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`).

### iOS Xcode 16+ fix

The generator sets `BUILD_LIBRARY_FOR_DISTRIBUTION=NO` in the iOS project and Podfile to avoid the Xcode error: *"Using bridging headers with module interfaces is unsupported"*.

## Usage Examples 💡

### Creating a New Page

```dart
class HomeView extends BaseView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return BuilderWidget<HomeViewModel>(
      viewModel: viewModel,
      builder: () => Scaffold(
        // Your widget tree
      ),
    );
  }
}
```

### Using Network Service

```dart
class ApiService {
  Future<ResponseModel> fetchData() async {
    return await NetworkService.instance.get<ResponseModel>(
      EndPointConstants.endpoint,
      model: ResponseModel(),
    );
  }
}
```

### Local Storage

```dart
await LocalService.instance.setValue('key', 'value');
final value = await LocalService.instance.getValue('key');
```

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author ✍️

**Mehmet Akduman** - [GitHub](https://github.com/mehmetakdumn604)

---

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/mehmetakdumn604/akdumanarchitect)!
