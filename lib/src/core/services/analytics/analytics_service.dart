import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// A service class that handles Firebase Analytics integration for tracking user events and app usage.
/// 
/// This service provides methods to log custom events, screen views, and user properties
/// using Firebase Analytics. It follows a singleton pattern to ensure a single instance
/// throughout the app lifecycle.
class AnalyticsHelper {
  /// Private constructor for singleton pattern
  AnalyticsHelper._init();

  /// The singleton instance of [AnalyticsHelper]
  static final AnalyticsHelper _instance = AnalyticsHelper._init();

  /// Returns the singleton instance of [AnalyticsHelper]
  static AnalyticsHelper get instance => _instance;

  /// Firebase Analytics instance used for tracking
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// Initializes the analytics service.
  /// 
  /// This method should be called once during app initialization.
  void init() {
    iosValidation().then((value) {
      analytics.logAppOpen();
      analytics.setUserId();
    });
    _initCrashlytics(kReleaseMode);
  }

  /// Requests tracking authorization on iOS devices.
  /// 
  /// This method is used to request permission from the user to track their activity.
  Future<bool> iosValidation() async {
    TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
    if (status == TrackingStatus.authorized) {
      return true;
    } else {
      return false;
    }
  }

  /// Logs a custom event with the specified name and parameters.
  /// 
  /// [event] is the name of the event to log
  /// [extra] is an optional map of event parameters
  void sendEvent(final String event, {final Map<String, Object?>? extra}) {
    analytics.logEvent(name: event, parameters: extra);
    log('Event: $event, extra: $extra');
  }

  /// Initializes Firebase Crashlytics for error reporting.
  /// 
  /// [fatalError] indicates whether to record fatal or non-fatal errors
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

  /// A list of non-fatal errors to be ignored by Crashlytics
  final List<String> _nonFatalErrors = []; // Add non-fatal errors here
}
