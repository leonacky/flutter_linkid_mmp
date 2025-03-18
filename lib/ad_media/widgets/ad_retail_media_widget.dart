// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../flutter_linkid_mmp.dart';
import '../ad_media_data.dart';

part '_ad_retail_media_banner.dart';
part '_ad_retail_media_product.dart';
part '_ad_widget.dart';

class AdRetailMediaWidget extends StatefulWidget {
  final String? adId;
  final AdType? adType;
  final EdgeInsets padding;

  factory AdRetailMediaWidget.fromId({
    Key? key,
    required String id,
    EdgeInsets? padding,
  }) {
    return AdRetailMediaWidget._(
      key: key,
      adId: id,
      padding: padding,
    );
  }

  factory AdRetailMediaWidget.fromType({
    Key? key,
    required AdType type,
    EdgeInsets? padding,
  }) {
    return AdRetailMediaWidget._(
      key: key,
      adType: type,
      padding: padding,
    );
  }

  const AdRetailMediaWidget._({
    super.key,
    this.adId,
    this.adType,
    EdgeInsets? padding,
  })  : padding = padding ?? _AdWidget.defaultPadding,
        assert(adId != null || adType != null, "`adId` or `adType` must not be null");

  @override
  State<AdRetailMediaWidget> createState() => _AdRetailMediaWidgetState();
}

class _AdRetailMediaWidgetState extends State<AdRetailMediaWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.adId?.isNotEmpty == true
          ? Airflex.shared.getAdById(widget.adId!)
          : Airflex.shared.getAdByType(widget.adType!),
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox.shrink();
        AdMediaData ad = snapshot.data!;
        switch (ad.adType) {
          case AdType.banner:
            return _AdRetailMediaBanner(
              ad: ad,
              padding: widget.padding,
            );
          case AdType.product:
            return _AdRetailMediaProduct(
              ad: ad,
              padding: widget.padding,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
