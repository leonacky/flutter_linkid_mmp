part of 'ad_retail_media_widget.dart';

class _AdRetailMediaProduct extends StatefulWidget {
  const _AdRetailMediaProduct({
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
  final AdClickCallback? onAdClick;
  final VoidCallback? onClose;

  @override
  State<_AdRetailMediaProduct> createState() => _AdRetailMediaProductState();
}

class _AdRetailMediaProductState extends State<_AdRetailMediaProduct> {
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  AdMediaData get adCarousel => widget.ad;

  @override
  void dispose() {
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = width / adCarousel.ratio;
            return CarouselSlider.builder(
              itemCount: adCarousel.adData.length,
              options: CarouselOptions(
                viewportFraction: 1,
                aspectRatio: (width + widget.padding.horizontal) / (height + widget.padding.top),
                autoPlay: adCarousel.adData.length > 1,
                enableInfiniteScroll: adCarousel.adData.length > 1,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  currentPageNotifier.value = index;
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return _AdWidget(
                  adContent: adCarousel.adData[index],
                  size: adCarousel.size.toFlutterSize,
                  padding: widget.padding.copyWith(bottom: 0),
                  onAdImpression: widget.onAdImpression,
                  onAdClick: widget.onAdClick,
                  onClose: widget.onClose,
                );
              },
            );
          },
        ),
        if (adCarousel.adData.length > 1)
          SizedBox(
            height: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: adCarousel.adData.map(
                (ad) {
                  return ValueListenableBuilder(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, child) {
                      final bool isCurrent = adCarousel.adData[currentPage] == ad;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isCurrent ? 12 : 10,
                        height: isCurrent ? 12 : 10,
                        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 0.5, color: Colors.black26),
                          color: isCurrent ? Colors.white : Colors.grey.shade300,
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
          ),
        SizedBox(height: widget.padding.bottom),
      ],
    );
  }
}
