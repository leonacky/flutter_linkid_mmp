import 'dart:async' as DartAsync;
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter_linkid_mmp/deep_link_handler.dart';
import 'package:flutter_linkid_mmp/user_info.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

class FlutterLinkIdMMP implements DeepLinkHandler {
  static final FlutterLinkIdMMP shared = FlutterLinkIdMMP._internal();

  factory FlutterLinkIdMMP() {
    return shared;
  }

  FlutterLinkIdMMP._internal() {
    FlutterLinkIdMmpPlatform.instance.setDeepLinkHandler(this);
  }

  Function(String url)? _onReceivedDeepLink;
  String currentDeeplink = "";

  static R? runZonedGuarded<R>(
      R body(), void onError(Object error, StackTrace stack),
      {Map<Object?, Object?>? zoneValues,
      ZoneSpecification? zoneSpecification}) {
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      print('===== onError: FlutterError =====');
      if (errorDetails.stack != null) {
        onError(errorDetails.exception, errorDetails.stack!);
      }
      shared.recordError(errorDetails.exception, errorDetails.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      print('===== onError: PlatformDispatcher =====');
      onError(error, stack);
      shared.recordError(error, stack);
      return true;
    };
    return DartAsync.runZonedGuarded(body,
        (Object error, StackTrace stackTrace) async {
      onError(error, stackTrace);
      print('===== onError: runZonedGuarded =====');
      shared.recordError(error, stackTrace);
    }, zoneValues: zoneValues, zoneSpecification: zoneSpecification);
  }

  Future<void> recordError(Object error, StackTrace? stackTrace,
      {String? reason}) async {
    String stack0 = stackTrace.toString().split("\n")[0];
    String errorAndTrace = reason != null ? "reason: $reason\n" : "";
    errorAndTrace += "${error.toString()} \n${stackTrace?.toString()}";
    print('===== recordError =====');
    print('$error\nStack Trace:\n$stackTrace');
    FlutterLinkIdMmpPlatform.instance.recordError(stack0, errorAndTrace);
  }

  void deepLinkHandler(
      {Function(String url)? onReceivedDeepLink}) {
    _onReceivedDeepLink = onReceivedDeepLink;
    if (currentDeeplink != "") {
      _onReceivedDeepLink?.call(currentDeeplink);
    }
  }

  Future<String?> getPlatformVersion() {
    return FlutterLinkIdMmpPlatform.instance.getPlatformVersion();
  }

  Future<bool> initSDK(
      {required String partnerCode, required String appSecret}) {
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

  Future<bool> setDevMode(bool devMode) {
    return FlutterLinkIdMmpPlatform.instance.setDevMode(devMode);
  }

  Future<bool> setRevenue(
      {required String orderId,
      required double amount,
      required String currency,
      Map<String, dynamic>? data}) {
    return FlutterLinkIdMmpPlatform.instance
        .setRevenue(orderId, amount, currency, data: data);
  }

  @override
  void onReceivedDeepLink(String url) {
    // TODO: implement onReceivedDeepLink
    currentDeeplink = url;
    _onReceivedDeepLink?.call(url);
  }
}
