// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';

class AdMediaData {
  final List<String> adData;
  final String actionType;
  final String actionData;

  AdMediaData({
    this.adData = const [],
    this.actionType = '',
    this.actionData = '',
  });

  AdType? get adType {
    switch (adData.length) {
      case 0:
        return null;
      case 1:
        return AdType.banner;
      default:
        return AdType.carousel;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adData': adData,
      'actionType': actionType,
      'actionData': actionData,
    };
  }

  factory AdMediaData.fromMap(Map<String, dynamic> map) {
    return AdMediaData(
      adData: map['adData'] is List<String> ? List<String>.from((map['adData'] as List<String>)) : const [],
      actionType: map['actionType'] as String? ?? '',
      actionData: map['actionData'] as String? ?? '',
    );
  }

  AdMediaData copyWith({
    List<String>? adData,
    String? actionType,
    String? actionData,
  }) {
    return AdMediaData(
      adData: adData ?? this.adData,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
    );
  }
}
