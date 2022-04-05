import 'package:flutter/material.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/OBDParametres.dart';
import 'package:mini_project/ui/widget/speedo-widget.dart';
import 'package:provider/provider.dart';

import '../../data/model.dart';
import '../widget/car-obd-widget.dart';



class obd_home extends StatefulWidget {
  const obd_home({Key? key}) : super(key: key);

  @override
  State<obd_home> createState() => _obd_homeState();
}


class _obd_homeState extends State<obd_home> {

  late UserDatabase database;

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      this.database = value;
      //await this.addOBD(database);
      await this.retrieveOBD();
      debugPrint("speedd" + OBDS.length.toString());
     // await this.addsUsers(this.database);
      // await this.add(this.database);
     // debugPrint( "users" + retrieveUsers().toString());
      setState(() {});
    });
  }

   List<OBD> OBDS = [];

  Future<List<OBD>> retrieveOBD() async {
      OBDS =await this.database.obdDAO.retrieveAllOBD();
    return OBDS;
  }

  Future<List<int>> addOBD(UserDatabase db) async {
   // int i = context.read<ObdReader>().obdData.length;
    //rMap<dynamic, dynamic> ii = context.watch<ObdReader>().obdData;
    List<int> ob =[];

      OBD obddtat= OBD( speed: "15", rpm: "30", CoolantTemperature: "12", ModuleVoltage: "50", date_debut: '29/03/2022', car_id: 1, date_fin: '30/03/2022');
      List<int> obdsaved = await database.obdDAO.insertOBD([obddtat]);
      for (int idsaved in obdsaved) {
        ob.add(idsaved);
      }

    return obdsaved;

  }

  Future<List<int>> addOBDst(UserDatabase db ,Map<dynamic, dynamic> obdwatch ) async {
    List<int> ob =[];
    obdwatch.forEach((k, v) async {
      OBD obddtat= OBD( speed: v[0], rpm: v[1], CoolantTemperature: v[2], ModuleVoltage: v[3], date_debut: '05/04/2022', car_id: 1, date_fin: '06/04/2022');
      List<int> obdsaved = await database.obdDAO.insertOBD([obddtat]);
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
              title: const Text('OBD READER'),
              actions: [
                IconButton(
                  tooltip: 'connect OBD',
                  icon: const Icon(
                    Icons.bluetooth,
                  ),
                  onPressed: () => {
                    context.read<ObdReader>().startOBD(),
                    //context.read<ObdReader>().increment(),
                    print(retrieveOBD().toString()),
                    start = true
                   }
                ),
                IconButton(
                  tooltip: 'Refresh OBD Data',
                  icon: const Icon(
                    Icons.refresh,
                  ),
                  onPressed: () => context.read<ObdReader>().increment(),
                ),
                IconButton(
                  tooltip: 'starterAppTooltipSearch',
                  icon: const Icon(
                    Icons.bluetooth_disabled,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body :
                //buildspeedo()
          GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        children: List.generate(6, (index) {
          while(start) {
             context.read<ObdReader>().increment();
             addOBDst(database,context.watch<ObdReader>().obdData);

             return buildCard(context.watch<ObdReader>().obdData['$index'][0],
                 context.watch<ObdReader>().obdData['$index'][1]);
           }
           return buildCard(context.watch<ObdReader>().obdData['$index'][0],
               context.watch<ObdReader>().obdData['$index'][1]);
        }),
    ),

        ),);
  }
}
