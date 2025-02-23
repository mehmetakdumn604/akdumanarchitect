
import 'package:hive_flutter/hive_flutter.dart';
// Uygulamanın local veri tabanını kullandığımız kısım
class LocalCaching {
  static final LocalCaching _instance = LocalCaching._init();

  static LocalCaching get instance => _instance;
  LocalCaching._init();
  final String generalBoxName = "generalBox";

  Box? generalBox;

  static Future<void> init() async {
    // Hive.registerAdapter(ExampleAdapter());
    await Hive.initFlutter();
    instance.generalBox = await Hive.openBox(instance.generalBoxName);
  }

  int get appCount {
    int appCount = instance.getValueFromGeneral(CachingKeys.appCount.name, defaultValue: 0) ?? 0;
    return appCount;
  }

  void incrementAppCount() async {
    await instance.setValueToGeneral(CachingKeys.appCount.name, appCount + 1);
  }

  bool get isFirstOpen => appCount == 0;

  dynamic getValueFromGeneral(String key, {dynamic defaultValue}) {
    return instance.generalBox?.get(key) ?? defaultValue;
  }


  Future<void> setValueToGeneral(String key, dynamic value) async {
    await instance.generalBox!.put(key, value);
  }

  
  void write(String key, dynamic value) {
    instance.generalBox!.put(key, value);
  }

  
  dynamic read(String key) {
    return instance.generalBox!.get(key);
  }
}

enum CachingKeys {
  appCount,
}
