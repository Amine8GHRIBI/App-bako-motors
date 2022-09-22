import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/OBDParametres.dart';
import 'package:mini_project/ui/pages/bewireless/bako_data.dart';
import 'package:provider/provider.dart';

import '../../data/model.dart';
import '../../data/userEntity.dart';
import '../widget/car-obd-widget.dart';



class obd_home extends StatefulWidget {

   obd_home({Key? key }) : super(key: key);

  @override
  State<obd_home> createState() => _obd_homeState();
}


class _obd_homeState extends State<obd_home> with WidgetsBindingObserver {

  List<OBD> obds = [];
  List<OBD> OBDSS =[];
  late Timer timer;

  List<String> params = ["temp_moteur" , "speed" , "rpm" , "batterie" , "coolant_temperature" , "kilometrage"];


  @override
  void initState()  {
   // timer = Timer.periodic( Duration(seconds: 1), (Timer t) =>addOBDst(this.widget.database));

    super.initState();
    Future.delayed(Duration.zero,() async{
      timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) => context.read<bakodata>().fetchData);
     // await this.addOBDst(this.widget.database);
      //await getmaxspeed(widget.database );
      //await getmaxkilometrage(widget.database);
      //OBDSS = await retrieveOBD(widget.database);

      setState(() async {

       // debugPrint("obd diagno last " + OBDSS.last.speed.toString());
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


  @override
  Widget build(BuildContext context) {
    double rpm;
    double vitesse;
    double moteur_temperature;
    Map<String, dynamic> someMap;
    if(context.watch<bakodata>().map['ID_10261022'].toString() == 'null' ){
      rpm = 0.0;
      vitesse = 0.0;
      moteur_temperature = 0.0;
      someMap = {
        '0':[ "temperature_moteur" , 0.0],
        '1':["temperature_controller", 0.0],
        '2':["rpm" , 0.0],
        '3':["vitesse", 0.0],
        '4':[ "odometre",0.0],
        '5':["tripmetre", 0.0 ],
        '6':["batterie", 0.0],
      };;}
      else {
      someMap = {

        '0':[ "temperature_moteur" , (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(2,4),radix: 16)).toString()))],
        '1':["temperature_controller", (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(0,2),radix: 16)).toString()))],
        '2':["rpm" , (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(6,8) + context.watch<bakodata>().map['ID_10261022'].toString().substring(4,6)),radix: 16)).toString()))],
        '3':["vitesse", (double.parse((int.parse(context.watch<bakodata>().map['ID_1026105A'].toString().substring(10,12),radix: 16)).toString()))],
        '4':[ "odometre",(double.parse((int.parse((context.watch<bakodata>().map['ID_1026105A'].toString().substring(0,2) + context.watch<bakodata>().map['ID_1026105A'].toString().substring(0,2)) ,radix: 16)).toString()))],
        '5':["tripmetre", (double.parse((int.parse((context.watch<bakodata>().map['ID_1026105A'].toString().substring(8,10) + context.watch<bakodata>().map['ID_1026105A'].toString().substring(6,8)),radix: 16)).toString())) ],
        '6':["batterie", (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(10,12) + context.watch<bakodata>().map['ID_10261022'].toString().substring(8,10)),radix: 16)*0.1).toString()))],
      };
    }
    bool start = false;
    return MaterialApp(

        home: Scaffold(
          appBar: AppBar(

              title: Text(context.watch<bakodata>().map['ID_10261022'].toString().substring(10,12) + context.watch<bakodata>().map['ID_10261022'].toString().substring(8,10) + "tt" + context.watch<bakodata>().map['ID_1026105A'].toString().substring(0,2)),
              actions: [

                IconButton(
                  tooltip: 'connect OBD ' ,
                  icon: const Icon(
                    Icons.bluetooth,
                  ),
                  onPressed: () => context.read<bakodata>().fetchData,
                    //context.read<ObdReader>().increment(),
                    //print(retrieveOBD().toString()),
                    //rstart = true

                ),
                IconButton(
                  tooltip: 'Refresh OBD Data',
                  icon: const Icon(
                    Icons.refresh,
                  ),
                 onPressed: () => context.read<bakodata>().fetchData,


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
        children: List.generate(7, (index) {
         /* while(start) {
             context.read<ObdReader>().increment();
             addOBDst(database,context.watch<ObdReader>().obdData);

             return buildCard(
                 context.watch<ObdReader>().obdData['$index'][0],
                 context.watch<ObdReader>().obdData['$index'][1]
             );
           }*/
          return buildCard(
              someMap['$index'][0],
              someMap['$index'][1].toString()
          );
        }),
          )));
  }
}
