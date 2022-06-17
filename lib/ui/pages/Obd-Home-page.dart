import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/OBDParametres.dart';
import 'package:provider/provider.dart';

import '../../data/model.dart';
import '../../data/userEntity.dart';
import '../widget/car-obd-widget.dart';



class obd_home extends StatefulWidget {
  UserDatabase database;
  User user;
   obd_home({Key? key ,required this.database ,required this.user}) : super(key: key);

  @override
  State<obd_home> createState() => _obd_homeState();
}


class _obd_homeState extends State<obd_home> with WidgetsBindingObserver {

  List<OBD> obds = [];
  List<OBD> OBDSS =[];
  late Timer timer;


  @override
  void initState()  {
   // timer = Timer.periodic( Duration(seconds: 1), (Timer t) =>addOBDst(this.widget.database));

    super.initState();
    Future.delayed(Duration.zero,() async{
      //await this.addOBDst(this.widget.database);
      await getmaxspeed(widget.database );
      await getmaxkilometrage(widget.database);
      OBDSS = await retrieveOBD(widget.database);

      setState(() async {

        debugPrint("obd diagno last " + OBDSS.last.speed.toString());
        },
      );
    },
    );

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
      obds =await widget.database.obdDAO.retrieveAllOBD();
      debugPrint("obd diagno " + obds.length.toString());
      setState(() {});
      return obds;
  }

  List<int> ob =[];
  Future<List<int>> addOBD(UserDatabase db) async {
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formattertime = DateFormat('HH:mm:ss');

    final String formatteddate = formatterdate.format(now);
    final String formattedtime = formattertime.format(now);

    print(formatteddate); // something like 2013-04-20
   // int i = context.read<ObdReader>().obdData.length;
    // context.watch<ObdReader>().increment();

    OBD obddtat= OBD( speed: "19", rpm: "50", CoolantTemperature: "12.1", ModuleVoltage: "12", date:formatteddate , car_id: 1, time: formattedtime , DistanceMILOn: '5', engineload: '', troublecodes: '', tripRecords: '');
      List<int> obdsaved = await widget.database.obdDAO.insertOBD([obddtat]);
      for (int idsaved in obdsaved) {
        ob.add(idsaved);
      }
    //debugPrint("obd diagno " + );
    setState(() {});
    // debugPrint("obd diagno " + ob.length.toString());
    return obdsaved;
  }

  Future<List<int>> addOBDst(UserDatabase db ) async {
    //context.watch<ObdReader>().increment();
    List<int> ob =[];
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formattertime = DateFormat('HH:mm:ss');

    final String formatteddate = formatterdate.format(now);
    final String formattedtime = formattertime.format(now);
    //final _ObdReader = Provider.of<ObdReader>(context, listen: false);

      OBD obddtat= OBD(
          speed: "70",
          rpm: context.read<ObdReader>().obdData['2'][1].toString(),
          CoolantTemperature: context.read<ObdReader>().obdData['1'][1].toString(),
          ModuleVoltage: context.read<ObdReader>().obdData['4'][1].toString(), date: formatteddate, car_id: 1, time: formattedtime,
          DistanceMILOn: "", troublecodes: context.read<ObdReader>().obdData['7'][1].toString(),
          tripRecords: context.read<ObdReader>().obdData['6'][1].toString(), engineload: context.read<ObdReader>().obdData['3'][1].toString()
      );
    List<int> obdsaved = await widget.database.obdDAO.insertOBD([obddtat]);

    return ob;
  }
  List<OBD> obdskilom =[];
  List<OBD> obdstemp = [];
  //late UserDatabase database;
  //late User user;
  int max = 0;
  int maxkilo =0;
  String maxx = "";
  Future<int> getmaxspeed(UserDatabase db) async {
    obds = await widget.database.obdDAO.retrieveAllOBD();
    for (OBD obd  in obds) {
      // maxx = obd.speed;
      if(int.tryParse(obd.speed) != null) {
        if (int.parse(obd.speed) > max) {
          max = int.parse(obd.speed);
        }
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
      setState(()  {},);
    }


    return maxkilo ;
  }
  @override
  Widget build(BuildContext context) {

    bool start = false;
    return MaterialApp(

        home: Scaffold(
          appBar: AppBar(

              title:  Text( max.toString() + obds.length.toString()),
              actions: [

                IconButton(
                  tooltip: 'connect OBD ' ,
                  icon: const Icon(
                    Icons.bluetooth,
                  ),
                  onPressed: () => context.read<ObdReader>().startOBD(),
                    //context.read<ObdReader>().increment(),
                    //print(retrieveOBD().toString()),
                    //rstart = true

                ),
                IconButton(
                  tooltip: 'Refresh OBD Data',
                  icon: const Icon(
                    Icons.refresh,
                  ),
                 onPressed: () => context.read<ObdReader>().increment()


    ),
                IconButton(
                  tooltip: 'starterAppTooltipSearch',
                  icon: const Icon(
                    Icons.bluetooth_disabled,
                  ),
                  onPressed: () {
                   // Get.to( HomeScreen(database: this.widget.database ,user: this.widget.user) );
                  }
                ),
              ],
            ),
            body :
           // buildspeedo()
          GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        children: List.generate(8, (index) {
         /* while(start) {
             context.read<ObdReader>().increment();
             addOBDst(database,context.watch<ObdReader>().obdData);

             return buildCard(
                 context.watch<ObdReader>().obdData['$index'][0],
                 context.watch<ObdReader>().obdData['$index'][1]
             );
           }*/
          return buildCard(
              context.watch<ObdReader>().obdData['$index'][0],
              context.watch<ObdReader>().obdData['$index'][1]);
        }),
          )));
  }
}
