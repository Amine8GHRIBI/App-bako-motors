import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/data/CarEntity.dart';
import 'package:mini_project/ui/pages/bewireless/bako_data.dart';
import 'package:provider/provider.dart';

import '../../../../DataBase/user_database.dart';
import '../../../../data/userEntity.dart';
import 'data_page.dart';

class bako_page extends StatelessWidget {
  UserDatabase database;
  User user;
  Car car;
  ThemeData theme;
  String name;

  bako_page({Key? key, required this.database ,required this.user, required this.car, required this.theme, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : MultiProvider(
        providers: [
        ChangeNotifierProvider(
        create: (context) => bakodata(),
        builder: (context, child){
          if(name == "dash"){
            return DataPage(user: this.user, database: this.database, car : this.car , theme: this.theme, name: 'dash',);
          }
          else {
            return DataPage(user: this.user, database: this.database, car : this.car , theme: this.theme, name: 'maint',);
          }
        },
      )
    ],
      ),
    );
  }
}
