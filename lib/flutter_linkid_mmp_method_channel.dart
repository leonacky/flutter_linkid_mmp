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
      final result = _fakeAdData;
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
      final result = _fakeAdData;
      return result;
    } catch (e, s) {
      debugPrint('MethodChannelFlutterLinkidMmp.getAdByType Error: $e');
      debugPrintStack(stackTrace: s);
      return null;
    }
  }
}

Map<String, dynamic> _fakeAdData = {
  "adData": [
    "<div style=\"border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden\"><div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/507b018b-b04e-51a1-b2e3-815901c07024.jpeg\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div><div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Samsung galaxy Fold 6</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Điện thoại Samsung Galaxy Z Fold6 màn hình mỏng hơn, bộ camera mạnh mẽ, đa nhiệm siêu mượt.</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">38.000.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\"></span></div></div></div>",
    "<div style=\"border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden\"><div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/3334c45d-0752-5c4d-89bf-9129f5d56c97.png\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div><div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Điện thoại Samsung Galaxy A05 - 4GB/64GB</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Miễn phí vận chuyển toàn quốc\nBảo hành 12 tháng chính hãng\nBao xài đổi lỗi trong 30 ngày đầu.\nGiá đã bao gồm VAT</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">2.490.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\"></span></div></div></div>",
    "<div style=\"border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden\"><div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/8a9de844-fc2e-546a-93b5-63f6b5ad9edc.jpeg\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div><div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Máy giặt Xiaomi Mijia MJ106 – Giặt 10kg, 25 chế độ giặt</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Máy giặt Xiaomi Mijia MJ106 với thiết kế nhỏ gọn, lồng giặt đường kính lớn có thể giặt tới 10kg quần áo. Với khả năng khử trùng bằng hơi nước, máy giúp loại bỏ các vi khuẩn gây hại cho sức khỏe.</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">20.590.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\">21.619.500 đ</span></div></div></div>",
    "<div style=\"border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden\"><div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/fafc6799-9d19-53a2-838a-540c169a3ad6.png\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div><div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Chuột Gaming Razer DeathAdder V2 RZ01-03210100-R3M1</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Loại sản phẩm: Chuột gaming có dây</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">849.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\"></span></div></div></div>",
    "<div style=\"border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden\"><div style=\"display:flex;align-items:center;justify-content:center;background:#fde68a\"><img src=\"https://d2fpeiluuf92qr.cloudfront.net/694d08cc-dc15-51e1-9c52-47f11f39cc85.jpeg\" alt=\"Image\" style=\"width:100%;height:100%;object-fit:cover\"></div><div style=\"display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px\"><div><div style=\"color:#213547;-webkit-line-clamp:2;overflow:hidden\">Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch</div><div style=\"margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden\">Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch với khả năng chơi game ​​Wireless không có độ trễ trong một kiểu dáng đẹp, 65%, nó hoàn hảo cho mọi không gian và đủ linh hoạt cho mọi thiết lập và sử dụng hàng ngày.</div></div><div style=\"font-weight:600;color:#6b1ca2\"><span style=\"font-size:14px\">4.690.000 đ</span><span style=\"margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through\"></span></div></div></div>"
  ],
  "actionType": "inapp",
  "actionData": "https://www.google.com"
};

/*
<div style="border:1px solid #e5e7eb;border-radius:8px;display:grid;grid-template-columns:1fr 2fr;overflow:hidden">
  <div style="display:flex;align-items:center;justify-content:center;background:#fde68a">
    <img src="https://d2fpeiluuf92qr.cloudfront.net/507b018b-b04e-51a1-b2e3-815901c07024.jpeg" alt="Image"
      style="width:100%;height:100%;object-fit:cover">
  </div>
  <div style="display:flex;flex-direction:column;justify-content:space-between;padding:8px;font-size:14px">
    <div>
      <div style="color:#213547;-webkit-line-clamp:2;overflow:hidden">Samsung galaxy Fold 6</div>
      <div style="margin-top:2px;font-size:10px;color:#aaa;line-height:14px;-webkit-line-clamp:2;overflow:hidden">Điện
        thoại Samsung Galaxy Z Fold6 màn hình mỏng hơn, bộ camera mạnh mẽ, đa nhiệm siêu mượt.</div>
    </div>
    <div style="font-weight:600;color:#6b1ca2">
      <span style="font-size:14px">38.000.000 đ</span>
      <span style="margin-left:4px;font-size:10px;color:#aaa;text-decoration:line-through"></span>
    </div>
  </div>
</div>
*/
