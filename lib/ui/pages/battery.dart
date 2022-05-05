import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class battery extends StatefulWidget {
  const battery({Key? key}) : super(key: key);

  @override
  State<battery> createState() => _batteryState();
}

class _batteryState extends State<battery> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
 /* var _styleItems = [
    DropdownMenuItem(
      child: Text('skeumorphism'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('flat'),
      value: 0,
    ),
  ];

  var _styleIndex = 0;

  var _colorful = true;

  var _showPercentSlide = true;
  var _showPercentNum = false;

  var _size = 18.0;

  var _ratio = 3.0;

  Color _color = Colors.blue;

  int bat = 34;

  void increment() {
    setState(() {
      if (bat < 100) {
        bat++;
      }
    });
  }

  void decrement() {
    setState(() {
      if (bat > 0) {
        bat--;
      }
    });
  }

  Widget getColorSelector(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print(color);
          _color = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: HexColor("#175989"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200.0,
              height: 100.0,
              child: Center(
                child: BatteryIndicator(
                  batteryFromPhone: false,
                  batteryLevel: bat,
                  style: BatteryIndicatorStyle.values[_styleIndex],
                  colorful: _colorful,
                  showPercentNum: _showPercentNum,
                  mainColor: HexColor("#175989"),
                  size: _size,
                  ratio: _ratio,
                  showPercentSlide: _showPercentSlide,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('size:'),
                  Expanded(
                    child: Slider(
                      min: 25.0,
                      max: 65.0,
                      divisions: 300,
                      label: '${_size.toStringAsFixed(1)}',
                      value: _size,
                      onChanged: (val) {
                        setState(() {
                          _size = val;
                        });
                      },
                    ),
                  ),
                  Text('ratio:'),
                  Expanded(
                    child: Slider(
                      min: 1.0,
                      max: 10.0,
                      divisions: 30,
                      label: '${_ratio.toStringAsFixed(1)}',
                      value: _ratio,
                      onChanged: (val) {
                        setState(() {
                          _ratio = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: decrement, child: Text("Down")),
                ElevatedButton(onPressed: increment, child: Text("Up")),
              ],
            )
          ],
        ),
      ),
    );
  }

}*/
