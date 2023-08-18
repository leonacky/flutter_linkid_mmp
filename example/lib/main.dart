import 'dart:async';
import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';
import 'package:flutter_linkid_mmp/user_info.dart';
import 'package:flutter_linkid_mmp_example/common/tracking_helper.dart';
import 'package:flutter_linkid_mmp_example/screens/chat_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'common/theme.dart';

// import 'firebase_options.dart';
import 'models/cart.dart';
import 'models/catalog.dart';
import 'screens/cart.dart';
import 'screens/catalog.dart';
import 'screens/login.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

var fcmToken = "";

void main() {
  FlutterLinkIdMMP.runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  }, (error, stackTrace) async {

  });
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Demo');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => MyLogin(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => MyCatalog(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => MyCart(),
          ),
          GoRoute(
            path: 'chat',
            builder: (context, state) => const ChatPage(),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  // Future<void> initFcm(BuildContext context) async {
  //   await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
  //   print("fcmToken ${fcmToken}");
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //
  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //       try {
  //         EasyLoading.instance
  //           ..toastPosition = EasyLoadingToastPosition.bottom
  //           ..displayDuration = const Duration(milliseconds: 2000)
  //           ..indicatorType = EasyLoadingIndicatorType.fadingCircle
  //           ..loadingStyle = EasyLoadingStyle.dark
  //           ..indicatorSize = 45.0
  //           ..radius = 10.0
  //           ..progressColor = Colors.yellow
  //           ..backgroundColor = Colors.green
  //           ..indicatorColor = Colors.yellow
  //           ..textColor = Colors.yellow
  //           ..maskColor = Colors.blue.withOpacity(0.5)
  //           ..userInteractions = true
  //           ..dismissOnTap = false;
  //         EasyLoading.showInfo(
  //             '${message.notification?.title}\n${message.notification?.body}');
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   });
  // }

  Future<void> init(BuildContext context) async {
    FlutterLinkIdMMP.shared.setDevMode(true);
    await FlutterLinkIdMMP().initSDK(
      partnerCode: "lynk_id_uat",
      appSecret:
          "b3ccd1c20fa9154a559c304956f99b302027a87b87ad520c1c4dbdd4bb54be7a",
    );
    FlutterLinkIdMMP().deepLinkHandler(
      onReceivedDeepLink: (url) {
        print('onReceivedDeepLink in dart ' + url);
      }
    );
    // await initFcm(context);
    FlutterLinkIdMMP().setUserInfo(UserInfo(deviceToken: fcmToken));
  }

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    if (fcmToken == "") {
      init(context);
    }
    TrackingHelper.logEvent(event: "StartApp");
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Demo',
        theme: appTheme,
        routerConfig: router(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
