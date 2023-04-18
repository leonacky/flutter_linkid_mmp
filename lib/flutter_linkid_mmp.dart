import 'package:flutter_linkid_mmp/deep_link_handler.dart';
import 'package:flutter_linkid_mmp/user_info.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

class FlutterLinkIdMMP implements DeepLinkHandler{
  static final FlutterLinkIdMMP _instance = FlutterLinkIdMMP._internal();
  factory FlutterLinkIdMMP() {
    return _instance;
  }
  FlutterLinkIdMMP._internal();

  Function(String url)? _onReceivedDeferredDeepLink;
  Function(String url)? _onReceivedDeepLink;

  void deepLinkHandler({Function(String url)? onReceivedDeepLink, Function(String url)? onReceivedDeferredDeepLink}) {
    FlutterLinkIdMmpPlatform.instance.setDeepLinkHandler(this);
    _onReceivedDeferredDeepLink = onReceivedDeferredDeepLink;
    _onReceivedDeepLink = onReceivedDeepLink;
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
    _onReceivedDeepLink?.call(url);
  }

  @override
  void onReceivedDeferredDeepLink(String url) {
    // TODO: implement onReceivedDeferredDeepLink
    _onReceivedDeferredDeepLink?.call(url);
  }
}
