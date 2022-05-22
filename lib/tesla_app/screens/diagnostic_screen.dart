import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../DataBase/user_database.dart';
import '../../data/userEntity.dart';
import '../configs/colors.dart';
import 'base_screen.dart';
import 'home_screen.dart';

class DiagnostcScreen extends StatefulWidget {
  UserDatabase database;
  User user;
  late ThemeData theme;

  DiagnostcScreen({Key? key , required this.database, required this.user, required this.theme}) : super(key: key);


  @override
  State<DiagnostcScreen> createState() => _DiagnostcScreenState();
}

class _DiagnostcScreenState extends State<DiagnostcScreen> {

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor : this.widget.theme.cardColor,
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
                      color: this.widget.theme.indicatorColor,
                    )),
                Text(
                  'Diagnostics',
                  style: TextStyle(fontSize: 25 , color : this.widget.theme.indicatorColor),
                ),
                Spacer(),
                Text(
                  'MODEL X',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,  color : this.widget.theme.indicatorColor),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color : this.widget.theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 600,
                    child: Stack(

                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Text(
                            'Overall Health',
                            style: TextStyle(fontWeight: FontWeight.bold , color : this.widget.theme.indicatorColor),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                             decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                               color : this.widget.theme.cardTheme.color,
                             ),
                                //  gradient: buttonGradient),
                              child: IconButton(
                                  iconSize: 35,
                                  onPressed: () {},
                                  icon: Icon(
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
                              height: 650,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        width: 230,
                                        height: 230,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:this.widget.theme.iconTheme.color),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(width: 350, height: 350, child: CustomRipple()),
                                  ),
                                  Positioned(
                                      top: 100,
                                      right: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  Positioned(
                                      top: 115,
                                      right: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  Positioned(
                                      top: 100,
                                      left: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  Positioned(
                                      top: 115,
                                      left: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  Positioned(
                                      bottom: 100,
                                      right: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  Positioned(
                                      bottom: 115,
                                      right: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  Positioned(
                                      bottom: 100,
                                      left: 40,
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CustomRipple())),
                                  Positioned(
                                      bottom: 115,
                                      left: 55,
                                      child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: CustomRipple())),
                                  Center(
                                    child: SizedBox(
                                      height: 650,
                                      child: Image.asset(
                                        'lib/tesla_app/images/bird_view_tesla.png',
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
                      style: TextStyle(fontWeight: FontWeight.bold , color : this.widget.theme.indicatorColor)),
                  SizedBox(
                    height: 20,
                  ),
                  LinearPercentIndicator(
                    animation: true,
                    backgroundColor: this.widget.theme.cardColor,
                    percent: 0.8,
                    lineHeight: 20,
                    animationDuration: 2500,
                    center: Text('90.0%', style: TextStyle(color : this.widget.theme.secondaryHeaderColor)),
                    linearGradient: LinearGradient(

                        colors: [this.widget.theme.highlightColor, this.widget.theme.highlightColor]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text('Sensors',
                        style: TextStyle(fontWeight: FontWeight.bold,color : this.widget.theme.indicatorColor)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Sensor(
                        value: 0.8,
                        label: 'Motors',
                        theme: this.widget.theme,
                      ),
                      Sensor(
                        value: 0.4,
                        label: 'Batery Temp',
                        theme: this.widget.theme,
                      ),
                      Sensor(
                        value: 0.9,
                        label: 'Brakes',
                        theme: this.widget.theme,
                      ),
                      Sensor(
                        value: 0.6,
                        label: 'Suspentions',
                        theme: this.widget.theme,
                      )
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
              color: this.theme.cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: heigth * value,
                    decoration: BoxDecoration(
                      color: this.theme.iconTheme.color
                       /* gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors: buttonGradient.colors)*/),
                  )
                ],
              ),
            )),
        SizedBox(
          height: 5,
        ),
        Text(label,style: TextStyle(fontWeight: FontWeight.bold , color : this.theme.indicatorColor))
      ],
    );
  }
}

class CustomRipple extends StatefulWidget {
  CustomRipple({Key? key}) : super(key: key);

  @override
  _CustomRippleState createState() => _CustomRippleState();
}

class _CustomRippleState extends State<CustomRipple>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
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
