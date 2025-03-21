part of 'ad_retail_media_widget.dart';

class _AdRetailMediaBanner extends StatelessWidget {
  const _AdRetailMediaBanner({
    Key? key,
    required this.ad,
    this.padding = _AdWidget.defaultPadding,
    this.onAdImpression,
    this.onAdClick,
    this.onClose,
  }) : super(key: key);

  final AdMediaData ad;
  final EdgeInsets padding;
  final AdActionCallback? onAdImpression;
  final AdActionCallback? onAdClick;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return _AdWidget(
      adContent: ad.adData.first,
      size: ad.size.toFlutterSize,
      padding: padding,
      onAdImpression: onAdImpression,
      onAdClick: onAdClick,
      onClose: onClose,
    );
  }
}
