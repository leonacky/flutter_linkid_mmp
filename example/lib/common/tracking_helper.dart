import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

class TrackingHelper {
  static logEvent({required String event, Map<String, dynamic>? data}) {
    FlutterLinkIdMMP().logEvent(event, data: data);
    // FirebaseAnalytics.instance.logEvent(name: event, parameters: data);
  }

  static setCurrentScreen({required String screenName}) {
    FlutterLinkIdMMP().setCurrentScreen(screenName: screenName);
    // FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
  }
}
