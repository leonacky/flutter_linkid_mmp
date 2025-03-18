import 'package:flutter_linkid_mmp/deep_link_handler.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_linkid_mmp_method_channel.dart';
import 'user_info.dart';

abstract class FlutterLinkIdMmpPlatform extends PlatformInterface {
  /// Constructs a FlutterLinkidMmpPlatform.
  FlutterLinkIdMmpPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLinkIdMmpPlatform _instance = MethodChannelFlutterLinkidMmp();

  /// The default instance of [FlutterLinkIdMmpPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLinkidMmp].
  static FlutterLinkIdMmpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLinkIdMmpPlatform] when
  /// they register themselves.
  static set instance(FlutterLinkIdMmpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initSDK(String partnerCode, String appSecret) {
    throw UnimplementedError('initSDK() has not been implemented.');
  }

  Future<bool> logEvent(String eventName, {Map<String, dynamic>? data}) {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  Future<bool> setUserInfo(UserInfo userInfo) {
    throw UnimplementedError('setUserInfo() has not been implemented.');
  }

  Future<bool> setCurrentScreen(String screenName) {
    throw UnimplementedError('setCurrentScreen() has not been implemented.');
  }

  Future<bool> setDevMode(bool devMode) {
    throw UnimplementedError('setDevMode() has not been implemented.');
  }

  void setDeepLinkHandler(DeepLinkHandler deepLinkHandler) {
    throw UnimplementedError('setDeepLinkHandler() has not been implemented.');
  }

  Future<bool> setRevenue(
    String orderId,
    double amount,
    String currency, {
    Map<String, dynamic>? data,
  }) {
    throw UnimplementedError('setRevenue() has not been implemented.');
  }

  Future<bool> recordError(String name, String stackTrace) {
    throw UnimplementedError('initSDK() has not been implemented.');
  }

  Future<bool> setProductList(
    String listName, {
    required List<Map<String, dynamic>> products,
  }) {
    throw UnimplementedError('setProductList() has not been implemented.');
  }

  Future<bool> removeUserToken() {
    throw UnimplementedError('removeUserToken() has not been implemented.');
  }

  Future<Map<String, dynamic>?> createLink(Map<String, dynamic> params) {
    throw UnimplementedError('createLink() has not been implemented.');
  }

  Future<Map<String, dynamic>?> createShortLink({
    required String longLink,
    String name = "",
    String shortLinkId = "",
  }) {
    throw UnimplementedError('createShortLink() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getAd(
      {required String adId, required String adType}) {
    throw UnimplementedError('getAd() has not been implemented.');
  }

  Future<bool> trackAdClick(
      {required String adId, String productId = ""}) {
    throw UnimplementedError('trackAdClick() has not been implemented.');
  }

  Future<bool> trackAdImpression(
      {required String adId, String productId = ""}) {
    throw UnimplementedError('trackAdImpression() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getAdById(String adId) {
    throw UnimplementedError('getAdById() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getAdByType(String adType) {
    throw UnimplementedError('getAdByType() has not been implemented.');
  }
}
