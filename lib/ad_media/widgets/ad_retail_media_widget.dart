// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_linkid_mmp/ad_media/widgets/ad_listener_callback.dart';
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
typedef AdClickCallback = void Function(String productId, String actionType, String actionData);

class AdRetailMediaWidget extends StatefulWidget {
  final String adId;
  final AdType adType;
  final EdgeInsets padding;
  final Widget? placeholder;
  final Duration timeoutGetAd;
  final bool keepAlive;
  final AdListenerCallback? adListenerCallback;

  const AdRetailMediaWidget({
    super.key,
    required this.adId,
    required this.adType,
    EdgeInsets? padding,
    this.placeholder,
    this.timeoutGetAd = const Duration(seconds: 30),
    this.keepAlive = true,
    this.adListenerCallback,
  }) : padding = padding ?? _AdWidget.defaultPadding;

  @override
  State<AdRetailMediaWidget> createState() => _AdRetailMediaWidgetState();
}

class _AdRetailMediaWidgetState extends State<AdRetailMediaWidget> with AutomaticKeepAliveClientMixin {
  AdMediaData? ad;

  bool showAd = true;

  AdListenerCallback? get callback => widget.adListenerCallback;

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSize(
      duration: Durations.medium2,
      child: FutureBuilder(
        future: _getAd(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return widget.placeholder != null
                ? Padding(
                    padding: widget.padding,
                    child: widget.placeholder,
                  )
                : const SizedBox.shrink();
          }
          if (snapshot.data == null || !showAd) {
            return const SizedBox.shrink();
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
      final response = await FlutterLinkIdMmpPlatform.instance
          .getAd(
            adId: widget.adId,
            adType: widget.adType.name.toUpperCase(),
          )
          .timeout(widget.timeoutGetAd);
      if (response?["adItem"] == null) return null;
      ad = AdMediaData.fromMap(response!["adItem"]);
      if (ad!.adData.isEmpty) return null;
      return ad;
    } catch (e) {
      debugPrint('AdRetailMediaWidget._getAd Error: $e');
      callback?.onAdError?.call(e, widget.adId, widget.adType.name);
      return null;
    }
  }

  void _onAdImpression(String productId) async {
    if (ad == null) return;
    if (kDebugMode) {
      debugPrint('AdRetailMediaWidget._onAdImpression: adId = ${widget.adId}, productId = $productId');
    }
    FlutterLinkIdMmpPlatform.instance.trackAdImpression(adId: widget.adId, productId: productId);
    callback?.onAdImpression?.call(widget.adId, widget.adType.name, productId);
  }

  void _onAdClick(String productId, String actionType, String actionData) async {
    if (ad == null) return;
    if (kDebugMode) {
      debugPrint('AdRetailMediaWidget._onAdClick: adId = ${widget.adId}, productId = $productId');
    }
    try {
      FlutterLinkIdMmpPlatform.instance.trackAdClick(adId: widget.adId, productId: productId);

      if (callback?.onAdClick != null) {
        callback?.onAdClick?.call(widget.adId, widget.adType.name, productId, actionType, actionData);
        return;
      }

      final url = Uri.tryParse(actionData);
      if (url == null || !await canLaunchUrl(url)) return;
      switch (AdActionType.fromString(actionType)) {
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
      callback?.onAdError?.call(e, widget.adId, widget.adType.name);
    }
  }

  void _onClose() {
    setState(() {
      showAd = !showAd;
    });
    if (!showAd) {
      callback?.onAdDismissed?.call(widget.adId, widget.adType.name);
    }
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
    "adDataJson": '''
[
    {
        "id": "1c959901-7da9-4047-ac8f-d7c6dedfc648",
        "created_at": "2025-03-20T03:19:09.610Z",
        "updated_at": "2025-03-20T03:19:09.610Z",
        "created_by": null,
        "updated_by": null,
        "deleted_at": null,
        "deleted_by": null,
        "ad_id": "78b59d9e-66e4-4fbe-b54a-8e3918475d00",
        "banner_id": "86e196d7-4476-4152-88f3-2d55a5aa692c",
        "banner_crop_url": null,
        "banner": {
            "id": "86e196d7-4476-4152-88f3-2d55a5aa692c",
            "created_at": "2025-03-17T06:57:18.054Z",
            "updated_at": "2025-03-17T06:57:18.054Z",
            "created_by": "2",
            "updated_by": null,
            "deleted_at": null,
            "deleted_by": null,
            "advertiser_id": "ac064ba3-5163-4ef6-89f9-a60567c3a7f7",
            "name": "VPBank NEO",
            "banner_image": "https://d2fpeiluuf92qr.cloudfront.net/f88511bc-8358-5bce-844d-b1f2da16ba75.jpeg",
            "banner_target": "vpbank",
            "width": "20",
            "height": "9"
        }
    }
]
''',
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
  data-ad-element-id="89629575-5a36-4234-97b0-c3b035e55f39"
  style="
    background-color: #ffffff;
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
      src="https://d2fpeiluuf92qr.cloudfront.net/9e662820-f456-56b5-8ff3-953b3976226d.jpeg"
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
      <div
        style="
          color: #213547;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Máy tính Laptop HP 15 fc0085AU R5 7430U/16GB/512GB/Win11
      </div>
      <div
        style="
          display: block;
          margin-top: 2px;
          font-size: 10px;
          color: #aaa;
          line-height: 14px;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          overflow: hidden;
          max-lines: 2;
          text-overflow: ellipsis;
        "
      >
        Thiết kế hiện đại, thanh lịch. Ổn định cho mọi tác vụ văn phòng. Trải nghiệm chơi game mượt mà.
      </div>
    </div>
    <div style="weight: 0.9"></div>
    <div style="font-weight: 600; color: #6b1ca2">
      <div style="font-size: 14px">32.500.000 đ</div>
      <div
        style="
          font-size: 10px;
          color: #aaa;
          text-decoration: line-through;
        "
      >
        34.450.000 đ
      </div>
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
