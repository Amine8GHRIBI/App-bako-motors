
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_project/ui/pages/Meteo-page.dart';

import '../pages/Home-Page.dart';
import '../widget/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

Widget buildBottomNavBar(int currIndex, Size size, ThemeData themeData , BuildContext context) {

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
      debugPrint("valueeeeeeeeeee"+value.toString());
      debugPrint("curinr"+currIndex.toString());
       
/*
      if (value != currIndex) {
        if (value == 2) {
          Get.off(const MeteoPage());
        }
      }*/
    },
    items: [
      buildBottomNavItem(
        UniconsLine.bell,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.map_marker,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.user,
        themeData,
        size,
      ),
      buildBottomNavItem(
        UniconsLine.apps,
        themeData,
        size,
      ),
    ],
  );
}
