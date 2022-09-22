
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class locationtracker extends StatefulWidget {
  const locationtracker ({Key? key}) : super(key: key);

  @override
  State<locationtracker> createState() => _locationtrackerState();
}

class _locationtrackerState extends State<locationtracker> {
  final MapShapeLayerController _layerController = MapShapeLayerController();

  final TextEditingController _currentLocationTextController =
  TextEditingController();

  final TextEditingController _destinationLocationTextController =
  TextEditingController();

   double _distanceInMiles = 0.0;
   late MapShapeSource _dataSource;
  late List<Model> _data;

  late Position _currentPosition, _destinationPosition;

  @override
  void dispose() {
    _layerController.dispose();
    _currentLocationTextController.dispose();
    _destinationLocationTextController.dispose();
    super.dispose();
  }
  void initState() {
    _data = const <Model>[
      Model('New South Wales', Color.fromRGBO(255, 215, 0, 1.0),
          '       New\nSouth Wales'),
      Model('Queensland', Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
      Model('Northern Territory', Color.fromRGBO(255, 78, 66, 1.0),
          'Northern\nTerritory'),
      Model('Victoria', Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
      Model('South Australia', Color.fromRGBO(126, 247, 74, 0.75),
          'South Australia'),
      Model('Western Australia', Color.fromRGBO(79, 60, 201, 0.7),
          'Western Australia'),
      Model('Tasmania', Color.fromRGBO(99, 164, 230, 1), 'Tasmania'),
      Model('Australian Capital Territory', Colors.teal, 'ACT')
    ];
    _dataSource = MapShapeSource.asset(
      'assets/australia.json',
      shapeDataField: 'STATE_NAME',

    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Column(
          children: [
            //Title widget
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Location Tracker',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                //Current location text field.
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _currentLocationTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 3, top: 3, bottom: 3),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        hintText: 'Current location',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //Current location clickable icon.
                IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                  tooltip: 'My location',
                  onPressed: () async {},
                )
              ],
            ),
            Row(
              children: [
                //Destination location text field.
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _destinationLocationTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.only(
                            left: 10, right: 3, top: 3, bottom: 3),
                        hintText: 'Enter the destination',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                //Destination location clickable icon.
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  tooltip: 'Search',
                  onPressed: () async {},
                )
              ],
            ),
            //Maps widget container
            Container(
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),

                   child: SfMaps(
                     layers: [
                       MapTileLayer(
                         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                         initialFocalLatLng: MapLatLng(36.862499, 10.195556),
                         initialZoomLevel: 3,
                       )
                     ],
            ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
class Model {
  /// Initialize the instance of the [Model] class.
  const Model(this.state, this.color, this.stateCode);

  /// Represents the Australia state name.
  final String state;

  /// Represents the Australia state color.
  final Color color;

  /// Represents the Australia state code.
  final String stateCode;
}

