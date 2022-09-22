import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/ui/pages/bewireless/bako_data.dart';
import 'package:mini_project/ui/widget/speedo-widget.dart';
import 'package:provider/provider.dart';

import '../../../../DataBase/user_database.dart';
import '../../../../data/CarEntity.dart';
import '../../../../data/userEntity.dart';
import '../../../../tesla_app/screens/diagnostic_screen.dart';
import '../../DashbordScreen.dart';
import '../../Obd-Home-page.dart';


class DataPage extends StatefulWidget {
  UserDatabase database;
  User user;
  Car car;
  ThemeData theme;
  String name;

  DataPage({Key? key,  required this.database ,required this.user, required this.car, required this.theme, required this.name}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Timer? timer;
  final GlobalKey<FormState> _dashkey = GlobalKey<FormState>();
  @override
  void initState() {
    // if(this.widget.car.id != null) {
    Future.delayed(Duration.zero, () async {
      //timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => context.read<ObdReader>().increment());

      timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) => context.read<bakodata>().fetchData );
    });
  }

  @override
  Widget build(BuildContext context) {
    //context.read<bakodata>().fetchData;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Center(
          child: Consumer<bakodata>(
            builder: (context, value, child) {
             // if(widget.name == "dash"){
            return  DashboardScreen(
                database: widget.database,
                user: widget.user,
                car: widget.car,
                key: _dashkey,
              );

            //    return  speedo( database: this.widget.database,map: value.map, car: this.widget.car, theme: this.widget.theme,);
             //  }
              },
          ),
              ),
      ),

    );
  }
}
