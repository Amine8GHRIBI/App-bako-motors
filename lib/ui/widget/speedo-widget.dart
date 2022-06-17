import 'dart:async';
import 'dart:math';
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

class speedo extends StatefulWidget {
  ThemeData theme;
  UserDatabase database;
  Car car;


  speedo({Key? key , required this.theme, required this.database ,required this.car}) : super(key: key);

  @override
  State<speedo> createState() => _speedoState();
}

class _speedoState extends State<speedo> {
  double velocity = 0;
  double highestVelocity = 0.0;
  int speed= 0;
  int rpm = 0;
  int temperature = 0;
  int module_voltage = 0;
  double engineload = 0.0;
  double DistanceMILOn = 0.0;

  List<OBD> obds = [];
  Timer? timer;
  List<OBD> DD = [];
  @override
  void initState() {
   // if(this.widget.car.id != null) {
    Future.delayed(Duration.zero, () async {
      timer = Timer.periodic(const Duration(microseconds: 1), (Timer t) => getdata());
      //timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => context.read<ObdReader>().increment());
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => DistanceMILOn += DistanceMILOn);
      //timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => Provider.of<ObdReader>(context, listen: false));

      timer = Timer.periodic(const Duration(seconds: 2), (Timer t) => addOBDst(widget.database));
      timer = Timer.periodic(const Duration(seconds: 6), (Timer t) => retrieveOBD(widget.database));
      DD = await retrieveOBD(widget.database);

    });
    setState(()  {});
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
    if (mounted) {
      setState (() {});
    }
  }

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await widget.database.obdDAO.retrieveAllOBD();
    debugPrint("obd diagno " + obds.last.speed.toString());
    setState(() {});
    return obds;
  }
  void getdata(){
    context.read<ObdReader>().increment();
    if(context.read<ObdReader>().obdData['0'][1] != "Failed to get speed." || context.read<ObdReader>().obdData['0'][1] != "Null"){
      context.read<ObdReader>().increment();
      speed = int.parse(context.read<ObdReader>().obdData['0'][1]);
      rpm = int.parse(context.read<ObdReader>().obdData['2'][1]);
      temperature =int.parse(context.read<ObdReader>().obdData['1'][1].substring(0,2));
      engineload = double.parse(context.read<ObdReader>().obdData['3'][1]);
      timer = Timer.periodic(const Duration(seconds: 50), (Timer t) => DistanceMILOn++);
}
        //timer = Timer.periodic(Duration(seconds:1 ), (Timer t) => DistanceMILOn += DistanceMILOn);
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => DistanceMILOn++);
     // context.read<ObdReader>().increment();
      //context.read<ObdReader>().increment();
    setState (() {
    });}

  Future<List<int>> addOBDst(UserDatabase db ) async {
    double DistanceMILO =0.0;
    final DateTime now = DateTime.now();
    final DateFormat formatterdate = DateFormat('yyyy-MM-dd');
    final DateFormat formattertime = DateFormat('HH:mm:ss');

    final String formatteddate = formatterdate.format(now);
    final String formattedtime = formattertime.format(now);

    List<int> ob =[];
  /*  OBD obddtat= OBD(
        speed: "90",
        rpm: context.read<ObdReader>().obdData['2'][1].toString(),
        CoolantTemperature: context.read<ObdReader>().obdData['1'][1].substring(0,2).toString(),
        ModuleVoltage: context.read<ObdReader>().obdData['4'][1].toString(), date: now.toString(), car_id: this.widget.car.id!, time: formattedtime,
        DistanceMILOn: DistanceMILOn.toString(), troublecodes: context.read<ObdReader>().obdData['7'][1].toString(),
        tripRecords: context.read<ObdReader>().obdData['6'][1].toString(), engineload: context.read<ObdReader>().obdData['3'][1].toString()
    );*/

    OBD obddtat= OBD(
        speed: speed.toString(),
        rpm: rpm.toString(),
        CoolantTemperature: temperature.toString(),
        ModuleVoltage: module_voltage.toString(), date: now.toString(), car_id: widget.car.id!, time: formattedtime,
        DistanceMILOn: DistanceMILOn.toString(), troublecodes: context.read<ObdReader>().obdData['7'][1].toString(),
        tripRecords: context.read<ObdReader>().obdData['6'][1].toString(), engineload: engineload.toString()
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
            text: 'Speedometer',
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
  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z
    );

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }

    setState(() {
      velocity = newVelocity;

      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }
    });
  }


  @override
  Widget build(BuildContext context){

    return Directionality(
      textDirection: ui.TextDirection.ltr,
        child: Scaffold(
          appBar:
          AppBar(iconTheme : IconThemeData(
              color: widget.theme.iconTheme.color,
          ),
            title: Text(obds.length.toString()  + obds.last.DistanceMILOn.toString() /*+ "distance " + obds.last.DistanceMILOn.toString()*/, style: TextStyle(color : widget.theme.primaryColor),),
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
              currentValue: temperature,
              warningValue: 40,
              backgroundColor: widget.theme.cardColor,
              meterColor: widget.theme.primaryColor,
              warningColor: Colors.deepOrange.shade500,
              kimColor:  Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: widget.theme.iconTheme.color,
                  fontSize: 18),
              displayText: '°C',
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 8),
            ),
            const Spacer(),
            Speedometer(
              size: 300,
              minValue: 0,
              maxValue: 180,
              currentValue: speed,
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
              displayText:context.watch<ObdReader>().obdData['0'][1]+ 'km/h',
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 15),
            ),
            const Spacer(),
            Speedometer(
              minValue: 0,
              maxValue:7000,
              currentValue: rpm,
             // int.parse(context.watch<ObdReader>().obdData['2'][1]),
              warningValue: 90,
              backgroundColor:  widget.theme.cardColor,
              meterColor: widget.theme.primaryColor,
              warningColor: Colors.deepOrange.shade500,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: widget.theme.iconTheme.color,
                  fontSize: 40),
              displayText:rpm.toString() + 'x1000RPM',
              displayTextStyle: TextStyle(color: widget.theme.iconTheme.color, fontSize: 15)),
            const Spacer(),

          ],
        ),
      ),

        ),
    );
  }
}
