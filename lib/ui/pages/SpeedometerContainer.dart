import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import '../../DataBase/user_database.dart';
import '../../data/Speedometre.dart';
import '../../data/userEntity.dart';



class SpeedometerContainer extends StatefulWidget {
  const SpeedometerContainer({Key? key}) : super(key: key);

  @override
  State<SpeedometerContainer> createState() => _SpeedometerContainerState();
}

class _SpeedometerContainerState extends State<SpeedometerContainer> {
  double velocity = 0;
  double highestVelocity = 0.0;
  late UserDatabase database ;
  late User user;


  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
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
  Widget build(BuildContext context) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user=routes["user"];

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 64),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Highest speed:\n${highestVelocity.toStringAsFixed(2)} km/h',
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
              Center(
                  child: speedometer(
                    speed: velocity,
                    speedRecord: highestVelocity,
                  )
              )
            ]
        )
    );
  }

}
