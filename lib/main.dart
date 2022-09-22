
import
'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mini_project/data/stathome.dart';
import 'package:mini_project/tesla_app/app.dart';
import 'package:mini_project/ui/pages/Login.dart';
import 'package:mini_project/ui/pages/Loging_screen.dart';
import 'package:mini_project/ui/pages/Obd-Home-page.dart';
import 'package:mini_project/ui/pages/SignIn.dart';
import 'package:mini_project/ui/pages/SpeedometerContainer.dart';
import 'package:mini_project/ui/pages/bewireless/bako_data.dart';
import 'package:mini_project/ui/pages/connectivity.dart';
import 'package:mini_project/ui/pages/profile_page.dart';

import 'package:splashscreen/splashscreen.dart';

import 'DataBase/user_database.dart';
import 'data/model.dart';

import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';

//import 'package:awesome_notifications/awesome_notifications.dart';



Future <void> main() async {
WidgetsFlutterBinding.ensureInitialized();
 // FirebaseApp firebaseApp = await Firebase.initializeApp();
const _themeColor = Colors.lightGreen;
WidgetsFlutterBinding.ensureInitialized();

runApp( MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => bakodata()),
  ],
  child:  const MyApp()),);
  /*FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: "AIzaSyAkVwF1hIKEo-kcZI50pBHSnsMUrQo9s3c",
      authDomain: "datahub-bako.firebaseapp.com",
      databaseURL: "https://datahub-bako-default-rtdb.firebaseio.com",
      projectId: "datahub-bako",
      storageBucket: "datahub-bako.appspot.com",
      messagingSenderId: "872535802080",
      appId: "1:872535802080:web:9ae57c6577837513fed085",
      measurementId: "G-GM14MKKNPE",
  ),
  );*/
  //WidgetsFlutterBinding.ensureInitialized();
/*AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true
);*/


  /*runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ObdReader()),
      ],
      child: const MyApp(),),);*/
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
      database = value;
      setState(() {});
    });
  }
    @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
        debugShowCheckedModeBanner: false,
        title: 'My bako app',
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
        //home : obd(),

        //navigatorObservers: [TransitionRouteObserver()],
        home:  SplashScreen(
        seconds: 8,
        navigateAfterSeconds: const LoginScreen()
        ,
            loaderColor : Colors.white,
     /* image : Image.asset(
        'assets/image/logo.png',
      filterQuality: FilterQuality.high,
      height: 30,
      width: 30,),*/
        //backgroundColor: Colors.indigo.shade700,
         imageBackground: const AssetImage("assets/newbako/newscreen.png")
      ),

        routes: {
          '/register' : (context) => const userRegister(),
          '/login' : (context) => const UserLogin(),
          '/conn' : (context) => const connectivity_home(),

          '/log' : (context) => const LoginScreen(),
          //'/log' : (context) => DashboardScreen(),
          //'/dashboard' : (context) => DashboardScreen(),
          '/kilo' : (context) => const kilometrage_data(),
          //'/bleu' : (context) => obd_home(daaa),
          //'/dash' : (context) => dashboard(),
          '/Speed' : (context) => const SpeedometerContainer(),
         // '/cnxobd' : (context) => connexion(),
          '/app' : (context) => TeslaApp(),
          //'/slider' : (context) => slider_connexion(),
        },
      // initialRoute: '/log',
    );
    }
}



