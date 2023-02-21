import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

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
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Tên đăng nhập',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Mật khẩu',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushReplacement('/catalog');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                child: const Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
