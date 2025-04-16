import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';

class AdMediaData {
  final List<String> adData;
  final Map<String, dynamic> adDataJson;
  final AdSize size;

  AdMediaData({
    this.adData = const [],
    this.adDataJson = const {},
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
      'adDataJson': adDataJson,
      'size': size.toMap(),
    };
  }

  factory AdMediaData.fromMap(Map<String, dynamic> map) {
    return AdMediaData(
      adData: (map['adData'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      adDataJson: map['adDataJson'] is String
          ? jsonDecode(map['adDataJson'] as String)
          : map['adDataJson'] as Map<String, dynamic>? ?? const {},
      size: map['size'] is Map<String, dynamic> ? AdSize.fromMap(map['size'] as Map<String, dynamic>) : const AdSize(),
    );
  }

  AdMediaData copyWith({
    List<String>? adData,
    Map<String, dynamic>? adDataJson,
    AdSize? size,
  }) {
    return AdMediaData(
      adData: adData ?? this.adData,
      adDataJson: adDataJson ?? this.adDataJson,
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
