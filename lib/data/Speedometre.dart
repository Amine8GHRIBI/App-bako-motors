import 'package:flutter/cupertino.dart';

import 'SpeedometerPainter.dart';

class Speedometer extends StatelessWidget {

  Speedometer({
    required this.speed,
    required this.speedRecord,
    this.size = 300
  });

  final double speed;
  final double speedRecord;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SpeedometerPainter(
            speed: speed,
            speedRecord: speedRecord
        ),
        size: Size(size, size)
    );
  }

}
