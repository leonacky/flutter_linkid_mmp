// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_media_data.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';

import '_ad_widget.dart';

class AdMediaBanner extends StatefulWidget {
  const AdMediaBanner({
    super.key,
    this.adId,
  });

  final String? adId;

  @override
  State<AdMediaBanner> createState() => _AdMediaBannerState();
}

class _AdMediaBannerState extends State<AdMediaBanner> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Airflex.shared.getAdByType(AdType.banner),
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox.shrink();
        AdMediaData adBanner = snapshot.data!;
        adBanner = adBanner.copyWith(adData: adBanner.adData.take(1).toList());
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              width: width,
              height: width / adBanner.adType!.size.aspectRatio,
              child: AdWidget(adContent: adBanner.adData.first),
            );
          },
        );
      },
    );
  }
}
