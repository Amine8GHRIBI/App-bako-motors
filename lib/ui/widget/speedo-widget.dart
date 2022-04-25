import 'package:flutter/material.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';

class speedo extends StatefulWidget {
  const speedo({Key? key}) : super(key: key);

  @override
  State<speedo> createState() => _speedoState();
}

class _speedoState extends State<speedo> {
  @override
  Widget build(BuildContext context){
    return Directionality(
      textDirection: TextDirection.ltr,

      child: Container(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[

            Spacer(),
            Speedometer(
              size: 100,
              minValue: -10,
              maxValue: 50,
              currentValue: 30,
              warningValue: 40,
              backgroundColor: Colors.black,
              meterColor: Colors.lightBlueAccent,
              warningColor: Colors.orange,
              kimColor: Colors.purpleAccent,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: Colors.white,
                  fontSize: 18),
              displayText: '°C',
              displayTextStyle: TextStyle(color: Colors.white, fontSize: 8),
            ),
            Spacer(),
            Speedometer(
              size: 300,
              minValue: 0,
              maxValue: 180,
              currentValue: 58,
              warningValue: 90,
              backgroundColor: Colors.black,
              meterColor: Colors.green,
              warningColor: Colors.orange,
              kimColor: Colors.white,
              displayNumericStyle: TextStyle(
                  fontFamily: 'Digital-Display',
                  color: Colors.white,
                  fontSize: 40),
              displayText: 'km/h',
              displayTextStyle: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Spacer(),
            Speedometer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}