import 'dart:developer';
import 'dart:ui';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makdumanarchitect/src/core/services/local/local_service.dart';
import 'package:makdumanarchitect/src/core/services/navigation/navigation_service.dart';
import 'package:makdumanarchitect/src/core/services/remote_config/remote_config_service.dart';

import '../../constants/navigation/navigation_constants.dart';
import '../language/languages/l10n.dart';
import 'model/paywall_model.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  static PurchaseService get instance => _instance;
  PurchaseService._internal() {
    // init
  }
  final Adapty adapty = Adapty();
  final int defaultDiscountPercentage = 87;

  bool? isPremium;
  final List<String> _lifetimeProductIds = [];

  Future<void> init() async {
    try {
      adapty.activate();
      await adapty.setLogLevel(AdaptyLogLevel.verbose);
      if (LocalCaching.instance.isFirstOpen) {
        await preLoadPaywall(PaywallKeys.firstOpen);
      }

      preLoadPaywalls();

      final AdaptyProfile adaptyProfile = await adapty.getProfile();

      isPremium = checkPremiumUser(adaptyProfile.accessLevels);
      adapty.didUpdateProfileStream.listen((event) {
        isPremium = checkPremiumUser(event.accessLevels);
      });
    } on AdaptyError catch (e) {
      log('Adapty error: ${e.message}');
    } catch (e) {
      log('Unhandled error: $e');
    }
  }

  bool checkPremiumUser(Map<String, AdaptyAccessLevel>? accessLevels) {
    if (accessLevels == null) {
      return false;
    }
    bool isPremium = accessLevels["premium"]?.isActive ?? false;
    log("User is premium: $isPremium");
    log("Access levels: $accessLevels");
    return isPremium;
  }

  Map<PaywallKeys, PaywallModel> paywalls = {};

  AdaptyPaywall? adaptyPaywall;

  PaywallModel? getPaywallWithKey(PaywallKeys key) {
    if (paywalls.containsKey(key)) {
      return paywalls[key]!;
    }
    return null;
  }

  Map<PaywallKeys, int> paywallDiscounts = {};

  int discountPercentage(PaywallKeys key) =>
      paywallDiscounts[key] ?? defaultDiscountPercentage;

  void preLoadPaywalls() {
    for (var element in PaywallKeys.values) {
      if (element == PaywallKeys.firstOpen) {
        // no need to preload first open paywall because it is already preloaded in init for first open
        continue;
      }
      preLoadPaywall(element);
    }
  }

  Future<PaywallModel?> preLoadPaywall(PaywallKeys key) async {
    if (paywalls.containsKey(key)) {
      return paywalls[key];
    }
    try {
      final Locale locale = window.locale;
      adaptyPaywall = await adapty.getPaywall(
          placementId: key.value, locale: locale.languageCode);

      await adapty.logShowPaywall(paywall: adaptyPaywall!);
      if (adaptyPaywall?.remoteConfig != null) {
        PaywallModel paywallModel = PaywallModel.fromJson(
            RemoteConfigService.instance.paywallUITemplate);
        Map<String, String> productPrices =
            await getProductPrices(paywallModel, adaptyPaywall!);
        paywallDiscounts[key] = _calculateSavings(productPrices);

        paywallModel.setProductPrices(productPrices);
        paywalls[key] = paywallModel;
        return paywallModel;
      }
    } on AdaptyError catch (e) {
      log('Adapty error: ${e.message}');
    } catch (e) {
      log('Unhandled error: $e');
    }
    return null;
  }

  int _calculateSavings(Map<String, String> prices) {
    try {
      final double monthlyPrice = _parsePrice(prices.entries
          .firstWhere((element) =>
              element.key.toLowerCase().contains(PackageTypes.monthly.name))
          .value);
      final double yearlyPrice = _parsePrice(prices.entries
          .firstWhere((element) =>
              element.key.toLowerCase().contains(PackageTypes.yearly.name))
          .value);

      // Calculate weekly equivalent from yearly price
      final double monthlyEquivalent = yearlyPrice / 12;

      // Calculate savings percentage
      final double savings =
          ((monthlyPrice - monthlyEquivalent) / monthlyPrice) * 100;

      return savings.toInt();
    } catch (e) {
      return 0;
    }
  }

  double _parsePrice(String price) {
    // Remove all non-numeric characters except for ',' and '.'
    String cleanedPrice = price.replaceAll(RegExp(r'[^\d.,]'), '');

    // If there's more than one '.', assume the last one is the decimal separator
    if (cleanedPrice.contains(',')) {
      cleanedPrice = cleanedPrice.replaceAll('.', '').replaceAll(',', '.');
    } else if (cleanedPrice.split('.').length > 2) {
      int lastDotIndex = cleanedPrice.lastIndexOf('.');
      cleanedPrice =
          cleanedPrice.substring(0, lastDotIndex).replaceAll('.', '') +
              cleanedPrice.substring(lastDotIndex);
    }

    return double.tryParse(cleanedPrice) ??
        discountPercentage(PaywallKeys.firstOpen).toDouble();
  }

  getProductPrices(PaywallModel paywall, AdaptyPaywall adaptyPaywall) async {
    try {
      List<String> paywallProducts = [];
      if (paywall.products.isEmpty && paywall.configurations == null) {
        return;
      } else {
        for (var element in paywall.products) {
          if (element == null || element.isEmpty) continue;

          paywallProducts.add(element);
        }
      }
      List<AdaptyPaywallProduct> products = [];
      try {
        products = await Adapty().getPaywallProducts(paywall: adaptyPaywall);
      } catch (e) {
        log(e.toString());
      }

      Map<String, String> productPrices = {};

      for (AdaptyPaywallProduct element in products) {
        productPrices[element.vendorProductId ??
            paywall.products.first ??
            "test"] = element.price.localizedString ?? "";
      }
      return productPrices;
    } catch (e) {
      log(e.toString(), name: 'PurchaseService.getProductPrices');
    }
  }

  void restorePurchases() async {
    try {
      EasyLoading.show();
      AdaptyProfile adaptyProfile = await adapty.restorePurchases();

      if (adaptyProfile.subscriptions.isNotEmpty) {
        EasyLoading.showSuccess(S.current.restoreSuccess);
        if (LocalCaching.instance.isFirstOpen) {
          // user is on onboarding screen so navigate to scan screen
          isPremium = checkPremiumUser(adaptyProfile.accessLevels);

          NavigationService.instance
              .navigateToPageClear(path: NavigationConstants.home);
        } else {
          isPremium = checkPremiumUser(adaptyProfile.accessLevels);

          // user is on home screens so navigate to back
          NavigationService.instance.navigatorKey.currentState?.pop();
        }
      }
    } catch (e) {
      isPremium = false;

      log(e.toString(), name: 'PurchaseService.restorePurchases');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void purchaseProduct(String productId, {Function(bool)? callback}) async {
    try {
      EasyLoading.show();
      AdaptyProfile? adaptyProfile = await adapty.getProfile();
      if (!checkPremiumUser(adaptyProfile.accessLevels)) {
        List<AdaptyPaywallProduct> products =
            await adapty.getPaywallProducts(paywall: adaptyPaywall!);

        AdaptyPaywallProduct product = products
            .firstWhere((element) => element.vendorProductId == productId);

        adaptyProfile = await adapty.makePurchase(product: product);
      }

      if (checkPremiumUser(adaptyProfile?.accessLevels)) {
        EasyLoading.showSuccess(
          S.current.purchaseSuccess,
          duration: const Duration(seconds: 2),
        );
        isPremium = checkPremiumUser(adaptyProfile?.accessLevels);

        await Future.delayed(const Duration(
            seconds: 2)); // wait for 2 seconds to dispose success message
        if (callback != null) {
          callback(isPremium!);
        } else if (LocalCaching.instance.isFirstOpen) {
          // user is on onboarding screen so navigate to scan screen
          NavigationService.instance
              .navigateToPageClear(path: NavigationConstants.home);
          // AnalyticsHelper.instance.sendEvent(EventConstants.firstPaywallSuccess);
        } else {
          // user is on home screens so navigate to back
          NavigationService.instance.navigatorKey.currentState?.pop();
          // AnalyticsHelper.instance.sendEvent(EventConstants.paywallSuccess, extra: {'paywallKey': adaptyPaywall?.placementId ?? ""});
        }
      } else {
        EasyLoading.showError(S.current.purchaseFailed);
        // FirebaseCrashlytics.instance.recordError("Purchase Failed ${adaptyProfile?.accessLevels}", StackTrace.current); // send error to crashlytics
        isPremium = checkPremiumUser(adaptyProfile?.accessLevels);
        callback?.call(isPremium!);
      }
    } catch (e) {
      log(e.toString(), name: 'PurchaseService.purchaseProduct');

      isPremium = false;
      callback?.call(isPremium!);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void showPaywall(PaywallKeys key,
      {Function(bool)? callback, bool clearPreviousPage = false}) {
    final data = {
      'paywallKey': key,
      'callback': callback,
    };

    if (clearPreviousPage) {
      NavigationService.instance
          .navigateToPageClear(path: NavigationConstants.paywall, data: data);
      return;
    }

    NavigationService.instance
        .navigateToPage(path: NavigationConstants.paywall, data: data);
  }

  void purchaseLifetimeProduct() async {
    List<AdaptyPaywallProduct> products =
        await adapty.getPaywallProducts(paywall: adaptyPaywall!);

    AdaptyPaywallProduct lifetimeProduct = products.firstWhere(
        (element) => _lifetimeProductIds.contains(element.vendorProductId));

    purchaseProduct(lifetimeProduct.vendorProductId);
  }
}

enum PaywallKeys {
  firstOpen("first_open");

  final String value;

  const PaywallKeys(this.value);
}

enum PackageTypes {
  monthly,
  yearly,
}
