import 'package:flutter/material.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/userEntity.dart';


class userPage extends StatefulWidget {
  const userPage({Key? key}) : super(key: key);

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {


  late UserDatabase database;
  Future<int> addUsers(UserDatabase db ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    User firstUser = User( name: "wevioo", surName : "ghribi", phoneNumber : "94574896" ,
                           email : "aghribi@gmail.com" , birthday :"1995" , adresse: "gabes", username: '', password: '' );
    return await db.userDAO.inserUser(firstUser);
  }

  Future<List<User>> retrieveUsers() async {
    return await database.userDAO.retrieveUsers();
  }
  Future<List<Car>> retrievCars() async {
    return await database.carDAO.retrieveCars();
  }
  @override
  void initState() {
    super.initState();

      setState(() {});
    }

  @override
  Widget build(BuildContext context) {

    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("list users"),

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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),

                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await database
                        .userDAO
                        .deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child:  InkWell(
                      child: Card(

                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Text(snapshot.data![index].name),
                          subtitle: Text(snapshot.data![index].surName),
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
            return const Center(child: CircularProgressIndicator());
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
