import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:mini_project/ui/pages/loading_conx.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';


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


  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title:
        "OBD II",
        maxLineTitle: 2,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
        "install your device",
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontFamily: 'Raleway',
        ),
        marginDescription:
        const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: const Text("",
            style: TextStyle(color: Colors.white)),
          backgroundImage: "assets/images/obdii.png",
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
      ),
    );
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
        title: "Pairing bleutooth",
        styleTitle: const TextStyle(
            color: Color(0xffFFDAB9),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
        "Turn on bleutooth",
        styleDescription: const TextStyle(
            color: Color(0xffFFDAB9),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        backgroundImage: "assets/images/bluetooth.png",
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    Get.to(loading(user : widget.use , database : widget.database , car : widget.car,theme : widget.theme ));
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
    return MaterialApp(
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

    );
  }
}
