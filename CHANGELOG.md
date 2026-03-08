## [2.0.0+1] - (2026-03-08)

* 🐛 **FIX**: Improved dependency installation flow for dev_dependencies to better handle version conflicts on newer Dart SDKs.
* ✨ **NEW**: Interactive app name prompt at generation start—sets display name for both iOS (CFBundleName, CFBundleDisplayName) and Android (android:label)
* ✨ **NEW**: Interactive bundle ID prompt at generation start—sets Android applicationId and iOS PRODUCT_BUNDLE_IDENTIFIER
* ✨ **NEW**: Interactive prompts for optional integrations (local notifications, Firebase, in-app review, purchases, etc.) before installing dependencies
* ✨ **NEW**: Conditional code generation—skipped packages are not generated in main.dart or service files
* ✨ **NEW**: Automatically injects `flutter.assets` (icons, images, translations) into consumer pubspec.yaml idempotently
* 🔧 **IMPROVEMENT**: iOS platform minimum version set to 15.0 by default in Podfile
* 🐛 **FIX**: Sets BUILD_LIBRARY_FOR_DISTRIBUTION=NO to fix "Using bridging headers with module interfaces is unsupported" Xcode error
* 📦 **IMPROVEMENT**: Android Gradle Kotlin DSL (build.gradle.kts) support for Flutter's new build format

## [1.0.7] - (2026-03-08)

* ✨ **NEW**: Interactive app name prompt at generation start—sets display name for both iOS (CFBundleName, CFBundleDisplayName) and Android (android:label)
* 🔧 **IMPROVEMENT**: iOS platform minimum version set to 15.0 by default in Podfile
* ✨ **NEW**: Automatically injects `flutter.assets` section (icons, images, translations) into the consumer `pubspec.yaml` in an idempotent way
* ✨ **NEW**: Interactive prompts in the terminal for optional integrations (local notifications, Firebase services, in-app review, purchases, etc.) before installing dependencies with `flutter pub add`
* ✨ **NEW**: Generated code is conditional on package selection—skipped packages are not generated (e.g. no EasyLocalization/PurchaseManager in main.dart, no analytics/purchase/remote_config services when not selected)
* ✨ **NEW**: Interactive bundle ID prompt at generation start—sets Android applicationId and iOS PRODUCT_BUNDLE_IDENTIFIER
* 🐛 **FIX**: Sets BUILD_LIBRARY_FOR_DISTRIBUTION=NO in iOS project and Podfile to fix "Using bridging headers with module interfaces is unsupported" Xcode error

## [1.0.6] - (2026-03-08)

* ✨ **NEW**: Android Gradle Kotlin DSL (build.gradle.kts) support for Flutter's new build format
* 🔧 **IMPROVEMENT**: Example app migrated to build.gradle.kts, settings.gradle.kts with new Flutter plugin loader
* 🔧 **IMPROVEMENT**: `createArchitecture` now supports both build.gradle and build.gradle.kts for minSdk configuration
* 📦 **IMPROVEMENT**: Compatible with Flutter 3.24+ Android Gradle structure
## [1.0.3] - (2025-11-29)

* ✨ **NEW**: Automatic package installation using `flutter pub add` command
* 🐛 **FIX**: Resolved dependency version conflicts by using Flutter's automatic version resolution
* 🔧 **IMPROVEMENT**: Packages are now added with compatible versions automatically, eliminating manual version management
* 📦 **IMPROVEMENT**: Better handling of SDK dependencies (flutter_localizations, etc.)

## [1.0.2] - (23.02.2025)

* Applied dart format .

## [1.0.1] - (23.02.2025)

* Fixed type mismatch in analytics service
* Improved network service implementation
* Updated dependencies to be compatible with Flutter SDK
* Enhanced code documentation

## [1.0.0] - (23.02.2025)

Initial release with the following features:

* Clean Architecture folder structure
* Pre-configured state management with Provider
* Network handling with Dio
* Local storage with Hive
* Internet connectivity management
* Firebase integration (Remote Config, Analytics, Crashlytics)
* Push notifications (Firebase Messaging & Awesome Notifications)
* Internationalization support with easy_localization
* In-app review integration
* Responsive design utilities with flutter_screenutil
* SVG support with flutter_svg
* Loading indicators with flutter_easyloading
* Base classes for Models, Views, and ViewModels
* Utility extensions and mixins

## [0.0.1] - (23.02.2025)

* Project folder structure created
