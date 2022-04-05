import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mini_project/data/kilometragedata.dart';


class kilometrage_data extends StatefulWidget {
  const kilometrage_data({Key? key}) : super(key: key);

  @override
  State<kilometrage_data> createState() => _kilometrage_dataState();
}

class _kilometrage_dataState extends State<kilometrage_data> {
  final List<Kilometragedata> data = [
    Kilometragedata(
        year: 1880,
        population: 50189209,
        barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue)
    ),
    Kilometragedata(
        year: 1890,
        population: 62979766,
        barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue)
    ),
    Kilometragedata(
        year: 1900,
        population: 76212168,
        barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue)
    ),
    Kilometragedata(
        year: 1910,
        population: 92228496,
        barColor: charts.ColorUtil.fromDartColor(Colors.lightBlue)
    ),
    Kilometragedata(
        year: 1920,
        population: 106021537,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue)
    ),
    Kilometragedata(
        year: 1930,
        population: 123202624,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue)
    ),
    Kilometragedata(
        year: 1940,
        population: 132164569,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue)
    ),
    Kilometragedata(
        year: 1950,
        population: 151325798,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue)
    ),
    Kilometragedata(
        year: 1960,
        population: 179323175,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue)
    ),
    Kilometragedata(
        year: 1970,
        population: 203302031,
        barColor: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
    Kilometragedata(
        year: 1980,
        population: 226542199,
        barColor: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
    Kilometragedata(
        year: 1990,
        population: 248709873,
        barColor: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
    Kilometragedata(
        year: 2000,
        population: 281421906,
        barColor: charts.ColorUtil.fromDartColor(Colors.purple)
    ),
    Kilometragedata(
        year: 2010,
        population: 307745538,
        barColor: charts.ColorUtil.fromDartColor(Colors.black)
    ),
    Kilometragedata(
        year: 2017,
        population: 50000000,
        barColor: charts.ColorUtil.fromDartColor(Colors.black)
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height:600,
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "kilometrage",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: charts.BarChart(
                      _getSeriesData(),
                      animate: true,
                      domainAxis: charts.OrdinalAxisSpec(
                          renderSpec: charts.SmallTickRendererSpec(
                              labelRotation: 60)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getSeriesData() {
    List<charts.Series<Kilometragedata, String>> series = [
      charts.Series(
          id: "Population",
          data: data,
          domainFn: (Kilometragedata series, _) => series.year.toString(),
          measureFn: (Kilometragedata series, _) => series.population,
          colorFn: (Kilometragedata series, _) => series.barColor
      )
    ];
    return series;
  }
}