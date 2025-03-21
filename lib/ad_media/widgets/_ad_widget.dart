part of 'ad_retail_media_widget.dart';

class _AdWidget extends StatefulWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);

  const _AdWidget({
    Key? key,
    required this.adContent,
    required this.size,
    this.padding = _AdWidget.defaultPadding,
    this.onAdImpression,
    this.onAdClick,
    this.onClose,
  }) : super(key: key);

  final String adContent;
  final Size size;
  final EdgeInsets padding;
  final AdActionCallback? onAdImpression;
  final AdActionCallback? onAdClick;
  final VoidCallback? onClose;

  @override
  State<_AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<_AdWidget> {
  dom.NodeList _parseHtml(String html) => parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;

  String productId = '';

  @override
  void initState() {
    super.initState();
    final dom.NodeList nodes = _parseHtml(widget.adContent);
    final dom.Element root = nodes.first as dom.Element;
    productId = root.attributes['data-ad-element-id'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: _AdActionWrapper(
        onClick: () => widget.onAdClick?.call(productId),
        onImpression: () => widget.onAdImpression?.call(productId),
        onClose: widget.onClose,
        child: AspectRatio(
          aspectRatio: widget.size.aspectRatio,
          child: AbsorbPointer(
            child: HtmlWidget(
              widget.adContent,
              enableCaching: true,
            ),
          ),
        ),
      ),
    );
  }
}
