import 'package:flutter/material.dart';

import '../../DataBase/user_database.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';

class StatsGrid extends StatefulWidget {
  UserDatabase database;
  User user;


  StatsGrid({Key? key ,  required this.database, required this.user}) : super(key: key);

  @override
  State<StatsGrid> createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {

  List<OBD> obds = [];
  List<OBD> obdss= [];
  List<OBD> obdskilom =[];
  List<OBD> obdstemp = [];
  //late UserDatabase database;
  //late User user;
  int max = 0;
  int maxkilo=0;
  double moytemp=0.0;

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await db.obdDAO.retrieveAllOBD();
    //debugPrint("obd diagno " + obds.length.toString());
    setState(()  {},);
    return obds;
  }

  Future<int> getmaxspeed(UserDatabase db) async {
    obdss = await retrieveOBD(db);
    for (OBD obd  in obdss) {
      if (int. parse(obd.speed) > max ){
         max = int. parse(obd.speed);
      }
    }
    setState(()  {},);

    return max ;
  }

  Future<int> getmaxkilometrage(UserDatabase db) async {
    obdskilom = await retrieveOBD(db);
    for (OBD obd  in obdskilom) {
      if (int. parse(obd.DistanceMILOn) > maxkilo  ){
        debugPrint("kilom" + obd.DistanceMILOn.toString());
        maxkilo = int. parse(obd.DistanceMILOn);
      }
    }
    setState(()  {},);

    return maxkilo ;
  }

  Future<double> getmoytemperature(UserDatabase db) async{
    double totaltemp = 0;
    obdstemp = await retrieveOBD(db);

    for(OBD obd in obdstemp){
      totaltemp += double.parse(obd.CoolantTemperature);
    }
    moytemp = (totaltemp/obdstemp.length).roundToDouble();
    setState(()  {},);

    return moytemp;

  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getmaxspeed(this.widget.database);
      await getmaxkilometrage(this.widget.database);
      await getmoytemperature(this.widget.database);

      setState(()  {
        //database = this.widget.database;
        //user = this.widget.user;
        //obdss = await retrieveOBD(this.widget.database);
        debugPrint("moy temp " + moytemp.toString());
      },);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Max speed', max.toString() + ' KM', Colors.orange),
                _buildStatCard('Max kilometrage',maxkilo.toString() + ' KM' , Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Moy témperature', moytemp.toString() + ' °', Colors.green),
                _buildStatCard('Moy kilométrage',' 319km', Colors.lightBlue),
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
