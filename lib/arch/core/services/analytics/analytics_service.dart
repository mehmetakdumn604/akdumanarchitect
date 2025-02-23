var analyticsService = """
import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsHelper {
  static final AnalyticsHelper _instance = AnalyticsHelper._init();

  static AnalyticsHelper get instance => _instance;
  AnalyticsHelper._init();

  void init() {
    iosValidation().then((value) {
      analytics.logAppOpen();
      analytics.setUserId();
    });
    _initCrashlytics(kReleaseMode);
  }

  Future<bool> iosValidation() async {
    TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
    if (status == TrackingStatus.authorized) {
      return true;
    } else {
      return false;
    }
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // final FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  void sendEvent(final String event, {final Map<String, Object?>? extra}) {
    analytics.logEvent(name: event, parameters: extra);
    // facebookAppEvents.logEvent(name: event, parameters: extra);
    log('Event: \$event, extra: \$extra');
  }

  void _initCrashlytics(bool fatalError) {
    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (_nonFatalErrors.contains(errorDetails.toString())) { // prevent non-fatal errors
        return;
      }
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      }
    };
    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (_nonFatalErrors.contains(error.toString())) {
        return false;
      }
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      } else {
        // If you want to record a "non-fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
      return true;
    };
  }

  final List<String> _nonFatalErrors = []; // Add non-fatal errors here
}
""";