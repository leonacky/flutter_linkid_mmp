import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkid_mmp/flutter_linkid_mmp.dart';
import 'package:flutter_linkid_mmp/user_info.dart';
import 'package:flutter_linkid_mmp_example/common/tracking_helper.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class MyLogin extends StatelessWidget {
  String username = "";
  String password = "";

  MyLogin({super.key}) {
    print("partner_code_01");
    TrackingHelper.setCurrentScreen(screenName: "LoginScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LinkID MMP',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Tên đăng nhập',
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Mật khẩu',
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  TrackingHelper.logEvent(event: "Login");
                  if(username!="" && password!="") {
                    TrackingHelper.logEvent(event: "LoginSuccess");
                    FlutterLinkIdMMP().setUserInfo(UserInfo(
                        userId: username,
                        email: "$username@gmail.com",
                        age: 30));
                    context.pushReplacement('/catalog');
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng nhập thành công')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng nhập thất bại')));
                    TrackingHelper.logEvent(event: "LoginFail");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
