var remoteConfigServiceString = """import 'dart:convert';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../purchase/model/paywall_model.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._init();

  static RemoteConfigService get instance => _instance;
  RemoteConfigService._init();

  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;

  Map<String, dynamic> get paywallUITemplate {
    try {
      final paywallUIJson = _remoteConfig.getString(RemoteConfigKeys.paywallUITemplate.value);

      if (paywallUIJson.isEmpty) {
        return examplePaywall;
      }

      Map<String, dynamic> paywallUIMap = jsonDecode(paywallUIJson);

      return paywallUIMap;
    } catch (e) {
      log(e.toString(), name: 'RemoteConfigService.paywallUITemplate');
      return examplePaywall;
    }
  }

  Future<void> initRemote() async {
    await _remoteConfig.ensureInitialized();
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );

    await _setDefaults();
  }

  Future<void> _setDefaults() async {
    try {
      await _remoteConfig.setDefaults(
        {
          RemoteConfigKeys.paywallUITemplate.value: jsonEncode(examplePaywall),
        },
      );

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log(e.toString(), name: 'RemoteConfigService._setDefaults');
    }
  }
}

enum RemoteConfigKeys {
  paywallUITemplate('paywall_ui'),
  ;

  final String value;

  const RemoteConfigKeys(this.value);
}
""";
