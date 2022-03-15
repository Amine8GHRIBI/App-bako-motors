import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import '../../../../data/Moyenne.dart';
import '../../../../data/cars.dart';


Padding buildMoy(int i, Size size, ThemeData themeData) {
  return Padding(
    padding: EdgeInsets.only(
     // right: size.width * 0.04,
      left: size.width *0.006,
    ),
    child: Center(
      child: SizedBox(
        height: size.width * 1.9,
       // width: size.width * 0.90,
        child: Container(
          decoration: BoxDecoration(
            color:Colors.grey.shade100,
          //  borderRadius: BorderRadius.circular(10),
              borderRadius: new BorderRadius.all(const Radius.circular(6.0)),

        gradient: new LinearGradient(
                  stops: [0.028, 0.01],
                  colors: [themeData.secondaryHeaderColor, Colors.white]
              ),

            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(2, 4), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.02,
            ),
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Text(
                      moyenne[i]['nom'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: themeData.secondaryHeaderColor,
                        fontSize: size.width * 0.028,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        moyenne[i]['valeur'],
                        style: GoogleFonts.poppins(
                          color: themeData.secondaryHeaderColor,
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}