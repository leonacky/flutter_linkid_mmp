// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../flutter_linkid_mmp_platform_interface.dart';
import '../ad_media_data.dart';

part '_ad_retail_media_banner.dart';
part '_ad_retail_media_product.dart';
part '_ad_widget.dart';
part '_ad_action_wrapper.dart';

typedef AdActionCallback = void Function(String productId);

class AdRetailMediaWidget extends StatefulWidget {
  final String adId;
  final AdType adType;
  final EdgeInsets padding;
  final Widget? placeholder;

  const AdRetailMediaWidget({
    super.key,
    required this.adId,
    required this.adType,
    EdgeInsets? padding,
    this.placeholder,
  }) : padding = padding ?? _AdWidget.defaultPadding;

  @override
  State<AdRetailMediaWidget> createState() => _AdRetailMediaWidgetState();
}

class _AdRetailMediaWidgetState extends State<AdRetailMediaWidget> {
  AdMediaData? ad;

  bool showAd = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Durations.medium2,
      child: FutureBuilder(
        future: _getAd(),
        builder: (context, snapshot) {
          if (snapshot.data == null || !showAd) {
            return widget.placeholder != null
                ? Padding(
                    padding: widget.padding,
                    child: widget.placeholder,
                  )
                : const SizedBox.shrink();
          }
          switch (widget.adType) {
            case AdType.banner:
              return _AdRetailMediaBanner(
                ad: ad!,
                padding: widget.padding,
                onAdImpression: _onAdImpression,
                onAdClick: _onAdClick,
                onClose: _onClose,
              );
            case AdType.product:
              return _AdRetailMediaProduct(
                ad: ad!,
                padding: widget.padding,
                onAdImpression: _onAdImpression,
                onAdClick: _onAdClick,
                onClose: _onClose,
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Future<AdMediaData?> _getAd() async {
    // Fake data
    // ad = AdMediaData.fromMap(widget.adType == AdType.banner ? fakeAdDataBanner : fakeAdDataProduct);
    if (ad != null) return ad;
    try {
      final response = await FlutterLinkIdMmpPlatform.instance.getAd(
        adId: widget.adId,
        adType: widget.adType.name.toUpperCase(),
      );
      if (response?["adItem"] == null) return null;
      ad = AdMediaData.fromMap(response!["adItem"]);
      if (ad!.adData.isEmpty) return null;
      return ad;
    } catch (e) {
      debugPrint('AdRetailMediaWidget._getAd Error: $e');
      return null;
    }
  }

  void _onAdImpression(String productId) async {
    if (ad == null) return;
    if (kDebugMode) {
      debugPrint('AdRetailMediaWidget._onAdImpression: adId = ${widget.adId}, productId = $productId');
    }
    FlutterLinkIdMmpPlatform.instance.trackAdImpression(adId: widget.adId, productId: productId);
  }

  void _onAdClick(String productId) async {
    if (ad == null) return;
    if (kDebugMode) {
      debugPrint('AdRetailMediaWidget._onAdClick: adId = ${widget.adId}, productId = $productId');
    }
    try {
      FlutterLinkIdMmpPlatform.instance.trackAdClick(adId: widget.adId, productId: productId);
      final url = Uri.tryParse(ad!.actionData);
      if (url == null || !await canLaunchUrl(url)) return;
      switch (AdActionType.fromString(ad!.actionType)) {
        case AdActionType.inapp:
          await launchUrl(
            url,
            mode: LaunchMode.inAppBrowserView,
            browserConfiguration: const BrowserConfiguration(showTitle: true),
          );
          break;
        case AdActionType.outapp:
          await launchUrl(url, mode: LaunchMode.externalApplication);
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('AdRetailMediaWidget._onAdClick Error: $e');
    }
  }

  void _onClose() {
    setState(() {
      showAd = !showAd;
    });
  }

  final Map<String, dynamic> fakeAdDataBanner = {
    "adData": [
      '''
<div
  data-ad-element-id="db4bf3c4-8f03-47ea-a077-b53908bb02ca"
  style="
    border-radius: 8px;
    border: 1px solid #f3f4f6;
    background-color: #fff;
    box-sizing: border-box;
    width: 100%;
    height: 100%;
  "
>
  <img
    src="https://d2fpeiluuf92qr.cloudfront.net/5c66d614-8f22-55b7-ae9a-56e0a04324ed.jpeg"
    alt="Image"
    style="height: 100%; width: 100%; border-radius: 8px; object-fit: cover"
  />
</div>
''',
    ],
    "size": {
      "width": 1080,
      "height": 400,
    },
    "actionType": "outapp",
    "actionData": "https://www.google.com"
  };

  final Map<String, dynamic> fakeAdDataProduct = {
    "adData": [
      '''
<div
  style="
    background-color: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    display: flex;
    overflow: hidden;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
  "
>
  <div
    style="
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      overflow: hidden;
      width: 34%;
      height: 100%;
    "
  >
    <img
      src="https://d2fpeiluuf92qr.cloudfront.net/694d08cc-dc15-51e1-9c52-47f11f39cc85.jpeg"
      alt="Image"
      style="width: 100%; height: 100%; object-fit: contain"
    />
  </div>
  <div
    style="
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 10px;
      font-size: 14px;
      width: calc(66% - 16px);
    "
  >
    <div>
      <div style="color: #213547; max-lines: 2; text-overflow: ellipsis">
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch
      </div>
      <div
        style="
          margin-top: 2px;
          font-size: 10px;
          color: #aaa;
          line-height: 14px;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Bàn Phím Razer BlackWidow V3 Mini HyperSpeed - Yellow Switch với khả
        năng chơi game ​​Wireless không có độ trễ trong một kiểu dáng đẹp, 65%,
        nó hoàn hảo cho mọi không gian và đủ linh hoạt cho mọi thiết lập và sử
        dụng hàng ngày.
      </div>
    </div>
    <div style="font-weight: 600; color: #6b1ca2">
      <span style="font-size: 14px">4.690.000 đ</span
      ><span
        style="
          margin-left: 4px;
          font-size: 10px;
          color: #aaa;
          text-decoration: line-through;
        "
      ></span>
    </div>
  </div>
</div>
''',
      '''
<div
  style="
    background-color: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    display: flex;
    overflow: hidden;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
  "
>
  <div
    style="
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      overflow: hidden;
      width: 34%;
      height: 100%;
    "
  >
    <img
      src="https://d2fpeiluuf92qr.cloudfront.net/507b018b-b04e-51a1-b2e3-815901c07024.jpeg"
      alt="Image"
      style="width: 100%; height: 100%; object-fit: contain;"
    />
  </div>
  <div
    style="
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 10px;
      font-size: 14px;
      width: calc(66% - 16px);
    "
  >
    <div>
      <div style="color: #213547; max-lines: 2; text-overflow: ellipsis">
        Samsung galaxy Fold 6
      </div>
      <div
        style="
          margin-top: 2px;
          font-size: 10px;
          color: #aaa;
          line-height: 14px;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Điện thoại Samsung Galaxy Z Fold6 màn hình mỏng hơn, bộ camera mạnh mẽ, đa nhiệm siêu mượt.
      </div>
    </div>
    <div style="font-weight: 600; color: #6b1ca2">
      <span style="font-size: 14px">38.000.000 đ</span
      ><span
        style="
          margin-left: 4px;
          font-size: 10px;
          color: #aaa;
          text-decoration: line-through;
        "
      >44.000.000 đ</span>
    </div>
  </div>
</div>
''',
    ],
    "size": {
      "width": 480,
      "height": 320,
    },
    "actionType": "inapp",
    "actionData": "https://www.google.com"
  };
}
