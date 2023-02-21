import 'flutter_linkid_mmp_platform_interface.dart';

class FlutterLinkidMmp {
  Future<String?> getPlatformVersion() {
    return FlutterLinkidMmpPlatform.instance.getPlatformVersion();
  }

  Future<bool> initSDK({required String partnerCode}) {
    return FlutterLinkidMmpPlatform.instance.initSDK(partnerCode: partnerCode);
  }

  Future<bool> event({required String name, Map<String, Object>? data}) {
    return FlutterLinkidMmpPlatform.instance.event(eventName: name, data: data);
  }
}
