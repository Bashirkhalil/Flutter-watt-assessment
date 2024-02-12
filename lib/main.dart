import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_application/startLocation/view/start_location_page.dart';
import 'package:tracking_application/summrary/view/summary.dart';

import 'endLocation/view/end_location_page.dart';
import 'login/view/login_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const LoginPage(),
    );
  }
}
