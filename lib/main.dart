import 'package:flutter/material.dart';
import 'package:safesync/home_page.dart';

// import 'package:safesync/login_page.dart';
// import 'package:safesync/qr_code_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}







// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text('Login Page',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//       ),
//       body: Column(
//         children: [ ],
//       ),
//     );
//   }
// }
