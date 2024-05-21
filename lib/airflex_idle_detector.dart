import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';

class AirflexIdleDetector extends StatefulWidget {
  final Widget child;

  const AirflexIdleDetector({super.key, required this.child});

  @override
  State<AirflexIdleDetector> createState() => _AirflexIdleDetectorState();
}

class _AirflexIdleDetectorState extends State<AirflexIdleDetector> {
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    // TODO: implement initState
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    Airflex.shared.isKeyboardShowing = keyboardVisibilityController.isVisible;

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      Airflex.shared.isKeyboardShowing = visible;
    });
    super.initState();
  }

  @override
  build(context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {},
      child: widget.child,
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
