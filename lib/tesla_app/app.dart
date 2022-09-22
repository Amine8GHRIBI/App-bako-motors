
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mini_project/ui/pages/Loging_screen.dart';
import 'package:provider/provider.dart';

import '../DataBase/user_database.dart';
import '../data/CarEntity.dart';
import '../data/userEntity.dart';
import '../ui/pages/bewireless/bako_data.dart';
import '../ui/pages/setting_screen.dart';
import 'configs/colors.dart';
import 'screens/base_screen.dart';

class TeslaApp extends StatelessWidget {
  late UserDatabase database;
  late User user;
  late Car car;

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
    car = routes["car"];

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
           cardTheme: const CardTheme(
               color: kCardColo2
           ) ,
           primaryColor :  PrimaryColorlight,
           bottomAppBarColor: kBottomAppBarColorlight,
           cardColor: kCardColor,
           indicatorColor: CourbeColorlight,
           secondaryHeaderColor: kSecondaryColorlight,
             highlightColor : progressColorlight,
             dialogBackgroundColor : kProgressBackGroundColorlight,
   // iconTheme: IconThemeData(color: Color.fromARGB(255, 101,101,101)),
           iconTheme: const IconThemeData(color: kPrimaryColorlight ),

           textTheme: const TextTheme(
             headline1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             bodyText1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             headline2: TextStyle( fontSize: 15,fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: kPrimaryColorlight),

             //bodyText2: TextStyle( fontSize: 30,fontWeight: FontWeight.bold , color: kPrimaryColorlight),
             headline4: TextStyle( color: kPrimaryColorlight, fontWeight: FontWeight.w200),
             headline5: TextStyle(fontSize: 40, color: kPrimaryColorlight, fontWeight: FontWeight.w300),

           ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(primary : PrimaryColorlight ,secondary: HexColor("#175989")),

         ),

    dark: ThemeData(
      cardColor: kCardColordark,
      cardTheme: const CardTheme(
        color: kCardColordark2
      ),

     // primaryColor :  PrimaryColordark,
      //brightness: Brightness.dark ,
      bottomAppBarColor: kBottomAppBarColordark,
      indicatorColor : CourbeColordark,
      secondaryHeaderColor: kSecondaryColordark,


      highlightColor : progressColordark,
      dialogBackgroundColor : kProgressBackGroundColordark,
      iconTheme: const IconThemeData(color: kPrimaryColorDark ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline2: TextStyle( fontSize: 10,fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline3: TextStyle( fontSize: 30,fontWeight: FontWeight.bold , color: kPrimaryColorDark),
        headline4: TextStyle( color: kPrimaryColorDark, fontWeight: FontWeight.w200),
        headline5: TextStyle(fontSize: 40, color: kPrimaryColorDark, fontWeight: FontWeight.w300),

        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color:kPrimaryColorDark),
      ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.white  ,primary :  PrimaryColordark,   brightness    : Brightness.dark ,
    ),
    ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: BaseScreen(database: database,user: user , car: car ),
        routes: {
          '/setting' : (context)=> const SettingsScreen(),
          '/base' : (context) => BaseScreen(database: database,user: user , car: car ),
        },
        // initialRoute: '/base',
      ),
    );
  }
}
