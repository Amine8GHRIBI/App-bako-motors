import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mini_project/ui/pages/Gallerie-page.dart';
import 'package:mini_project/ui/pages/Login.dart';
import 'package:mini_project/ui/pages/Meteo-page.dart';
import 'package:mini_project/ui/pages/Home-page.dart';
import 'package:mini_project/ui/pages/SignIn.dart';
import 'package:mini_project/ui/pages/connectivity.dart';
import 'package:mini_project/ui/pages/number.dart';
import 'package:mini_project/ui/pages/profile_page.dart';
import 'package:mini_project/ui/pages/userDetails.dart';
import 'package:mini_project/ui/pages/user-page.dart';
//import 'package:splashscreen/splashscreen.dart';

import 'DataBase/user_database.dart';
import 'data/car_page.dart';
import 'data/model.dart';
import 'data/themes_data.dart';
import 'data/userEntity.dart';

import 'package:provider/provider.dart';



Future <void> main() async {

  //WidgetsFlutterBinding.ensureInitialized();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ObdReader()),
      ],
      child: MyApp(),),);
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
      home : UserLogin(),
      /*home:  SplashScreen(
        seconds: 8,
        navigateAfterSeconds: HomePage()
        ,
        image : Image.asset(
            'assets/image/bako-motors.jpg'
        ),
        title: new Text(
          'BAKO ',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue[200],
      ),*/
      theme: lightModeTheme,
      darkTheme: darkModeTheme,
    routes: {
      '/méteo': (context) => MeteoPage(),
      '/register' : (context) => userRegister(),
      '/login' : (context) => UserLogin(),
      '/home' : (context) => HomePage(),
      '/users' : (context) => userPage(),
       '/cars' : (context) => carPage(),
      '/user'  : (context) => userDetails(),
       '/conn' : (context) => connectivity_home(),
      '/profile':(context) => profile_page()


    });
}}


