import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Kilometragedata {
  late int year;
  late int population;
  late charts.Color barColor;
  Kilometragedata({
    required this.year,
    required this.population,
    required this.barColor
  });
}
