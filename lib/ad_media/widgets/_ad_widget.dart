part of 'ad_retail_media_widget.dart';

class _AdWidget extends StatefulWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);

  const _AdWidget({
    Key? key,
    required this.adContent,
    required this.size,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    this.onAdImpression,
    this.onAdClick,
    this.onClose,
  })  : padding = padding ?? _AdWidget.defaultPadding,
        borderRadius = borderRadius ?? BorderRadius.zero,
        super(key: key);

  final String adContent;
  final Size size;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final AdActionCallback? onAdImpression;
  final AdClickCallback? onAdClick;
  final VoidCallback? onClose;

  @override
  State<_AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<_AdWidget> {
  dom.NodeList _parseHtml(String html) => parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;

  String productId = '';
  String actionType = '';
  String actionData = '';

  @override
  void initState() {
    super.initState();
    final dom.NodeList nodes = _parseHtml(widget.adContent);
    final dom.Element root = nodes.first as dom.Element;
    productId = root.attributes['data-ad-element-id'] ?? '';
    actionType = root.attributes['data-cta-type'] ?? '';
    actionData = root.attributes['data-cta-destination'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        clipBehavior: Clip.hardEdge,
        child: _AdActionWrapper(
          onClick: () => widget.onAdClick?.call(productId, actionType, actionData),
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
      ),
    );
  }
}
