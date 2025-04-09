import 'dart:convert';

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

  Map<String, String> _convertDynamicMapToString(Map<String, dynamic>? originalMap) {
    if (originalMap == null) {
      return {};
    }
    return originalMap.map((key, value) {
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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initSDK(String partnerCode, String appSecret) async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>('initSDK', {'partnerCode': partnerCode, 'appSecret': appSecret});
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> logEvent(String eventName, {Map<String, dynamic>? data}) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'event',
        {'eventName': eventName, 'data': _convertDynamicMapToString(data)},
      );
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> setUserInfo(UserInfo userInfo) async {
    try {
      Map<String, dynamic> data = userInfo.toMap();
      final result = await methodChannel.invokeMethod<bool>(
        'setUserInfo',
        {'data': data},
      );
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> setCurrentScreen(String screenName) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'setCurrentScreen',
        {'screenName': screenName},
      );
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setRevenue(
    String orderId,
    double amount,
    String currency, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'setRevenue',
        {
          'orderId': orderId,
          'amount': amount,
          'currency': currency,
          'data': _convertDynamicMapToString(data),
        },
      );
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  @override
  Future<bool> recordError(String name, String stackTrace) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'recordError',
        {'name': name, 'stackTrace': stackTrace},
      );
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setDevMode(bool devMode) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'setDevMode',
        {'devMode': devMode},
      );
      return result ?? false;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  @override
  Future<bool> setProductList(
    String listName, {
    required List<Map<String, dynamic>> products,
  }) async {
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
      {required String longLink, String name = "", String shortLinkId = ""}) async {
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

  @override
  Future<Map<String, dynamic>?> getAd({required String adId, required String adType}) async {
    try {
      final result = await methodChannel.invokeMethod<Map>('getAd', {
        'adId': adId,
        'adType': adType,
      });
      Map<String, dynamic> data = {};
      if (result != null) {
        result.forEach((key, value) {
          if (key is String) {
            if (key == "adItem") {
              String adItem = value as String;
              //covert adItem to Map; adItem is a json string
              data[key] = jsonDecode(adItem);
            } else {
              data[key] = value;
            }
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
  Future<bool> trackAdClick({required String adId, String productId = ""}) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('trackAdClick', {
        'adId': adId,
        'productId': productId,
      });
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }

  /// List of ad product ids that have been impressed.
  ///
  /// This is used to prevent duplicate impressions
  /// for the same adId and productId.
  ///
  /// The format is "${adId}_${productId}".
  final List<String> _impressedAdProductIds = [];
  @override
  Future<bool> trackAdImpression({required String adId, String productId = ""}) async {
    if (_impressedAdProductIds.contains('${adId}_$productId')) {
      return true;
    }
    try {
      final result = await methodChannel.invokeMethod<bool>('trackAdImpression', {
        'adId': adId,
        'productId': productId,
      });
      if (result == true) {
        _impressedAdProductIds.add('${adId}_$productId');
      }
      return result ?? false;
    } catch (e) {
      // //print(e);
    }
    return false;
  }
}
