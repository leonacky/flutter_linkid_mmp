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

  Future<bool> initSDK(String partnerCode) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> logEvent(String eventName, {Map<String, dynamic>? data}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> setUserInfo(UserInfo userInfo) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> setCurrentScreen(String screenName) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
