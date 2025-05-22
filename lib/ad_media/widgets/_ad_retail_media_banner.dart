part of 'ad_retail_media_widget.dart';

class _AdRetailMediaBanner extends StatelessWidget {
  const _AdRetailMediaBanner({
    Key? key,
    required this.ad,
    this.padding,
    this.borderRadius,
    this.onAdImpression,
    this.onAdClick,
    this.onClose,
  }) : super(key: key);

  final AdMediaData ad;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final AdActionCallback? onAdImpression;
  final AdClickCallback? onAdClick;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return _AdWidget(
      adContent: ad.adData.first,
      size: ad.size.toFlutterSize,
      padding: padding,
      borderRadius: borderRadius,
      onAdImpression: onAdImpression,
      onAdClick: onAdClick,
      onClose: onClose,
    );
  }
}
