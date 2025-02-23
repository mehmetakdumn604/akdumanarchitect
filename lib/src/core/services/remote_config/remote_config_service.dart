import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._init();

  static RemoteConfigService get instance => _instance;
  RemoteConfigService._init();

  FirebaseRemoteConfig get _remoteConfig => FirebaseRemoteConfig.instance;

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
          RemoteConfigKeys.exampleRemoteKey.value: "example_value",
        },
      );

      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log(e.toString(), name: 'RemoteConfigService._setDefaults');
    }
  }
}

enum RemoteConfigKeys {
  exampleRemoteKey('example_remote_key');

  final String value;

  const RemoteConfigKeys(this.value);
}
