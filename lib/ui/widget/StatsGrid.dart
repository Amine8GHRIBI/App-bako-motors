import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';

class StatsGrid extends StatefulWidget {
  UserDatabase database;
  User user;
  Car car;

  StatsGrid({Key? key,required this.database, required this.user ,required this.car}) : super(key: key);

  @override
  State<StatsGrid> createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  List<OBD> obds = [];
  List<OBD> obdss = [];
  List<OBD> obdskilom = [];
  List<OBD> obdstemp = [];

  //late UserDatabase database;
  //late User user;
  int max = 0;
  double maxkilo = 0;
  double moytemp = 0.0;
  int conduiteheure = 0;
  int conduiteminute = 0;
  int kilometragetoday = 0;
  String conduitetoday = "";

 
  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds = await db.obdDAO.retrieveAllOBD();
    //debugPrint("obd diagno " + obds.length.toString());
    setState(() {},);
    return obds;
  }

  Future<int> getmaxspeed(UserDatabase db) async {
    obdss = await retrieveOBD(db);
    for (OBD obd in obdss) {
      if(int.tryParse(obd.speed) != null) {
        if (int.parse(obd.speed) > max) {
          max = int.parse(obd.speed);
          moytemp +=  (int.parse(obd.speed)/ obdss.length).roundToDouble();
        }

      }
    }
    return max;
  }

  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {} else
    if (connectivityResult == ConnectivityResult.mobile) {
      await useradd();
      debugPrint("data send ...");
      //await deletedatafromlocal(this.widget.database, this.widget.car.id!);
      //debugPrint("data deleted ...");

    }
  }

  Future<void> deletedatafromlocal(UserDatabase db, int idcar) async {
    OBD? Oobddeleted = await db.obdDAO.deleteOBDbycar(idcar);
  }

  Future<List<OBD>> retrieveKiloConBydate(UserDatabase db, String date) async {
    obdsbydate =
    await db.obdDAO.retrieveLastOBDByDate(date, widget.car.id!.toInt());
    conduiteheure = (int.parse(obds.last.time.substring(0, 2))) -
        (int.parse(obds.first.time.substring(0, 2)));
    conduiteminute = int.parse(obds.last.time.substring(3, 5)) -
        int.parse(obds.first.time.substring(3, 5));
    conduitetoday = conduiteheure.toString() + ':' + "0";

    for (OBD o in obdsbydate) {
      kilometragetoday += int.parse(o.DistanceMILOn);
    }
    debugPrint("obds by date  " + obdsbydate.length.toString());
    setState(() {});
    return obds;
  }

  Future<double> getmaxkilometrage(UserDatabase db) async {
    obdskilom = await retrieveOBD(db);
    for (OBD obd in obdskilom) {
      if(double.tryParse(obd.DistanceMILOn) != null) {
        if (double.parse(obd.DistanceMILOn) > maxkilo) {
          maxkilo = double.parse(obd.DistanceMILOn);
        }
      }
      setState(() {});
    }
    return maxkilo;
  }

  Future<double> getmoytemperature(UserDatabase db) async {
    double totaltemp = 0;
    obdstemp = await retrieveOBD(db);
    for (OBD obd in obdstemp) {
      totaltemp += double.parse(obd.CoolantTemperature);
    }
    moytemp = (totaltemp / obdstemp.length).roundToDouble();
    setState((){},);

    return moytemp;
  }


  Future<void> useradd() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat formattertime = DateFormat('HH:mm:ss');

    final String formatteddate = formatter.format(now);
    final String formattedtime = formattertime.format(now);
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => context.read<ObdReader>().increment());
    debugPrint("use mail " + widget.user.email.toString());
    FirebaseFirestore.instance.collection("Users")
        .doc("firstuser")
        .collection("Chauffeurs").doc(widget.user.email.toString())
        .set({ "userName": widget.user.username.toString(),
      "Name": widget.user.name.toString(),
      "SurName": widget.user.surName.toString(),
      "email": widget.user.email.toString(),
      "phoneNumber": widget.user.phoneNumber.toString()
      , "adresse": widget.user.adresse.toString()
      , "birthday": widget.user.birthday.toString()}).then((value) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc("firstuser")
          .collection("Chauffeurs")
          .doc(widget.user.email.toString())
          .collection("Cars")
          .doc(widget.car.license_Plate.toString())
          .set({
        "Name": widget.car.name.toString(),
        "modele": widget.car.model.toString(),
        "Year": widget.car.year.toString(),
        "intial mileage": widget.car.initial_mileage.toString(),
        "license_plat": widget.car.license_Plate.toString()
      })
          .then((value) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc("firstuser")
            .collection("Chauffeurs")
            .doc(widget.user.email.toString())
            .collection("Cars")
            .doc(widget.car.license_Plate.toString())
            .collection("statistique")
            .doc(formatteddate.toString())
            .set({
          "date": formatteddate.toString(),
          "time": formattedtime.toString(),
          "max_kilometrage": maxkilo.toString(),
          "Max_vitesse": max.toString(),
          "Moy témperature": moytemp.toString(),
          "Kilometrage_today": kilometragetoday.toString(),
          "conduite_today": conduitetoday.toString(),
        });
      });
      return;
    });
  }

  List<OBD> obdsbydate = [];

  Future<List<OBD>> retrieveOBDBydate(UserDatabase db, String date) async {
    obdsbydate =
    await db.obdDAO.retrieveLastOBDByDate(date, widget.car.id!.toInt());
    setState(() {});
    return obds;
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // await retrieveOBD(this.widget.database);
      await getmaxspeed(widget.database);
      await getmaxkilometrage(widget.database);
      await getmoytemperature(widget.database);


      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateFormat formattertime = DateFormat('HH:mm:ss');

      final String formatteddate = formatter.format(now);
      final String formattedtime = formatter.format(now);

      await retrieveKiloConBydate(widget.database, formatteddate);


      await retrieveOBDBydate(widget.database, formatteddate);

      //timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getmaxspeed(this.widget.database));

      await initConnectivity();
      setState(() {
        //database = this.widget.database;
        //user = this.widget.user;
        //obdss = await retrieveOBD(this.widget.database);
      },);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.30,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Max speed' ,
                    max.toString() + ' KM', Colors.orange),
                _buildStatCard(
                    'Max kilometrage', maxkilo.toString() + ' KM', Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                    'Moy témperature', moytemp.toString() + ' °', Colors.green),
                _buildStatCard('Moy kilométrage', ' 319km', Colors.lightBlue),
                _buildStatCard('Moy temps de conduie', 'N/A', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}