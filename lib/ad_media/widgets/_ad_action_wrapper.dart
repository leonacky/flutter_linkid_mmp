// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ad_retail_media_widget.dart';

class _AdActionWrapper extends StatelessWidget {
  _AdActionWrapper({
    Key? key,
    required this.child,
    this.onClick,
    this.onImpression,
    this.onClose,
  }) : super(key: key) {
    if (VisibilityDetectorController.instance.updateInterval != _impressionUpdateInterval) {
      VisibilityDetectorController.instance.updateInterval = _impressionUpdateInterval;
    }
  }

  final Widget child;
  final VoidCallback? onClick;
  final VoidCallback? onImpression;
  final VoidCallback? onClose;

  static const String _iconInfo = 'packages/flutter_linkid_mmp/lib/ad_media/assets/ic_ad_info.svg';
  static const String _iconClose = 'packages/flutter_linkid_mmp/lib/ad_media/assets/ic_ad_close.svg';

  static const double _iconSize = 16;

  static const Duration _impressionUpdateInterval = Duration(milliseconds: 800);

  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClick,
          child: VisibilityDetector(
            key: _key,
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 1) {
                onImpression?.call();
              }
            },
            child: child,
          ),
        ),
        // Positioned(
        //   top: 4,
        //   right: 4,
        //   child: ColoredBox(
        //     color: Colors.white,
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Tooltip(
        //           message: 'Quảng cáo của Airflex',
        //           textStyle: const TextStyle(fontSize: 10, color: Colors.white),
        //           padding: const EdgeInsets.all(4),
        //           height: 16,
        //           triggerMode: TooltipTriggerMode.tap,
        //           showDuration: const Duration(seconds: 3),
        //           margin: const EdgeInsets.only(right: 16),
        //           verticalOffset: 8,
        //           child: SvgPicture.asset(
        //             _iconInfo,
        //             width: _iconSize,
        //             height: _iconSize,
        //           ),
        //         ),
        //         if (onClose != null) ...[
        //           const SizedBox(width: 4),
        //           InkWell(
        //             onTap: onClose,
        //             child: SvgPicture.asset(
        //               _iconClose,
        //               width: _iconSize,
        //               height: _iconSize,
        //             ),
        //           ),
        //         ],
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
