
import 'package:flutter/material.dart';

import '../DataBase/user_database.dart';
import '../data/userEntity.dart';
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

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 101,101,101)),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: BaseScreen(database: this.database,user: this.user),
    );
  }
}
