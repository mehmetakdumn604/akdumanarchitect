# MakdumanArchitect

A powerful Flutter package that implements Clean Architecture principles, providing a robust and scalable project structure with essential features out of the box.

[![Pub Version](https://img.shields.io/pub/v/makdumanarchitect.svg)](https://pub.dev/packages/makdumanarchitect)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features 🚀

- ✅ Clean Architecture folder structure
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
  makdumanarchitect: ^1.0.0
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

## Project Structure 📁

The package creates a well-organized project structure following Clean Architecture principles:

```
lib/
├── common/
│   ├── models/
│   ├── viewModels/
│   └── widgets/
├── core/
│   ├── base/
│   ├── constants/
│   ├── exports/
│   ├── extensions/
│   ├── mixins/
│   └── services/
└── pages/
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
