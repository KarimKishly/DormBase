import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Carousel extends StatelessWidget {
  String name;
  Carousel({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> imgList = [];
    for(int i = 1; i <= 4; i++) {
      imgList.add('assets/dormImages/$name/$i.jpg');
    }

    return CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            enlargeCenterPage: true
          ),
          items: imgList.map((item) => Center(
              child: Image.asset(item, fit: BoxFit.cover, width: 400, height: 260,)
          )).toList(),
        );
  }
}
