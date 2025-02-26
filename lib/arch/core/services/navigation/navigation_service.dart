const navigationService = """
import 'package:flutter/material.dart';

// Router işlemlerinin tek bir sınıftan daha kısa bir şekilde yapılması için
// ele alınan kısım
abstract class INavigationService {
  Future<void> navigateToPage(
      {required String path, Object? data, bool? rootNavigator});

  Future<void> navigateToPageClear({required String path, Object? data});
}

class NavigationService implements INavigationService {
  NavigationService._init();

  static final NavigationService _instance = NavigationService._init();

  static NavigationService get instance => _instance;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  bool Function(Route<dynamic> route) get removeAllOldRoutes =>
      (Route<dynamic> route) => false;

  @override
  Future<void> navigateToPage(
      {required String path, Object? data, bool? rootNavigator}) async {
    await navigatorKey.currentState!.pushNamed(path, arguments: data);
  }

  @override
  Future<void> navigateToPageClear({required String path, Object? data}) async {
    await navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: data);
  }
}

""";
