import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:mini_project/ui/pages/loading_conx.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class slider_connexion extends StatefulWidget {
  final UserDatabase database;
  final User? use;
  ThemeData? theme;
  Car? car;

   slider_connexion({Key? key,  required this.database, required this.use, required this.theme , this.car }) : super(key: key);

  @override
  State<slider_connexion> createState() => _slider_connexionState();
}

class _slider_connexionState extends State<slider_connexion> {
  List<Slide> slides = [];
  StreamSubscription? connection;
  bool isoffline = false;


  @override
  void initState() {
    super.initState();
    connection = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });

    slides.add(
      Slide(
        title: "start your car",
        styleTitle: const TextStyle(
            color: Color(0xff7FFFD4),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Turn on your car",
        styleDescription: const TextStyle(
            color: Color(0xff7FFFD4),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/images/startcar.jpg",
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      Slide(
        title: "Connect to ",
        styleTitle: const TextStyle(
            color: Color(0xffFFDAB9),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "BAKO_MOTORS wifi",
        styleDescription: const TextStyle(
            color: Color(0xffFFDAB9),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/image/wifi.png",
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    EasyLoading.show(status: 'loading...');

    // Do what you want
    //Get.to(loading(user : widget.use , database : widget.database , car : widget.car,theme : widget.theme ));
    if (isoffline == false) {
      EasyLoading.showSuccess('Great Success!' );
      EasyLoading.instance
        ..displayDuration = const Duration(seconds: 3);
     Navigator.pushNamed(context, '/app', arguments: {
        "database": widget.database,
        "user": widget.use,
        "car": widget.car
      });

    }else{
      EasyLoading.instance
        ..displayDuration = const Duration(seconds: 3);
      EasyLoading.showError('Failed with Error');

    }
  }
  void onPrevPress() {
    // Do what you want
    //Navigator.of(context).pushNamed( '/cnxobd',arguments: {"database" : widget.database, "user" : widget.use});
    Get.back();
    //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => connexion() ,), (r) => false );
  }

  void onNextPress() {
    print("onNextPress caught");
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.navigate_next,
      color: Color(0xffF3B4BA),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Color(0xffF3B4BA),
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_previous,
      color: Color(0xffF3B4BA),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(const Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    //database = routes["database"];
    //user =routes["user"];
    return FlutterEasyLoading(
      child : MaterialApp(
      home : Scaffold (
        body : IntroSlider(
      // List slides
      slides: slides,

      // Skip button
      renderSkipBtn: renderSkipBtn(),
            onSkipPress :onPrevPress,
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      onNextPress: onNextPress,
      nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: const Color(0x33FFA8B0),
      colorActiveDot: const Color(0xffFFA8B0),
      sizeDot: 13.0,

      // Show or hide status bar
      hideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,

      // Scrollbar
      verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    ),
    ),
      debugShowCheckedModeBanner: false,

    ),
    );
  }
}
