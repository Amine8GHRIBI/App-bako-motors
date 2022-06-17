import 'package:flutter/material.dart';

BottomNavigationBarItem buildBottomNavItem(
    IconData icon, ThemeData themeData, Size size) {
  return BottomNavigationBarItem(
    icon: SizedBox(
      height: size.width * 0.12,
      width: size.width * 0.12,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          //themeData.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Icon(
          icon,
        ),
      ),
    ),
    label: '',
  );
}
