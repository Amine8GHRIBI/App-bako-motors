import 'package:flutter/material.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/OBDParametres.dart';
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
     // await this.addsUsers(this.database);
      // await this.addcar(this.database);
     // debugPrint( "users" + retrieveUsers().toString());
      setState(() {});
    });
  }
  /*
  Future<List<int>> addOBD(UserDatabase db){
    int i = context.read<ObdReader>().obdData.length;
    Map<dynamic, dynamic> ii = context.read<ObdReader>().obdData;
    List<int> ob = [];
   ii.forEach((k, v) async {
     OBD obddtat= OBD( speed: v[0], rpm: v[1], CoolantTemperature: v[2], ModuleVoltage: v[3], date_debut: '', car_id: 1, date_fin: '');
     ob.add(await database.obdDAO.insertOBD([obddtat])) ;
   });
  }

  }*/

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => context.read<ObdReader>().startOBD(),
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
            body: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              children: List.generate(6, (index) {
                return buildCard(
                    context.watch<ObdReader>().obdData['$index'][0],
                    context.watch<ObdReader>().obdData['$index'][1]);
              }),
            )));
  }
}
