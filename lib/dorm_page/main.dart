import 'package:dorm_base/dorm_page/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:dorm_base/dorm_page/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dorm Page',
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const HomePage(),
    );
  }
}
