import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';

class AdMediaData {
  final List<String> adData;
  final String actionType;
  final String actionData;
  final AdSize size;

  AdMediaData({
    this.adData = const [],
    this.actionType = '',
    this.actionData = '',
    this.size = const AdSize(),
  });

  AdType? get adType {
    switch (adData.length) {
      case 0:
        return null;
      case 1:
        return AdType.banner;
      default:
        return AdType.product;
    }
  }

  double get ratio => size.ratio;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adData': adData,
      'actionType': actionType,
      'actionData': actionData,
      'size': size.toMap(),
    };
  }

  factory AdMediaData.fromMap(Map<String, dynamic> map) {
    return AdMediaData(
      adData: (map['adData'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      actionType: map['actionType'] as String? ?? '',
      actionData: map['actionData'] as String? ?? '',
      size: map['size'] is Map<String, dynamic> ? AdSize.fromMap(map['size'] as Map<String, dynamic>) : const AdSize(),
    );
  }

  AdMediaData copyWith({
    List<String>? adData,
    String? actionType,
    String? actionData,
    AdSize? size,
  }) {
    return AdMediaData(
      adData: adData ?? this.adData,
      actionType: actionType ?? this.actionType,
      actionData: actionData ?? this.actionData,
      size: size ?? this.size,
    );
  }
}

class AdSize {
  final double width;
  final double height;

  const AdSize({
    this.width = 0,
    this.height = 0,
  });

  double get ratio => width / height;

  Size get toFlutterSize => Size(width, height);

  @override
  String toString() {
    return '$runtimeType($width x $height)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
    };
  }

  factory AdSize.fromMap(Map<String, dynamic> map) {
    return AdSize(
      width: (map['width'] as num? ?? 0).toDouble(),
      height: (map['height'] as num? ?? 0).toDouble(),
    );
  }
}

enum AdActionType {
  none,
  inapp,
  outapp;

  static AdActionType fromString(String value) {
    return AdActionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AdActionType.none,
    );
  }
}
