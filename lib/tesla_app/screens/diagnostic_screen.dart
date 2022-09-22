import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/model.dart';
import '../../data/userEntity.dart';
import '../../ui/pages/bewireless/bako_data.dart';

class DiagnostcScreen extends StatefulWidget {
  UserDatabase database;
  User user;
  Car car;
  late ThemeData theme;
  //final Map<String,dynamic> map;


  DiagnostcScreen({Key? key , required this.database, required this.user, required this.theme , required this.car}) : super(key: key);


  @override
  State<DiagnostcScreen> createState() => _DiagnostcScreenState();
}

class _DiagnostcScreenState extends State<DiagnostcScreen> {

  Timer? timer;


  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
   // await Mybattery(widget.database);
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer t) => context.read<bakodata>().fetchData );
  //timer = Timer.periodic(
  //const Duration(minutes: 1), (Timer t) => calculdata());

  });
    setState(() {});

  }

  /*
  Future<double> Mybattery(UserDatabase db) async {
   // motors = (double.parse(context.watch<ObdReader>().obdData['3'][1])) / 100 ;
    //Coolant_Temperature = (double.parse(context.watch<ObdReader>().obdData['1'][1] )/100);
    //batterie = double.parse(context.watch<ObdReader>().obdData['4'][1]);
   double getbatt = 12.1;
   //double.parse(context.read<ObdReader>().obdData['3'][1]);
    //OBD speedtestt = newobd.firstWhere((element) => element.speed.isNotEmpty,
    //  orElse: () => 'No matching color found');
   if (this.widget.car.name != "Aucun") {
     motors = (double.parse(context.watch<ObdReader>().obdData['3'][1])) / 100 ;
     Coolant_Temperature = (double.parse(context.watch<ObdReader>().obdData['1'][1] )/100);
     batterie = double.parse(context.watch<ObdReader>().obdData['4'][1]);
     //motors = 0.9 ;
     //Coolant_Temperature = 0.8;
     if (getbatt >= 12.6) {
       batt = 100;
     } else if (12.5 <= (getbatt) && (getbatt) < 12.6) {
       batt = 85;
     } else if (12.4 <= (getbatt) && (getbatt) < 12.5) {
       batt = 75;
     } else

     if (12.2 <= (getbatt) && (getbatt) < 12.4) {
       batt = 65;
     } else if (12.1 <= (getbatt) && (getbatt) < 12.2) {
       batt = 50;
     } else if (12.0 <= (getbatt) && (getbatt) < 12.1) {
       batt = 35;
     } else if (11.9 <= (getbatt) && (getbatt) < 12.0) {
       batt = 25;
     } else if (11.8 <= (getbatt) && (getbatt) < 11.9) {
       batt = 15;
     } else if (getbatt <= 11.8) {
       batt = 0;
     }
   }
    setState(() {});
    return batt;
  }
 */


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double batterie;
    double coolant_temperature;
    if(context.watch<bakodata>().map['0x10261022'].toString() == "null" || (this.widget.car.name == "Aucun")){
      coolant_temperature = 0.0;
      batterie = 0.0;
    }else {
      coolant_temperature = (double.parse((int.parse(context.watch<bakodata>().map['ID_10261023'].toString().substring(0,2),radix: 16)).toString()));
      batterie = (double.parse((int.parse((context.watch<bakodata>().map['ID_10261022'].toString().substring(10,12) + context.watch<bakodata>().map['ID_10261022'].toString().substring(8,10)),radix: 16) *0.1) .toString()));


    };
    return Scaffold(
        backgroundColor : widget.theme.cardColor,
     body : SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back() ;             },
                    iconSize: 30,
                    splashRadius: 25,
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: widget.theme.indicatorColor,
                    )),
                Text(
                  'Diagnostics',
                  style: TextStyle(fontSize: 25 , color : widget.theme.indicatorColor),
                ),
                const Spacer(),
                Text(
                  'MODEL ' + widget.car.model.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,  color : widget.theme.indicatorColor),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color : widget.theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 400,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Text(
                            'Global Health',
                            style: TextStyle(fontWeight: FontWeight.bold , color : widget.theme.indicatorColor),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                             decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                               color : widget.theme.cardTheme.color,
                             ),
                                //  gradient: buttonGradient),
                              child: IconButton(
                                  iconSize: 35,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.replay_rounded,
                                    color: Colors.white,
                                  ))),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: SizedBox(
                              width: 350,
                              height: 350,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        width: 230,
                                        height: 230,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:widget.theme.iconTheme.color),
                                      ),
                                    ),
                                  ),
                                  const Center(
                                    child: SizedBox(width: 350, height: 350, child: CustomRipple()),
                                  ),
                                /*  const Positioned(
                                      top: 170,
                                      right: -10,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  const Positioned(
                                      top: 185,
                                      right: -2,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  const Positioned(
                                      top: 100,
                                      left: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  const Positioned(
                                      top: 115,
                                      left: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  const Positioned(
                                      bottom: 100,
                                      right: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  const Positioned(
                                      bottom: 115,
                                      right: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  const Positioned(
                                      bottom: 100,
                                      left: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  const Positioned(
                                      bottom: 115,
                                      left: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),*/
                                  Center(
                                    child: SizedBox(
                                      height: 650,
                                      child: Image.asset(
                                        'assets/image/diag.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Text('Battery Health',
                      style: TextStyle(fontWeight: FontWeight.bold , color : widget.theme.indicatorColor)),
                  const SizedBox(
                    height: 20,
                  ),
                  LinearPercentIndicator(
                    animation: true,
                    backgroundColor: widget.theme.cardColor,
                    percent:batterie / 100,
                    //double.parse(this.widget.map['time'].toString().substring(0, 2)) / 100 ,
                    lineHeight: 20,
                    animationDuration: 2500,
                    center: Text(batterie.toString() + '%', style: TextStyle(color : widget.theme.secondaryHeaderColor)),
                    linearGradient: LinearGradient(

                        colors: [widget.theme.highlightColor, widget.theme.highlightColor]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text('',
                        //context.watch<bakodata>().map['time'].toString().substring(6,8),
                        style: TextStyle(fontWeight: FontWeight.bold,color : widget.theme.indicatorColor)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Sensor(
                        value: 0.0,
                        label: 'Motors',
                        theme: widget.theme,
                      ),
                      Sensor(
                        value: coolant_temperature,
                        label: 'C Temperature ',
                        theme: widget.theme,
                      ),
                      Sensor(
                        value: 0.0,
                        label: 'Brakes',
                        theme: widget.theme,
                      ),


                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
     ),
    );
  }
}

class Sensor extends StatelessWidget {
  const Sensor({
    Key? key,
    required this.value,
    required this.label,
    required this.theme
  }) : super(key: key);

  final double value;
  final double heigth = 120.0;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: heigth,
              color: theme.cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: heigth * value,
                    decoration: BoxDecoration(
                      color: theme.iconTheme.color
                       /* gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors: buttonGradient.colors)*/),
                  )
                ],
              ),
            )),
        const SizedBox(
          height: 5,
        ),
        Text(label,style: TextStyle(fontWeight: FontWeight.bold , color : theme.indicatorColor))
      ],
    );
  }
}

class CustomRipple extends StatefulWidget {
  const CustomRipple({Key? key}) : super(key: key);

  @override
  _CustomRippleState createState() => _CustomRippleState();
}

class _CustomRippleState extends State<CustomRipple>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(begin: 0.4, end: 0.8).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ScaleTransition(
      scale: _animation,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor , width: 8),
            shape: BoxShape.circle),
      ),
    );
  }
}
