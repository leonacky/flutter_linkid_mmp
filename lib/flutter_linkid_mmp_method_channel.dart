import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkid_mmp/user_info.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

/// An implementation of [FlutterLinkIdMmpPlatform] that uses method channels.
class MethodChannelFlutterLinkidMmp extends FlutterLinkIdMmpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_linkid_mmp');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initSDK(String partnerCode) async {
    // TODO: implement initSDK
    try {
      final result = await methodChannel.invokeMethod<bool>('initSDK', {
        'partnerCode': partnerCode,
      });
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
      final result = await methodChannel.invokeMethod<bool>(
          'event', {'eventName': eventName, 'data': data ?? {}});
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
}
