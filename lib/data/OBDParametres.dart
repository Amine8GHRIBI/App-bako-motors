

import 'package:floor/floor.dart';

@Entity(
  tableName: 'OBD',
  foreignKeys: [
    ForeignKey(
      childColumns: ['car_id'],
      parentColumns: ['id'],
      entity: OBD,
    ),
  ],
)

class OBD{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String speed;
  final String DistanceMILOn;
  final String rpm;
  final String CoolantTemperature;
  final String ModuleVoltage;
  
  final String date ;
  final String time;
  final String troublecodes;
  final String tripRecords;
  final String engineload;

  @ColumnInfo(name: 'car_id' )
  final int car_id;

  OBD( {this.id,
    required this.DistanceMILOn,
    required this.date,
    required this.time,
    required this.car_id,
    required this.speed,
    required this.rpm,
    required this.CoolantTemperature,
    required this.ModuleVoltage,
    required this.tripRecords,
   required this.troublecodes,
    required this.engineload});

  static fromJson(Map<String, dynamic> parsedJson){
    return OBD(
        speed: parsedJson["speed"],
        rpm: parsedJson["rpm"],
        CoolantTemperature : parsedJson["CoolantTemperature"],
        ModuleVoltage: parsedJson["ModuleVoltage"],
        car_id: parsedJson["car_id"],
        date: parsedJson["date"],
        time: parsedJson["time"],
        DistanceMILOn:parsedJson["DistanceMILOn"],
        tripRecords:parsedJson["tripRecords"],
        troublecodes:parsedJson["troublecodes"],
        engineload:parsedJson["engineload"],
    );
  }
}