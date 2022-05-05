import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:unicons/unicons.dart';
import '../../../../data/Moyenne.dart';
import '../../../../data/cars.dart';


Padding buildMoy(int i, Size size, ThemeData theme) {
  return Padding(
    padding: EdgeInsets.only(
     // right: size.width * 0.04,
      left: size.width *0.004,
    ),
    child: Center(
      child: SizedBox(
        height: size.width * 3.9,
       // width: size.width * 0.90,
        child: Container(
          decoration: BoxDecoration(
            color:theme.cardTheme.color,
          //  borderRadius: BorderRadius.circular(10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 0.5,
                color: theme.primaryColor
            ),

/*
            gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            stops: [0.028, 0.01],
                  colors: [HexColor("#175989"), Colors.white]
              ),
*/
            boxShadow: [
              BoxShadow(
                color: theme.cardColor,
                blurRadius: 4,
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

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Text(
                      moyenne[i]['nom'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color:  theme.textTheme.headline1?.color,
                        fontSize: size.width * 0.030,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    UniconsLine.battery_bolt,
                    color: theme.textTheme.headline1?.color,
                    size: size.width * 0.06,
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [

                      Text(
                        moyenne[i]['valeur'],
                        style: GoogleFonts.poppins(
                          color:  theme.textTheme.headline1?.color,
                          fontSize: size.width * 0.045,
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