import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';
import '../widget/profile-widget/button_widget.dart';


class userPage extends StatefulWidget {
  const userPage({Key? key}) : super(key: key);

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {

  late UserDatabase database;

  Future<List<User>> retrieveUsers() async {
    return await this.database.userDAO.retrieveUsers();
  }
  Future<List<Car>> retrievCars() async {
    return await this.database.carDAO.retrieveCars();
  }

  @override
  void initState() {
    super.initState();
    $FloorUserDatabase
        .databaseBuilder('user_database.db')
        .build()
        .then((value) async {
      this.database = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list users"),

      ),
      body: FutureBuilder(
        future:retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),

                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this
                        .database
                        .userDAO
                        .deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child:  InkWell(
                      child: Card(

                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          title: Text(snapshot.data![index].name),
                          subtitle: Text(snapshot.data![index].lastName),
                        ),
                      ),
                      onTap: () {
                          Navigator.pushNamed(context , '/user',arguments: {"user" : snapshot.data![index]});
                          // ignore: avoid_function_literals_in_foreach_calls
                          debugPrint("user data " + snapshot.data![index].birthday);
                      },

                    ),

                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  /*Widget buildetailButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {Navigator.pushNamed(context , '/user',arguments: {"staff" : user});},
  );
*/
}
