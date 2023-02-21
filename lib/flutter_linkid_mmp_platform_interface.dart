import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_linkid_mmp_method_channel.dart';

abstract class FlutterLinkidMmpPlatform extends PlatformInterface {
  /// Constructs a FlutterLinkidMmpPlatform.
  FlutterLinkidMmpPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLinkidMmpPlatform _instance = MethodChannelFlutterLinkidMmp();

  /// The default instance of [FlutterLinkidMmpPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLinkidMmp].
  static FlutterLinkidMmpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLinkidMmpPlatform] when
  /// they register themselves.
  static set instance(FlutterLinkidMmpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initSDK({required String partnerCode}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> event({required String eventName, Map<String, Object>? data}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
