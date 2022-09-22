import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';


import '../../data/model.dart';
import '../pages/bewireless/bako_data.dart';

class speedo extends StatefulWidget {
  ThemeData theme;
  UserDatabase database;
  Car car;

  //final Map<String,dynamic> map;


  speedo({Key? key , required this.theme, required this.database ,required this.car}) : super(key: key);

  @override
  State<speedo> createState() => _speedoState();
}

class _speedoState extends State<speedo> {
  double velocity = 0;
  double highestVelocity = 0.0;


  List<OBD> obds = [];
  Timer? timer;
  List<OBD> DD = [];
  late Uint8List input;
  ByteData? byteData;
  double s = 0.0;
  Future<bakodata>? _future;

  @override
  void initState() {
   // if(this.widget.car.id != null) {
    Future.delayed(Duration.zero, () async {
     // await addOBDst( this.widget.database);
     // await retrieveOBD( this.widget.database);
      //
    timer = Timer.periodic(Duration(microseconds: 1), (Timer t) => context.read<bakodata>().fetchData);
    timer = Timer.periodic(Duration(microseconds: 1), (Timer t) => getData());

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) => addOBDst(widget.database));
    timer = Timer.periodic(const Duration(seconds: 6), (Timer t) => retrieveOBD(widget.database));
    });

    setState(()  {});

    super.initState();

      setState (() {});

  }

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await widget.database.obdDAO.retrieveAllOBD();
    debugPrint("obd diagno " + obds.last.speed.toString());
    setState(() {});
    return obds;
  }

  Future<List<int>> addOBDst(UserDatabase db ) async {
    //double DistanceMILO =0.0;
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formattertime = DateFormat('HH:mm:ss');

    final String formatteddate = formatterdate.format(now);
    final String formattedtime = formattertime.format(now);

    List<int> ob =[];
   /* OBD obddtat= OBD(
      speed:"40.5",
      rpm:"1000",
      CoolantTemperature: "25",
      ModuleVoltage: "48",
      date: now.toString(),
      car_id: this.widget.car.id!,
      time: formattedtime,
      DistanceMILOn:"25",
      troublecodes: "",
      tripRecords:"",
      engineload: 12.1.toString(),
    );*/
    OBD obddtat= OBD(
        speed:(double.parse((int.parse(context.watch<bakodata>().map['ID_1026105A'].toString().substring(10,12),radix: 16)).toString())).toString(),
        rpm:(double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(6,8) + context.watch<bakodata>().map['ID_10261022'].toString().substring(4,6)),radix: 16)).toString())).toString(),
        CoolantTemperature: (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(2,4),radix: 16)).toString())).toString(),
        ModuleVoltage: (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(10,12) + context.watch<bakodata>().map['ID_10261022'].toString().substring(8,10)),radix: 16)*0.1).toString())).toString(),
        date: now.toString(),
        car_id: this.widget.car.id!,
        time: formattedtime,
        DistanceMILOn:(double.parse((int.parse((context.watch<bakodata>().map['ID_1026105A'].toString().substring(8,10) + context.watch<bakodata>().map['ID_1026105A'].toString().substring(6,8)),radix: 16)).toString())).toString(),
        troublecodes: "",
        tripRecords:"",
        engineload: 12.1.toString(),
    );

    List<int> obdsaved = await widget.database.obdDAO.insertOBD([obddtat]);
    debugPrint("ib last" +obddtat.speed.toString());
    setState (() {});
    return ob;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getGauge({bool isRadialGauge = true}) {
    if (isRadialGauge) {
      return _getRadialGauge();
    } else {
      return _getLinearGauge();
    }
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
        title: const GaugeTitle(
            text: 'Speedometer' ,
            textStyle:
            TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 50,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 50,
                endValue: 100,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 100,
                endValue: 150,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10)
          ], pointers: const <GaugePointer>[
            NeedlePointer(value: 90)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: const Text('90.0',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }

  Widget _getLinearGauge() {
    return Container(
      child: SfLinearGauge(
          minimum: 0.0,
          maximum: 100.0,
          orientation: LinearGaugeOrientation.horizontal,
          majorTickStyle: const LinearTickStyle(length: 20),
          axisLabelStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
          axisTrackStyle: const LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: LinearEdgeStyle.bothFlat,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: const EdgeInsets.all(10),
    );
  }

  late double rpm;
  late double vitesse;
  late double moteur_temperature;

  Future<void> getData() async {

    if(context.watch<bakodata>().map['ID_10261022'].toString() == 'null' ){
      rpm = 0.0;
      vitesse = 0.0;
      moteur_temperature = 0.0;
      ;
    }else {
      rpm = (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(6,8) + context.watch<bakodata>().map['ID_10261022'].toString().substring(4,6)),radix: 16)).toString()));
      vitesse = (double.parse((int.parse(context.watch<bakodata>().map['ID_1026105A'].toString().substring(10,12),radix: 16)).toString()));
      moteur_temperature = (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(2,4),radix: 16)).toString()));
      //d = double.parse((context.watch<bakodata>().map['time'].toString().substring(6,8)).toString());
      //d2 = double.parse((context.watch<bakodata>().map['time'].toString().substring(3,5)).toString());
    }

  }

  @override
  Widget build(BuildContext context){
    double d ;
    double d2;
    double rpm;
    double vitesse;
    double moteur_temperature;
    if(context.watch<bakodata>().map['ID_10261022'].toString() == 'null' || (this.widget.car.name == "Aucun")){
      rpm = 0.0;
      vitesse = 0.0;
      moteur_temperature = 0.0;
      d = 0.0;
      d2= 0.0;
    }else {
      rpm = (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(6,8) + context.watch<bakodata>().map['ID_10261022'].toString().substring(4,6)),radix: 16)).toString()));
      vitesse = (double.parse((int.parse(context.watch<bakodata>().map['ID_1026105A'].toString().substring(10,12),radix: 16)).toString()));
      moteur_temperature = (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(2,4),radix: 16)).toString()));
      //d = double.parse((context.watch<bakodata>().map['time'].toString().substring(6,8)).toString());
      //d2 = double.parse((context.watch<bakodata>().map['time'].toString().substring(3,5)).toString());
    }
    return Directionality(
      textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          appBar:
          AppBar(iconTheme : IconThemeData(
              color: widget.theme.iconTheme.color,
          ),
            title: Text("Dashboard"/* obds.length.toString()*/ ,
              style: TextStyle(color : widget.theme.primaryColor),),
                 backgroundColor: widget.theme.bottomAppBarColor),
          body:
          Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Speedometer(
              size: 100,
              minValue: -10,
              maxValue: 100,
              currentValue:moteur_temperature,
              warningValue: 40,
              backgroundColor: widget.theme.cardColor,
              meterColor: widget.theme.primaryColor,
              warningColor: Colors.deepOrange.shade500,
              kimColor:  Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: widget.theme.iconTheme.color,
                  fontSize: 18),
              displayText: "",
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 8),
            ),
            const Spacer(),
            Speedometer(
              size: 300,
              minValue: 0,
              maxValue: 180,
              currentValue: vitesse ,
              //(double.parse((int.parse(context.watch<bakodata>().map['0x1026105A'].toString().substring(10,13),radix: 16)).toString())),
              //double.parse((int.parse(this.widget.map['ID_1026105A'].toString().substring(0,3),radix: 16)).toString()), //int.parse(this.widget.map['time'].toString().substring(6, 8)),
              //int.parse(context.watch<ObdReader>().obdData['0'][1]),
              warningValue: 90,
              backgroundColor:  widget.theme.cardColor,
              meterColor: widget.theme.primaryColor,
              warningColor: Colors.deepOrange.shade500,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: widget.theme.iconTheme.color,
                  fontSize: 40),
              displayText:"km/min",
              //int.parse(context.watch<bakodata>().map['0x1026105A']).toString(),
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 15),
            ),
            const Spacer(),
            Speedometer(
              minValue: 0,
              maxValue:7000,
              currentValue: rpm,
              //(double.parse((int.parse(context.watch<bakodata>().map['0x10261022'].toString().substring(5,9),radix: 16)).toString())),
              //double.parse((int.parse(this.widget.map['ID_10261023'].toString().substring(2,4),radix: 16)).toString()),
              warningValue: 90,
              backgroundColor:  widget.theme.cardColor,
              meterColor: widget.theme.primaryColor,
              warningColor: Colors.deepOrange.shade500,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: widget.theme.iconTheme.color,
                  fontSize: 40),
              displayText:"tr/min",
              //int.parse(context.watch<bakodata>().map['0x10261022']).toString(),
              //'x1000RPM',
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 15)
            ),
            const Spacer(),

          ],
        ),
      ),

        ),
    );
  }
}
