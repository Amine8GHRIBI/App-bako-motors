
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_project/ui/pages/Dashboard.dart';
import 'package:mini_project/ui/pages/Meteo-page.dart';

import '../../DataBase/user_database.dart';
import '../../data/userEntity.dart';
import '../pages/DashbordScreen.dart';
import '../pages/Home-Page.dart';
import '../pages/Obd-Home-page.dart';
import '../pages/car_page.dart';
import '../widget/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

Widget buildBottomNavBar(int currIndex, Size size, ThemeData themeData , BuildContext context ,  UserDatabase databas , User use) {
  late UserDatabase database = databas;
  User user = use;
   final theme = Theme.of(context);

   return BottomNavigationBar(

    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 0),
    unselectedLabelStyle: const TextStyle(fontSize: 0),
    currentIndex: currIndex,
    backgroundColor: theme.primaryColor.withOpacity(.1),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: themeData.brightness == Brightness.dark
        ? Colors.indigoAccent
        : Colors.black,
    unselectedItemColor: const Color(0xff3b22a1),
    onTap: (value) {
      switch (value) {
        case 0:

          // Navigator.pushNamed(context , '/dashboard',arguments: {"database" : database , "user" : user});
          Get.to(DashboardScreen( database: database, user :user));
          break;
        case 1:
         // Get.to(dashboard(),arguments: {"database" : database , "user" : user});
          Navigator.pushNamed(context , '/dash' ,arguments: {"database" : database , "user" : user});

          break;
        case 2:
         // Get.to(obd_home() ,arguments: {"database" : database , "user" : user});
          Navigator.pushNamed(context , '/bleu' ,arguments: {"database" : database , "user" : user});

          break;

        case 3:
        Navigator.pushNamed(context , '/home',arguments: {"database" : database , "user" : user});
         // Get.to(car_page(),arguments: {"database" : database , "user" : user});

          break;
      }
/*
      if (value != currIndex) {
        if (value == 2) {
          Get.off(const MeteoPage());
        }
      }*/
    },
     items: [
       buildBottomNavItem(
         UniconsLine.apps,
         themeData,
         size,
       ),
       buildBottomNavItem(
         FontAwesomeIcons.carAlt,
         themeData,
         size,
       ),
       buildBottomNavItem(
         FontAwesomeIcons.map,
         themeData,
         size,
       ),
       buildBottomNavItem(
         FontAwesomeIcons.bell,
         themeData,
         size,
       ),
     ],
  );
}
