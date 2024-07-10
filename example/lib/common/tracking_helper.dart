
import 'package:flutter_linkid_mmp/deeplink_airflex_parameter.dart';
import 'package:flutter_linkid_mmp/deeplink_android_parameter.dart';
import 'package:flutter_linkid_mmp/deeplink_builder.dart';
import 'package:flutter_linkid_mmp/deeplink_ios_parameter.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';
import 'package:flutter_linkid_mmp/product_item.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

class TrackingHelper {
  static logEvent({required String event, Map<String, dynamic>? data}) {
    Airflex().logEvent(event, data: data);
    // FirebaseAnalytics.instance.logEvent(name: event, parameters: data);
  }

  static createDeepLink() async {
    DeepLinkBuilder deepLinkBuilder = DeepLinkBuilder();
    DeepLinkAirflexParameter airflexParameter = DeepLinkAirflexParameter(
        shortLinkId: "memberCode",
        name: "Test from Flutter SDK",
        source: "app",
        code: "memberCode",
        medium: "medium",
        campaign: "campaign1",
        term: "term",
        redirectUrl: "redirectUrl",

    );
    deepLinkBuilder.airflexParameters = airflexParameter;
    DeepLinkIOSParameter iosParameter = DeepLinkIOSParameter(bundleID: 'com.airflex.linkidmmp', appStoreID: '1234567890');
    iosParameter.customSchema = 'app://linkidmmp';
    deepLinkBuilder.iOSParameters = iosParameter;
    DeepLinkAndroidParameter androidParameter = DeepLinkAndroidParameter(packageName: 'com.airflex.linkidmmp');
    androidParameter.customSchema = 'app://linkidmmp';
    deepLinkBuilder.androidParameters = androidParameter;
    DeepLinkBuilderResult result = await deepLinkBuilder.createLink();
    print(result.shortLink);
    print(result.longLink);
    print(result.qrLink);
  }

  static createShortLink() async {
      DeepLinkBuilder deepLinkBuilder = DeepLinkBuilder();
      DeepLinkBuilderResult result = await deepLinkBuilder.createShortLink(
          longLink: "longLink"
      );
      print(result.shortLink);
      print(result.longLink);
  }

  static setRevenue(
      {required String orderId,
      required double amount,
      required String currency,
      Map<String, dynamic>? data}) {
    Airflex().setRevenue(
        orderId: orderId, amount: amount, currency: currency, data: data);
    // FirebaseAnalytics.instance.logEvent(name: event, parameters: data);
  }


  static setProductList(
      {required String listName, required List<ProductItem> products}) {
    Airflex().setProductList(listName: listName, products: products);
    // FirebaseAnalytics.instance.logEvent(name: event, parameters: data);
  }

  static setCurrentScreen({required String screenName}) {
    Airflex().setCurrentScreen(screenName: screenName);
    // FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
  }
}
