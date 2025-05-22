<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

LinkId Mobile Marketing Platform for Flutter

## Getting started

Run this command:

```
$ flutter pub add flutter_linkid_mmp
```

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

```
dependencies:
    flutter_linkid_mmp: ^1.1.80
```

Alternatively, your editor might support dart pub get or flutter pub get. Check the docs for your editor to learn more.

## Usage

### Retail Media

#### 1. Widget AdRetailMediaWidget

- A built-in widget that can get ad from id and type, display ad to user and handle tracking ad click, tracking ad impression.
- Parameters:

| Parameters         | Description                                                                                                                                        |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| adId               | Advertisement's id, get from Ad Inventory on Airflex portal                                                                                        |
| adType             | Type of ad. Currently there are 2 types: BANNER (only image) and PRODUCT (information about product including image, name, description and price). |
| placeholder        | Placeholder when getting ad                                                                                                                        |
| padding            | Padding around ad, default is EdgeInsets.all(16)                                                                                                   |
| borderRadius       | Border radius around ad, default is BorderRadius.zero                                                                                              |
| adCarouselConfig   | Configuration for ad carousel                                                                                                                      |
| timeoutGetAd       | Timeout when getting ad, default is Duration(seconds: 30)                                                                                          |
| keepAlive          | Whether to keep this widget alive in lazy list, default is true                                                                                    |
| adListenerCallback | Listener callbacks for ad widget such as onAdError, onAdClick, onAdImpression,...                                                                  |

```dart
AdRetailMediaWidget(
    adId: 'ad inventory id',
    adType: AdType.banner,
    placeholder: Center(child: CircularProgressIndicator()),
    padding: EdgeInsets.all(16),
    borderRadius: BorderRadius.all(Radius.circular(8)),
    adCarouselConfig: AdCarouselConfig(
        autoPlay: true,
        enableInfiniteScroll: true,
        autoPlayInterval:const Duration(seconds: 5),
        showIndicator: true,
        indicatorHeight: 20,
        indicatorBuilder: (isSelected) {
            // Your custom indicator builder
        }
    ),
    keepAlive: true,
    timeoutGetAd: Duration(seconds: 30),
    adListenerCallback: AdListenerCallback(
        onAdError: (error, adId, adType) {
            debugPrint('onAdError: $error, $adId, $adType');
        },
        onAdClick: (adId, adType, productId, actionType, actionData) {
            debugPrint('onAdClick: $adId, $adType, $productId, $actionType, $actionData');
            // Should check actionType is inapp or outapp to handle actionData:
            // If actionType = inapp then should use product id or actionData to navigate to a specific screen in your app
            // If actionType = outapp then should open actionData as an url outside your app
        },
        onAdImpression: (adId, adType, productId) {
            debugPrint('onAdImpression: $adId, $adType, $productId');
        },
    ),
)
```

#### 2. Customize your ad UI:

- Use Airflex.shared.getAd() to get all information about your ad and the product it represent.
- Then you can write your own widget to display your ad and handle action onAdClick, onAdImpression from scratch.
- Remember when handling action onAdClick and onAdImpression, you must call Airflex.shared.trackAdClick() and Airflex.shared.trackAdImpression().

#### 3. Ad functions:

| Functions                          | Description                                                                                                                                                                                                                                                |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Airflex.shared.getAd()             | Get ad by id (get from Ad Inventory on Airflex Portal) and type (banner, product,...). The response is in raw format (Map<String, dynamic>), you can use the pre-defined AdMediaData class to parse the response to a model or write your own model class. |
| Airflex.shared.trackAdClick()      | Tracking event on user click an ad.                                                                                                                                                                                                                        |
| Airflex.shared.trackAdImpression() | Tracking event on user see your ad.                                                                                                                                                                                                                        |

- Product id can be retrieved from Airflex.shared.getAd() in 1 of 2 ways: (1) Get from attributes data-ad-element-id in html from field adData, (2) Get from field id in adDataJson.

## Example

## Additional information

Email: leonacky@gmail.com
