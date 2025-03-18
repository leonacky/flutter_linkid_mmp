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
  Future<Map<String, dynamic>?> getAdById(String adId) async {
    try {
      final result = _fakeAdDataProduct;
      return result;
    } catch (e, s) {
      debugPrint('MethodChannelFlutterLinkidMmp.getAdById Error: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAdByType(String adType) async {
    try {
      final result = adType == 'banner' ? _fakeAdDataBanner : _fakeAdDataProduct;
      return result;
    } catch (e, s) {
      debugPrint('MethodChannelFlutterLinkidMmp.getAdByType Error: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }
}

Map<String, dynamic> _fakeAdDataBanner = {
  "adData": [
    '''
<div
  data-ad-element-id="db4bf3c4-8f03-47ea-a077-b53908bb02ca"
  style="
    border-radius: 8px;
    border: 1px solid #f3f4f6;
    background-color: #fff;
    box-sizing: border-box;
    width: 100%;
    height: 100%;
  "
>
  <img
    src="https://d2fpeiluuf92qr.cloudfront.net/507b018b-b04e-51a1-b2e3-815901c07024.jpeg"
    alt=""
    style="height: 100%; width: 100%; border-radius: 8px; object-fit: cover"
  />
</div>
''',
  ],
  "size": {
    "width": 480,
    "height": 120,
  },
  "actionType": "inapp",
  "actionData": "https://www.google.com"
};

Map<String, dynamic> _fakeAdDataProduct = {
  "adData": [
    '''
<div
  style="
    background-color: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    display: flex;
    overflow: hidden;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
  "
>
  <div
    style="
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      overflow: hidden;
      width: 34%;
    "
  >
    <img
      src="https://d2fpeiluuf92qr.cloudfront.net/694d08cc-dc15-51e1-9c52-47f11f39cc85.jpeg"
      alt="Image"
      style="width: 100%; height: 100%; object-fit: cover;"
    />
  </div>
  <div
    style="
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 10px;
      font-size: 14px;
      width: calc(66% - 16px);
    "
  >
    <div>
      <div style="color: #213547; max-lines: 2; text-overflow: ellipsis">
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch
      </div>
      <div
        style="
          margin-top: 2px;
          font-size: 10px;
          color: #aaa;
          line-height: 14px;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch với khả
        năng chơi game ​​Wireless không có độ trễ trong một kiểu dáng đẹp, 65%,
        nó hoàn hảo cho mọi không gian và đủ linh hoạt cho mọi thiết lập và sử
        dụng hàng ngày.
      </div>
    </div>
    <div style="font-weight: 600; color: #6b1ca2">
      <span style="font-size: 14px">4.690.000 đ</span
      ><span
        style="
          margin-left: 4px;
          font-size: 10px;
          color: #aaa;
          text-decoration: line-through;
        "
      ></span>
    </div>
  </div>
</div>
''',
    '''
<div
  style="
    background-color: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    display: flex;
    overflow: hidden;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
  "
>
  <div
    style="
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      overflow: hidden;
      width: 34%;
    "
  >
    <img
      src="https://d2fpeiluuf92qr.cloudfront.net/694d08cc-dc15-51e1-9c52-47f11f39cc85.jpeg"
      alt="Image"
      style="width: 100%; height: 100%; object-fit: cover;"
    />
  </div>
  <div
    style="
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 10px;
      font-size: 14px;
      width: calc(66% - 16px);
    "
  >
    <div>
      <div style="color: #213547; max-lines: 2; text-overflow: ellipsis">
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch
      </div>
      <div
        style="
          margin-top: 2px;
          font-size: 10px;
          color: #aaa;
          line-height: 14px;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch với khả
        năng chơi game ​​Wireless không có độ trễ trong một kiểu dáng đẹp, 65%.
      </div>
    </div>
    <div style="font-weight: 600; color: #6b1ca2">
      <span style="font-size: 14px">4.690.000 đ</span
      ><span
        style="
          margin-left: 4px;
          font-size: 10px;
          color: #aaa;
          text-decoration: line-through;
        "
      ></span>
    </div>
  </div>
</div>
''',
  ],
  "size": {
    "width": 480,
    "height": 180,
  },
  "actionType": "inapp",
  "actionData": "https://www.google.com"
};
