import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../config/styles.dart';

class CovidBarChart extends StatefulWidget {
  final List<double> covidCases;

  const CovidBarChart({required this.covidCases});

  @override
  State<CovidBarChart> createState() => _CovidBarChartState();
}

class _CovidBarChartState extends State<CovidBarChart> {

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
     var chartLabelsTextStyle = TextStyle(
       color:  theme.primaryColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    );


    return Container(
      height: 350.0,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Daily kilometrage',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: theme.iconTheme.color
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 16.0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    margin: 10.0,
                    showTitles: true,
                    getTextStyles:  (value) =>
                    TextStyle(color: theme.indicatorColor, fontSize: 14.0, fontWeight: FontWeight.w500,),
                    rotateAngle: 35.0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'May 24';
                        case 1:
                          return 'May 25';
                        case 2:
                          return 'May 26';
                        case 3:
                          return 'May 27';
                        case 4:
                          return 'May 28';
                        case 5:
                          return 'May 29';
                        case 6:
                          return 'May 30';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                      margin: 10.0,
                      showTitles: true,
                      getTextStyles:  (value) =>
                          TextStyle(color: theme.indicatorColor, fontSize: 14.0, fontWeight: FontWeight.w500,),
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value % 3 == 0) {
                          return '${value ~/ 3 * 5}K';
                        }
                        return '';
                      }),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 3 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.indicatorColor,
                    strokeWidth: 1.0,
                    dashArray: [5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.covidCases
                    .asMap()
                    .map((key, value) => MapEntry(
                    key,
                    BarChartGroupData(

                      x: key,
                      barRods: [
                        BarChartRodData(
                          y: value,
                          colors : [theme.highlightColor]
                        ),
                      ],
                    )))
                    .values
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
