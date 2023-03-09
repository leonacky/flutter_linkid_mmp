import 'package:flutter_linkid_mmp/user_info.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

class FlutterLinkIdMMP {
  static final FlutterLinkIdMMP _instance = FlutterLinkIdMMP._internal();
  factory FlutterLinkIdMMP() {
    return _instance;
  }
  FlutterLinkIdMMP._internal();

  Future<String?> getPlatformVersion() {
    return FlutterLinkIdMmpPlatform.instance.getPlatformVersion();
  }

  Future<bool> initSDK(String partnerCode) {
    return FlutterLinkIdMmpPlatform.instance.initSDK(partnerCode);
  }

  Future<bool> logEvent(String name, {Map<String, dynamic>? data}) {
    return FlutterLinkIdMmpPlatform.instance.logEvent(name, data: data);
  }

  Future<bool> setUserInfo(UserInfo userInfo) {
    return FlutterLinkIdMmpPlatform.instance.setUserInfo(userInfo);
  }

  Future<bool> setCurrentScreen({required String screenName}) {
    return FlutterLinkIdMmpPlatform.instance.setCurrentScreen(screenName);
  }
}
