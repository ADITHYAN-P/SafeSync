import 'package:flutter/material.dart';
// import 'package:safe/login_page.dart';
import 'package:safesync/login_page.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Scanner'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
                child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
