import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mini_project/ui/pages/Gallerie-page.dart';
import 'package:mini_project/ui/pages/Meteo-page.dart';
import 'package:mini_project/ui/pages/Home-page.dart';

import 'data/themes_data.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      title: 'Car Rental App',
      home: const HomePage(),

      theme: lightModeTheme,
      darkTheme: darkModeTheme,
    routes: {
      '/méteo': (context) => MeteoPage(),
      '/gallerie' : (context) => GalleriePage(),
      '/home' : (context) => HomePage(),


    });
}}


