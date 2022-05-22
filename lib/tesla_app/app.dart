
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:hexcolor/hexcolor.dart';

import '../DataBase/user_database.dart';
import '../data/CarEntity.dart';
import '../data/userEntity.dart';
import '../ui/pages/Loging_screen.dart';
import '../ui/pages/setting_screen.dart';
import 'configs/colors.dart';
import 'screens/base_screen.dart';

class TeslaApp extends StatelessWidget {
  late UserDatabase database;
  late User user;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user = routes["user"];

   /* return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        //primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 101,101,101)),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      home: BaseScreen(database: this.database,user: this.user),
    );*/

    return AdaptiveTheme(

           light: ThemeData(
           cardTheme: CardTheme(
               color: kCardColo2
           ),
        //  scaffoldBackgroundColor: Colors.red,
           buttonColor: PrimaryColorlight ,
           primaryColor :  PrimaryColorlight,
           accentColor: HexColor("#175989"),
           bottomAppBarColor: kBottomAppBarColorlight,
           cardColor: kCardColor,
           indicatorColor: CourbeColorlight,
           secondaryHeaderColor: kSecondaryColorlight,

           //secondaryHeaderColor: Colors.grey.shade200 ,
    //shadowColor : Colors.grey,
          primarySwatch: Colors.blue,
             highlightColor : progressColorlight,
             dialogBackgroundColor : kProgressBackGroundColorlight,
   // iconTheme: IconThemeData(color: Color.fromARGB(255, 101,101,101)),
           iconTheme: IconThemeData(color: kPrimaryColorlight ),

           textTheme: const TextTheme(
             headline1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             bodyText1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             headline2: TextStyle( fontSize: 50,fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: kPrimaryColorlight),

             //bodyText2: TextStyle( fontSize: 30,fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             headline4: TextStyle( color: kPrimaryColorlight, fontWeight: FontWeight.w200),
             headline5: TextStyle(fontSize: 40, color: kPrimaryColorlight, fontWeight: FontWeight.w300),

           ),

         ),

    dark: ThemeData(
      cardColor: kCardColordark,
      cardTheme: CardTheme(
        color: kCardColordark2
      ),

      primaryColor :  PrimaryColordark,
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      accentColor: Colors.white,
      buttonColor:PrimaryColordark ,
      bottomAppBarColor: kBottomAppBarColordark,
      indicatorColor : CourbeColordark,
      secondaryHeaderColor: kSecondaryColordark,


      highlightColor : progressColordark,
      dialogBackgroundColor : kProgressBackGroundColordark,
      iconTheme: IconThemeData(color: kPrimaryColorDark ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline2: TextStyle( fontSize: 50,fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline3: TextStyle( fontSize: 30,fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline4: TextStyle( color: kPrimaryColorDark, fontWeight: FontWeight.w200),
        headline5: TextStyle(fontSize: 40, color: kPrimaryColorDark, fontWeight: FontWeight.w300),

        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color:kPrimaryColorDark),
      ),
    ),
    initial: AdaptiveThemeMode.light,
    builder: (theme, darkTheme) => MaterialApp(

    debugShowCheckedModeBanner: false,
    theme: theme,
    darkTheme: darkTheme,
        home: BaseScreen(database: this.database,user: this.user , car: Car(name: "a", model: "a", year: "a", license_Plate: "a", initial_mileage: "a") ),
        routes: {
          '/setting' : (context)=> SettingsScreen(),
          '/base' : (context) => BaseScreen(database: this.database,user: this.user , car: Car(name: "a", model: "a", year: "a", license_Plate: "a", initial_mileage: "a")),
        },
    // initialRoute: '/base',
    ),
    );
  }
}
