import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkid_mmp/user_info.dart';

import 'deep_link_handler.dart';
import 'flutter_linkid_mmp_platform_interface.dart';

/// An implementation of [FlutterLinkIdMmpPlatform] that uses method channels.
class MethodChannelFlutterLinkidMmp extends FlutterLinkIdMmpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_linkid_mmp');
  DeepLinkHandler? _deepLinkHandler;

  MethodChannelFlutterLinkidMmp() : super() {
    methodChannel.setMethodCallHandler((call) async {
      // you can get hear method and passed arguments with method
      print("method ${call.method}");
      if (call.method == "onDeepLink") {
        _deepLinkHandler?.onReceivedDeepLink(call.arguments);
      }
    });
  }

  Map<String, String> _convertDynamicMapToString(
      Map<String, dynamic>? originalMap) {
    if (originalMap == null) {
      return {};
    }
    return originalMap!.map((key, value) {
      try {
        return MapEntry(key, value.toString());
      } catch (e) {
        return MapEntry(key, '$value');
      }
    });
  }

  @override
  void setDeepLinkHandler(DeepLinkHandler deepLinkHandler) {
    _deepLinkHandler = deepLinkHandler;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initSDK(String partnerCode, String appSecret) async {
    // TODO: implement initSDK
    try {
      final result = await methodChannel.invokeMethod<bool>(
          'initSDK', {'partnerCode': partnerCode, 'appSecret': appSecret});
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> logEvent(String eventName, {Map<String, dynamic>? data}) async {
    // TODO: implement event
    try {
      final result = await methodChannel.invokeMethod<bool>('event',
          {'eventName': eventName, 'data': _convertDynamicMapToString(data)});
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    // TODO: implement event
    try {
      Map<String, dynamic> data = userInfo.toMap();
      final result =
          await methodChannel.invokeMethod<bool>('setUserInfo', {'data': data});
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> setCurrentScreen(String screenName) async {
    // TODO: implement event
    try {
      final result = await methodChannel
          .invokeMethod<bool>('setCurrentScreen', {'screenName': screenName});
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setRevenue(String orderId, double amount, String currency,
      {Map<String, dynamic>? data}) async {
    // TODO: implement event
    try {
      final result = await methodChannel.invokeMethod<bool>('setRevenue', {
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
        'data': _convertDynamicMapToString(data)
      });
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> recordError(String name, String stackTrace) async {
    // TODO: implement initSDK
    try {
      final result = await methodChannel.invokeMethod<bool>(
          'recordError', {'name': name, 'stackTrace': stackTrace});
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setDevMode(bool devMode) async {
    // TODO: implement initSDK
    try {
      final result = await methodChannel
          .invokeMethod<bool>('setDevMode', {'devMode': devMode});
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setProductList(String listName,
      {required List<Map<String, dynamic>> products}) async {
    // TODO: implement event
    try {
      final result = await methodChannel.invokeMethod<bool>('setProductList', {
        'listName': listName,
        'products': products,
      });
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<Map<String, dynamic>?> createLink(Map<String, dynamic> params) async {
    try {
      final result = await methodChannel.invokeMethod<Map>('createLink', {
        'params': params,
      });
      Map<String, dynamic> data = {};
      if (result != null) {
        result.forEach((key, value) {
          if (key is String) {
            data[key] = value;
          }
        });
      }
      return data;
    } catch (e) {
      // print(e);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> createShortLink(
      {required String longLink,
      String name = "",
      String shortLinkId = ""}) async {
    try {
      final result = await methodChannel.invokeMethod<Map>('createShortLink', {
        'longLink': longLink,
        'name': name,
        'shortLinkId': shortLinkId,
      });
      Map<String, dynamic> data = {};
      if (result != null) {
        result.forEach((key, value) {
          if (key is String) {
            data[key] = value;
          }
        });
      }
      return data;
    } catch (e) {
      // //print(e);
    }
    return null;
  }

  @override
  Future<bool> removeUserToken() async {
    try {
      var result = await methodChannel.invokeMethod<bool>('removeUserToken');
      return result ?? false;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
