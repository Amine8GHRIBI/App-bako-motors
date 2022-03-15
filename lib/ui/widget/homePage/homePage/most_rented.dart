
import 'package:flutter/material.dart';

import '../../../../data/cars.dart';
import 'car.dart';
import 'category.dart';

Widget buildMostRented(Size size, ThemeData themeData) {
  return Column(
    children: [
      buildCategory('Menu', size, themeData),
      Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.018,
          left: size.width * 0.03,
          right: size.width * 0.03,
        ),
        child: SizedBox(
          height: size.width * 0.43,
          width: cars.length * size.width * 0.5 * 1.03,
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: cars.length,
            itemBuilder: (context, i) {
              return buildCar(
                i,
                size,
                themeData,
              );
            },
          ),
        ),
      ),
    ],
  );
}
