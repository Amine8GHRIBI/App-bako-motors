import 'package:flutter/material.dart';

import '../../../../data/Moyenne.dart';
import '../../../../data/cars.dart';
import 'brand_logo.dart';
import 'car.dart';
import 'moyenne.dart';


Column information (Size size, ThemeData themeData) {
  //
  return Column(
    children: [
  //buildCategory('Most Rented', size, themeData),
      Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.012,
          left: size.width * 0.017,
          right: size.width * 0.06,
        ),
        child: SizedBox(
          height: size.width * 0.25,
          width: moyenne.length * size.width * 1.5 * 1.09,
          child: GridView.builder(
            //padding: EdgeInsets.all(0),//primary: false,
            //padding: co
            // nst EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              //childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            //shrinkWrap: true,
            //scrollDirection: Axis.horizontal,
            itemCount: moyenne.length,
            itemBuilder: (context, i) {
              return buildMoy(i, size, themeData,);
            },
          ),
        ),
      ),
    ],
  );

}
