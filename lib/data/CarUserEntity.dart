import 'package:floor/floor.dart';
import 'package:mini_project/data/CarEntity.dart';
import 'package:mini_project/data/userEntity.dart';

@Entity(
  tableName: 'CarUser',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
    ),
    ForeignKey(
      childColumns: ['car_id'],
      parentColumns: ['id'],
      entity: Car,
    )
  ],
)

class caruser{

  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'user_id' )
  final int id_user;
  @ColumnInfo(name: 'car_id' )
  final int id_car;

  caruser( {
    this.id,
    required this.id_user,
    required this.id_car,
});

}