import 'package:flutter_linkid_mmp/flutter_linkid_mmp_platform_interface.dart';

import 'deeplink_airflex_parameter.dart';
import 'deeplink_android_parameter.dart';
import 'deeplink_ios_parameter.dart';

class DeepLinkBuilderResult {
  String? longLink;
  String? shortLink;
  String? qrLink;
  bool success = false;
  String? message;

  DeepLinkBuilderResult(
      {this.longLink, this.shortLink, this.qrLink, this.success = false, this.message});

  @override
  String toString() {
    // TODO: implement toString
    return "longLink: $longLink, shortLink: $shortLink, qrLink: $qrLink, success: $success, message: $message";
  }
}

class DeepLinkBuilder {
  DeepLinkIOSParameter? iOSParameters;
  DeepLinkAndroidParameter? androidParameters;
  DeepLinkAirflexParameter? airflexParameters;

  DeepLinkBuilder(
      {this.iOSParameters, this.androidParameters, this.airflexParameters});

  Map<String, dynamic> buildParams() {
    Map<String, dynamic> params = {};
    Map<String, dynamic> fields = {};
    if (iOSParameters != null) {
      fields.addAll(iOSParameters!.buildParams());
    }
    if (androidParameters != null) {
      fields.addAll(androidParameters!.buildParams());
    }
    if (airflexParameters != null) {
      fields.addAll(airflexParameters!.buildParams());
    }
    List<Map<String, dynamic>> _fields = List.empty(growable: true);
    fields.forEach((key, value) {
      _fields.add({"key": key, "value": value});
    });
    params["fields"] = _fields;
    return params;
  }

  Future<DeepLinkBuilderResult> createLink() async {
    var params = buildParams();
    var result = await FlutterLinkIdMmpPlatform.instance.createLink(params);
    var data = DeepLinkBuilderResult();
    if (result != null) {
      data.longLink = result["longLink"];
      data.shortLink = result["shortLink"];
      data.qrLink = result["qrLink"];
      data.success = result["success"];
      data.message = result["message"];
    }
    return data;
  }

  Future<DeepLinkBuilderResult> createShortLink(
      {required String longLink,
      String name = "",
      String shortLinkId = ""}) async {
    var result = await FlutterLinkIdMmpPlatform.instance.createShortLink(
        longLink: longLink, name: name, shortLinkId: shortLinkId);
    var data = DeepLinkBuilderResult();
    if (result != null) {
      data.longLink = result["longLink"];
      data.shortLink = result["shortLink"];
      data.qrLink = result["qrLink"];
      data.success = result["success"];
      data.message = result["message"];
    }
    return data;
  }
}
