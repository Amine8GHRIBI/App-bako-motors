import 'package:flutter/material.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/OBDParametres.dart';
import 'package:mini_project/ui/widget/speedo-widget.dart';
import 'package:provider/provider.dart';

import '../../data/model.dart';
import '../../data/userEntity.dart';
import '../../tesla_app/screens/home_screen.dart';
import '../widget/car-obd-widget.dart';



class obd_home extends StatefulWidget {
  UserDatabase database;
  User user;
   obd_home({Key? key ,required this.database ,required this.user}) : super(key: key);

  @override
  State<obd_home> createState() => _obd_homeState();
}


class _obd_homeState extends State<obd_home> {

  List<OBD> obds = [];
  List<OBD> OBDSS =[];

  @override
  void initState()  {

    super.initState();
    Future.delayed(Duration.zero,() {
      setState(() async {
        /*final routes =
        ModalRoute
            .of(context)
            ?.settings
            .arguments as Map<String, dynamic>;
        database = routes["database"];
        user = routes["user"];*/
        OBDSS = await this.retrieveOBD(this.widget.database);
       await this.addOBD(this.widget.database);
        debugPrint("obd diagno last " + OBDSS.last.speed.toString());
        },
      );
    },
    );

  }

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
      obds =await this.widget.database.obdDAO.retrieveAllOBD();
      debugPrint("obd diagno " + obds.length.toString());
      setState(() {});

      return obds;

  }

  List<int> ob =[];
  Future<List<int>> addOBD(UserDatabase db) async {
   // int i = context.read<ObdReader>().obdData.length;
    //rMap<dynamic, dynamic> ii = context.watch<ObdReader>().obdData;

    OBD obddtat= OBD( speed: "180", rpm: "60", CoolantTemperature: "45", ModuleVoltage: "10", date_debut: '22/04/2022', car_id: 1, date_fin: '22/04/2022');
      List<int> obdsaved = await this.widget.database.obdDAO.insertOBD([obddtat]);

      for (int idsaved in obdsaved) {
        ob.add(idsaved);
      }
   // debugPrint("obd diagno " + ob.length.toString());
    setState(() {});
    return obdsaved;
  }

  Future<List<int>> addOBDst(UserDatabase db ,Map<dynamic, dynamic> obdwatch ) async {
    List<int> ob =[];
    obdwatch.forEach((k, v) async {
      OBD obddtat= OBD( speed: v[0], rpm: v[1], CoolantTemperature: v[2], ModuleVoltage: v[3], date_debut: '05/04/2022', car_id: 1, date_fin: '06/04/2022');
      List<int> obdsaved = await this.widget.database.obdDAO.insertOBD([obddtat]);
      for (int idsaved in obdsaved) {
        ob.add(idsaved);
      }
    });
    return ob;
  }

  @override
  Widget build(BuildContext context) {

    bool start = false;
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
              title:  Text('OBD READER' + OBDSS.length.toString()),
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
                    Get.to( HomeScreen(database: this.widget.database ,user: this.widget.user) );}
                ),
              ],
            ),
            body :
           // buildspeedo()
          GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        children: List.generate(6, (index) {
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
