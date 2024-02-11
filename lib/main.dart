import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_application/startLocation/view/start_location_page.dart';

void main() {
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
      home:  const StartLocationPage(),
    );
  }
}
