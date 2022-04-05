import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mini_project/data/stathome.dart';
import 'package:mini_project/ui/pages/Dashboard.dart';
import 'package:mini_project/ui/pages/DashbordScreen.dart';
import 'package:mini_project/ui/pages/Gallerie-page.dart';
import 'package:mini_project/ui/pages/Login.dart';
import 'package:mini_project/ui/pages/Loging_screen.dart';
import 'package:mini_project/ui/pages/Meteo-page.dart';
import 'package:mini_project/ui/pages/Home-page.dart';
import 'package:mini_project/ui/pages/Obd-Home-page.dart';
import 'package:mini_project/ui/pages/SignIn.dart';
import 'package:mini_project/ui/pages/SpeedometerContainer.dart';
import 'package:mini_project/ui/pages/TransitionRouteObserver.dart';
import 'package:mini_project/ui/pages/car_page.dart';
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
  late UserDatabase database;

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      this.database = value;

      setState(() {});
    });
  }
    @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      debugShowCheckedModeBanner: false,
      title: 'Car Rental App',

        theme: ThemeData(
          textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.orange),
          // fontFamily: 'SourceSansPro',
          textTheme: TextTheme(
            headline3: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 45.0,
              // fontWeight: FontWeight.w400,
              color: Colors.orange,
            ),
            button: const TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
              fontFamily: 'OpenSans',
            ),
            caption: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple[300],
            ),
            headline1: const TextStyle(fontFamily: 'Quicksand'),
            headline2: const TextStyle(fontFamily: 'Quicksand'),
            headline4: const TextStyle(fontFamily: 'Quicksand'),
            headline5: const TextStyle(fontFamily: 'NotoSans'),
            headline6: const TextStyle(fontFamily: 'NotoSans'),
            subtitle1: const TextStyle(fontFamily: 'NotoSans'),
            bodyText1: const TextStyle(fontFamily: 'NotoSans'),
            bodyText2: const TextStyle(fontFamily: 'NotoSans'),
            subtitle2: const TextStyle(fontFamily: 'NotoSans'),
            overline: const TextStyle(fontFamily: 'NotoSans'),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
              .copyWith(secondary: Colors.orange),
        ),
        //navigatorObservers: [TransitionRouteObserver()],
    /* home:  SplashScreen(
        seconds: 8,
        navigateAfterSeconds: LoginScreen()
        ,
     /* image : Image.asset(
        'assets/image/logo.png',
      filterQuality: FilterQuality.high,
      height: 30,
      width: 30,),*/


        //backgroundColor: Colors.indigo.shade700,
         imageBackground: AssetImage("assets/image/background.png")
      ),*/
        initialRoute: '/log',
    routes: {
      '/méteo': (context) => MeteoPage(),
      '/register' : (context) => userRegister(),
      '/login' : (context) => UserLogin(),
      '/home' : (context) => car_page(),
      '/users' : (context) => userPage(),
      '/cars' : (context) => carPage(),
      '/user'  : (context) => userDetails(),
      '/conn' : (context) => connectivity_home(),
      '/profile':(context) => profile_page(),
      '/log' : (context) => LoginScreen(),
      '/dashboard' : (context) => DashboardScreen(),
      '/kilo' : (context) => kilometrage_data(),
      '/bleu' : (context) => obd_home(),
      '/dash' : (context) => dashboard(),
      '/Speed' : (context) => SpeedometerContainer(),
    }
    );

}}


