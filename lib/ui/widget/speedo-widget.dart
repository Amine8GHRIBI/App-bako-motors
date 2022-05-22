import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../DataBase/user_database.dart';
import '../../data/OBDParametres.dart';
import '../../data/Speedometre.dart';


import '../../data/model.dart';
import '../Constants.dart';
import '../pages/TransitionRouteObserver.dart';
import 'login_widget/fadeIn.dart';

class speedo extends StatefulWidget {
  ThemeData theme;
  UserDatabase database;

  speedo({Key? key , required this.theme, required this.database}) : super(key: key);

  @override
  State<speedo> createState() => _speedoState();
}

class _speedoState extends State<speedo> {
  double velocity = 0;
  double highestVelocity = 0.0;
  late Timer timer;


  @override
  void initState() {
    //addOBDst(this.widget.database ,Map<dynamic, dynamic> obdwatch );
    timer = Timer.periodic( Duration(seconds: 1), (Timer t) => context.read<ObdReader>().increment());
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
    if (mounted) {
      setState (() {});
    }

  }


  Future<List<int>> addOBDst(UserDatabase db ,Map<dynamic, dynamic> obdwatch ) async {
    List<int> ob =[];
    obdwatch.forEach((k, v) async {
      OBD obddtat= OBD( speed: v[0], rpm: v[1], CoolantTemperature: v[2], ModuleVoltage: v[3], date: '05/04/2022', car_id: 1, time: '06/04/2022', DistanceMILOn: '20');
      List<int> obdsaved = await this.widget.database.obdDAO.insertOBD([obddtat]);
      for (int idsaved in obdsaved) {
        ob.add(idsaved);
      }
    });
    debugPrint(ob.first.toString());
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
        title: GaugeTitle(
            text: 'Speedometer',
            textStyle:
            const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
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
          ], pointers: <GaugePointer>[
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
          majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
          axisTrackStyle: LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: LinearEdgeStyle.bothFlat,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: EdgeInsets.all(10),
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

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion Flutter Gauge')),
        body: ListView(
            children: <Widget>[
              _getGauge(),
              _getGauge(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: FlutterGauge(index: 50.0,width: 800,counterStyle : TextStyle(color: Colors.black,fontSize: 25,),widthCircle: 10,secondsMarker: SecondsMarker.none,number: Number.all),),
                ],
              ),



            ]
    )
    );
  }*/



  @override
  Widget build(BuildContext context){

    return Directionality(
      textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar:
          AppBar(iconTheme : IconThemeData(
              color: this.widget.theme.iconTheme.color,
          ),
            title: Text('Dashboard', style: TextStyle(color : this.widget.theme.primaryColor),),
                 backgroundColor: this.widget.theme.bottomAppBarColor),

          body:
          Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
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
                  onPressed: () => context.read<ObdReader>().increment()
              ),

              Spacer(),
            Speedometer(
              size: 100,
              minValue: -10,
              maxValue: 50,
              currentValue: 30,
              warningValue: 40,
              backgroundColor: this.widget.theme.cardColor,
              meterColor: Colors.lightBlueAccent,
              warningColor: Colors.orange,
              kimColor: Colors.purpleAccent,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: this.widget.theme.iconTheme.color,
                  fontSize: 18),
              displayText: context.watch<ObdReader>().obdData['1'][1].toString() + '°C',
              displayTextStyle: TextStyle(color: this.widget.theme.iconTheme.color, fontSize: 8),
            ),
            Spacer(),
            Speedometer(
              size: 300,
              minValue: 0,
              maxValue: 180,
              currentValue: 58,
              warningValue: 90,
              backgroundColor:  this.widget.theme.cardColor,
              meterColor: Colors.green,
              warningColor: Colors.orange,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: this.widget.theme.iconTheme.color,
                  fontSize: 40),
              displayText:context.watch<ObdReader>().obdData['0'][1].toString() + 'km/h',
              displayTextStyle: TextStyle(color: this.widget.theme.iconTheme.color, fontSize: 15),
            ),
            Spacer(),
            Speedometer(
              minValue: 0,
              maxValue: 180,
              currentValue: 58,
              warningValue: 90,
              backgroundColor:  this.widget.theme.cardColor,
              meterColor: Colors.green,
              warningColor: Colors.orange,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: this.widget.theme.iconTheme.color,
                  fontSize: 40),
              displayText: context.watch<ObdReader>().obdData['2'][1].toString() + 'x1000RPM',
              displayTextStyle: TextStyle(color: this.widget.theme.iconTheme.color, fontSize: 15)),
            Spacer(),

          ],
        ),
      ),

        ),
    );
  }
}
