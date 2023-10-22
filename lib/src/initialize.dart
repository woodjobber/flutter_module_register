import 'package:flutter_boost/flutter_boost.dart';
import 'package:mmkv/mmkv.dart';

import 'lifecycle_test_page.dart';

Future<int> initialize() async {
  ///添加全局生命周期监听类
  PageVisibilityBinding.instance.addGlobalObserver(AppLifecycleObserver());
  await MMKV.initialize();
  return Future.value(0);
}
