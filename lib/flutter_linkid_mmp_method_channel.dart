import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_linkid_mmp_platform_interface.dart';

/// An implementation of [FlutterLinkidMmpPlatform] that uses method channels.
class MethodChannelFlutterLinkidMmp extends FlutterLinkidMmpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_linkid_mmp');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initSDK({required String partnerCode}) async {
    // TODO: implement initSDK
    return false;
  }

  @override
  Future<bool> event({required String eventName, Map<String, Object>? data}) async {
    // TODO: implement event
    return false;
  }
}
