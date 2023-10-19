import 'package:flutter_boost/flutter_boost.dart';

//ignore_for_file: non_constant_identifier_names ,unused_element

extension Chief on BoostNavigator {
  static BoostNavigator get _Navigator => BoostNavigator.instance;

  static BoostNavigator get I => BoostNavigator.instance;

  static Future<bool> pop<T extends Object?>([T? result]) async {
    return _Navigator.pop(result);
  }

  static Future<T> push<T extends Object?>(String name,
      {Map<String, dynamic>? arguments,
      bool withContainer = false,
      bool opaque = true}) {
    return _Navigator.push(
      name,
      arguments: arguments,
      withContainer: withContainer,
      opaque: opaque,
    );
  }

  static Future<T> pushReplacement<T extends Object?>(String name,
      {Map<String, dynamic>? arguments, bool withContainer = false}) async {
    return _Navigator.pushReplacement(
      name,
      arguments: arguments,
      withContainer: withContainer,
    );
  }

  static Future<void> popUntil({String? route, String? uniqueId}) async {
    return _Navigator.popUntil(
      route: route,
      uniqueId: uniqueId,
    );
  }

  static Future<bool> remove(String? uniqueId,
      {Map<String, dynamic>? arguments}) async {
    return _Navigator.remove(
      uniqueId,
      arguments: arguments,
    );
  }
}
