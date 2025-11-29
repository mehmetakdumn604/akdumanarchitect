import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/src/core/constants/navigation/navigation_constants.dart';
import '/src/core/services/local/local_service.dart';
import '/src/core/services/navigation/navigation_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseManager {
  static final PurchaseManager _instance = PurchaseManager._init();

  static PurchaseManager get instance => _instance;
  final String _androidApiKey = 'ANDROID_API_KEY';
  final String _iosApiKey = "IOS_API_KEY";
  final String _paywallEntitlementId = "premium";
  bool isInitted = false;

  Offerings? _offerings;

  Offerings? get offerings => _offerings;

  bool paywallRequested = false;

  PurchaseManager._init();

  String get adaptiveApiKey => Platform.isAndroid ? _androidApiKey : _iosApiKey;
  void presentPaywall(String key, {VoidCallback? onClose}) async {
    if (instance.paywallRequested) {
      return;
    }
    if (LocalCaching.instance.isPremium) {
      onClose?.call();
      instance.paywallRequested = false;
      return;
    }
    instance.paywallRequested = true;
    _offerings ??= await getOfferings();
    if (_offerings == null) {
      instance.paywallRequested = false;
      onClose?.call();
      return;
    }
    if (_offerings?.current?.availablePackages.isEmpty ?? true) {
      onClose?.call();
      instance.paywallRequested = false;
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    NavigationService.instance.navigateToPage(
      path: NavigationConstants.paywall,
      data: {
        "paywallKey": key,
        "onClose": onClose,
      },
    );

    instance.paywallRequested = false;

    return;
  }

  Future<Offerings?> getOfferings() async {
    try {
      instance._offerings ??= await Purchases.getOfferings();
      return instance._offerings;
    } catch (e) {
      log('Hata getOfferings(): $e');
      return null;
    }
  }

  static Future<void> initRevenueCat() async {
    try {
      if (instance.isInitted) {
        return;
      }
      instance.isInitted = true;

      const String appUserId = "user_id";
      // ignore: deprecated_member_use
      await Purchases.setup(instance.adaptiveApiKey, appUserId: appUserId);
      Purchases.setLogLevel(LogLevel.debug);

      LogInResult logInResult = await Purchases.logIn(appUserId);
      log("Login result: ${logInResult.created}");

      instance.isPremium();
      await instance.getOfferings();

      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        if (customerInfo
                .entitlements.all[instance._paywallEntitlementId]?.isActive ??
            false) {
          LocalCaching.instance.setIsPremium(true);
        } else {
          LocalCaching.instance.setIsPremium(false);
        }
      });
    } catch (e) {
      log('Hata initRevenueCat(): $e');
    }
  }

  Future<bool> isPremium() async {
    try {
      await initRevenueCat();

      final CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

      // Kullanıcının bir aktif aboneliği var mı kontrol ediyoruz.
      bool isPremium = purchaserInfo
              .entitlements.all[instance._paywallEntitlementId]?.isActive ??
          false;
      if (LocalCaching.instance.isPremium != isPremium) {
        LocalCaching.instance.setIsPremium(isPremium);
      }
      return isPremium;
    } catch (e) {
      log('Hata: $e');
      return false;
    }
  }

  Future<bool> purchaseSubscription(Package purchasePackage) async {
    try {
      EasyLoading.show();

      final PurchaseResult purchaseResult =
          await Purchases.purchase(PurchaseParams.package(purchasePackage));

      EasyLoading.dismiss();
      final CustomerInfo purchase = purchaseResult.customerInfo;
      if (purchase.allPurchasedProductIdentifiers
          .contains(purchasePackage.storeProduct.identifier)) {
        LocalCaching.instance.setIsPremium(true);
        return true;
      }
      LocalCaching.instance.setIsPremium(false);
      return false;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log('Hata purchaseSubscription(): $e');
      LocalCaching.instance.setIsPremium(false);
      EasyLoading.dismiss();

      return false;
    }
  }

  Future<bool> restoreSubscription() async {
    try {
      EasyLoading.show();
      final CustomerInfo restoredPurchases = await Purchases.restorePurchases();
      bool hasActiveSubscription = false;
      restoredPurchases.entitlements.all.forEach((key, value) {
        if (value.isActive) {
          hasActiveSubscription = true;
        }
      });

      LocalCaching.instance.setIsPremium(hasActiveSubscription);
      EasyLoading.dismiss();
      return hasActiveSubscription;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log('Hata restoreSubscription(): $e');
      LocalCaching.instance.setIsPremium(false);
      EasyLoading.dismiss();

      return false;
    }
  }

  Future<void> updateUserAttributes(
      {String? username,
      String? email,
      Map<String, String>? attributes}) async {
    if (username != null) {
      await Purchases.setDisplayName(username);
    }
    if (email != null) {
      await Purchases.setEmail(email);
    }
    if (attributes != null) {
      await Purchases.setAttributes(attributes);
    }
  }
}
