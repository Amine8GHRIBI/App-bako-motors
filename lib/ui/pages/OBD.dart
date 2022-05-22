import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../data/model.dart';
import '../widget/car-obd-widget.dart';

class obd extends StatefulWidget {
  const obd({Key? key}) : super(key: key);

  @override
  State<obd> createState() => _obdState();
}


class _obdState extends State<obd> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_dbref = FirebaseDatabase.instance.reference();

  }

  Future<void> useradd() async {

    FirebaseFirestore.instance.collection("Users")
        .doc("firstuser")
        .collection("Chauffeurs")
        .add({"petName": "red", "petType": "fish", "petAge": 1});

    return ;
  }


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
                  onPressed: () =>
                      context.read<ObdReader>().startOBD(),
                //context.read<ObdReader>().increment(),
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
                    context.watch<ObdReader>().obdData['$index'][1]
                );
              }),
            )));
  }

}
