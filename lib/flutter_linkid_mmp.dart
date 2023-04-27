import 'package:flutter_linkid_mmp/deep_link_handler.dart';
import 'package:flutter_linkid_mmp/user_info.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

class FlutterLinkIdMMP implements DeepLinkHandler{
  static final FlutterLinkIdMMP _instance = FlutterLinkIdMMP._internal();

  factory FlutterLinkIdMMP() {
    return _instance;
  }
  FlutterLinkIdMMP._internal() {
    FlutterLinkIdMmpPlatform.instance.setDeepLinkHandler(this);
  }

  Function(String url)? _onReceivedDeferredDeepLink;
  Function(String url)? _onReceivedDeepLink;
  String currentDeeplink = "";
  String currentDeferredDeeplink = "";

  void deepLinkHandler({Function(String url)? onReceivedDeepLink, Function(String url)? onReceivedDeferredDeepLink}) {
    _onReceivedDeferredDeepLink = onReceivedDeferredDeepLink;
    _onReceivedDeepLink = onReceivedDeepLink;
    if(currentDeeplink!="") {
      _onReceivedDeepLink?.call(currentDeeplink);
    }
    if(currentDeferredDeeplink!="") {
      _onReceivedDeferredDeepLink?.call(currentDeferredDeeplink);
    }
  }

  Future<String?> getPlatformVersion() {
    return FlutterLinkIdMmpPlatform.instance.getPlatformVersion();
  }

  Future<bool> initSDK({required String partnerCode, required String appSecret}) {
    return FlutterLinkIdMmpPlatform.instance.initSDK(partnerCode, appSecret);
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

  @override
  void onReceivedDeepLink(String url) {
    // TODO: implement onReceivedDeepLink
    currentDeeplink = url;
    _onReceivedDeepLink?.call(url);
  }

  @override
  void onReceivedDeferredDeepLink(String url) {
    // TODO: implement onReceivedDeferredDeepLink
    currentDeferredDeeplink = url;
    _onReceivedDeferredDeepLink?.call(url);
  }
}
