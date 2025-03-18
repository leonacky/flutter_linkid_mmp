import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_media_data.dart';
import 'package:flutter_linkid_mmp/ad_media/ad_type.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';

import '_ad_widget.dart';

class AdMediaCarousel extends StatefulWidget {
  const AdMediaCarousel({
    super.key,
    this.adId,
  });

  final String? adId;

  @override
  State<AdMediaCarousel> createState() => _AdMediaCarouselState();
}

class _AdMediaCarouselState extends State<AdMediaCarousel> {
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Airflex.shared.getAdByType(AdType.carousel),
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox.shrink();
        AdMediaData adCarousel = snapshot.data!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              itemCount: adCarousel.adData.length,
              options: CarouselOptions(
                viewportFraction: 1,
                aspectRatio: adCarousel.adType!.size.aspectRatio,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  currentPageNotifier.value = index;
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return AdWidget(adContent: adCarousel.adData[index]);
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
          ],
        );
      },
    );
  }
}
