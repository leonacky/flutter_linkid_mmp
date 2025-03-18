part of 'ad_retail_media_widget.dart';

class _AdRetailMediaBanner extends StatelessWidget {
  const _AdRetailMediaBanner({
    required this.ad,
    this.padding = _AdWidget.defaultPadding,
  });

  final AdMediaData ad;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return _AdWidget(
      adContent: ad.adData.first,
      size: ad.size.toFlutterSize,
      padding: padding,
    );
  }
}
