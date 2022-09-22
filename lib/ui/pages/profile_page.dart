import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/data/CarEntity.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarUserEntity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/userEntity.dart';



class profile_page extends StatefulWidget {
  UserDatabase database;
  User user;
  ThemeData theme;
   profile_page({Key? key, required this.database,required this.user,required this.theme}) : super(key: key);

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
 // late UserDatabase database;

 // late ThemeData theme;
  String name='';
  String model ='';
  String year ='';
  String license_Plate='';
  String initial_mileage='';


  Future<List<caruser>> retrievCarsusers() async {
    return await this.widget.database.caruserDAO.retrieveAllcarsusers();
    setState (() {});
  }

  Future<User?> retrieveUserbyid(int id) async {
    User? user ;
    user = await this.widget.database.userDAO.retrieveUser(id);
    return user;

    setState (() {});
  }

  Future<int> addcar(UserDatabase db ,String name , String model ,String year ,String licensePlate ,String initialMileage ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    Car firstcar = Car(name : name, model : model, year :year ,license_Plate: licensePlate, initial_mileage : initialMileage );
    int idCar =  await db.carDAO.insertCar(firstcar);

   // debugPrint("car add " + firstcar.name );
    List<int> carusers = await addusercar(db, idCar, this.widget.user.id!);
    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return idCar;
  }

  Future<List<int>> addusercar(UserDatabase db , int idcar , int iduser  ) async {
    //, String phoneNumber , String birthday , String email,String  adresse
    caruser firstcaruser = caruser(id_car: idcar , id_user: iduser);
   // debugPrint("car add " + firstcaruser.id_car.toString());

    //User firstUser = User(name: "amine ", lastName: "ghribi", phoneNumber : "94574896" , email : "agh@gmail.com ", birthday :"19595", adresse :"gabes ");
    return await db.caruserDAO.insertCaruser([firstcaruser]);
  }

  Future<List<Car>> retrievCarsByuser(int id ) async {
    List<caruser> carsuser = await this.widget.database.caruserDAO.findcaridbyuserid(id);
    List<int> idcars = [] ;
    List<Car> cars =[];
    for (caruser cu in carsuser){
      //debugPrint("idcaruser" + cu.id_car.toString());
      idcars.add(cu.id_car);
    }
    for (int id in idcars){
      Car? cr = await this.widget.database.carDAO.retrieveCar(id);
      cars.add(cr!);
    }

    return cars;
    setState (() {});
  }


  @override
  void initState() {
    setState (() {});

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      AppBar(
        title: Text(
          'Profile' ,
          style: TextStyle(color: this.widget.theme.iconTheme.color),
        ),
        backgroundColor: this.widget.theme.bottomAppBarColor,
        iconTheme: IconThemeData(color: this.widget.theme.iconTheme.color),
      ),
      backgroundColor: this.widget.theme.cardTheme.color,
      body: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 4,
                decoration: const BoxDecoration(
                  image : DecorationImage(
                    image : ExactAssetImage('assets/newbako/interieur.png'),
                    fit: BoxFit.cover,
                    // height: 30,
                  ),
                  color: Colors.transparent,
                  /* gradient: LinearGradient(
                        colors: [Color(0xff8d70fe), Color(0xff2da9ef)],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                    )*/
                ),



               /* child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect( // Clip it cleanly.
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          color: Colors.grey.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: _myHeaderContent(),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ),
            ),
            Positioned(
              top: 225.0,
              left: 10.0,

              child: Container(
                padding:  const EdgeInsets.all(2.3),
                color: this.widget.theme.cardColor,
                width: 340.0,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 0.5,

                child:FutureBuilder(
                  future: retrieveUserbyid(this.widget.user.id!),
                  builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                      var data = snapshot.data;
                     if (data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                       return Column(

                             children: <Widget>[
                               Text('Complete profile ',
                                 textAlign: TextAlign.right,

                                 style: GoogleFonts.poppins(
                                   color: this.widget.theme.textTheme.headline1
                                       ?.color,
                                   fontSize: 14,
                                   fontWeight: FontWeight.bold,
                                 ),),
                    Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                    child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                    leading: Icon(Icons.account_circle),
                    title: Text(data.name),
                    trailing: Icon(Icons.arrow_forward),
                    ),
                    ),
                    )] );
                               //flex: 1, // takes 30% of available width
                               /*_myListContainer(
                                   data.name, data.surName,
                                   data.phoneNumber,
                                   this.widget.theme.cardTheme.color),

                             );*/
                     }
                     },),),),
            Positioned(
              top: 340.0,
              left: 20.0,
              child: Container(
                  padding:  const EdgeInsets.all(2.3),
                  color: this.widget.theme.cardColor,

                  width: 320.0,
                  height: MediaQuery.of(context).size.height / 1,
                  child:FutureBuilder(
                    future : retrievCarsByuser(this.widget.user.id!),
                    builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
                      var data = snapshot.data;
                      if (data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }else{
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return
                              Card(
                              elevation: 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              child: Container(
                              child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                              leading: Icon(Icons.car_rental),
                              title: Text(data[index].name),
                              trailing: Icon(Icons.arrow_forward),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialog();
                                        });
                                  },
                              ),
                              ),
                            /*  _myListContainer(
                                  snapshot.data![index].name, snapshot.data![index].model,
                                  snapshot.data![index].year,  this.widget.theme.cardTheme.color
                              ),*/


                              );
                          }
                      );} },)
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                final taskval = TextEditingController();
                final modelval = TextEditingController();
                final yearval = TextEditingController();
                final mileageval = TextEditingController();
                final platval = TextEditingController();
                final subval = TextEditingController();
                final tasktime = TextEditingController();

                Color taskcolor;

                return AlertDialog(
                  backgroundColor: this.widget.theme.cardTheme.color,
                  title: const Text("New car"),
                  content: SizedBox(
                    height: 280.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              name = value.toString().trim();
                            },
                            controller: taskval,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car name",
                              hintStyle: TextStyle(color: this.widget.theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              model = value.toString().trim();
                            },
                            controller:  modelval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car modele",
                              hintStyle: TextStyle(color: this.widget.theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              year = value.toString().trim();
                            },
                            controller: yearval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "car year",
                              hintStyle: TextStyle(color: this.widget.theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            onChanged: (value) {
                              initial_mileage = value.toString().trim();
                            },
                            controller: mileageval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "initial_mileage"
                              ,
                              hintStyle: TextStyle(color: this.widget.theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),

                        Container(
                          child: TextField(
                            onChanged: (value) {
                              license_Plate = value.toString().trim();
                            },
                            controller: platval,
                            obscureText: false,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "license_Plate",
                              hintStyle: TextStyle(color:this.widget.theme.textTheme.headline1?.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  actions: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      color: this.widget.theme.bottomAppBarColor,
                      child: const Text("Add", style: TextStyle(
                          color: Colors.white
                      ),),
                      onPressed: () {
                        addcar(this.widget.database ,name, model,year,license_Plate, initial_mileage);

                        setState(() {
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
          );
        },
        backgroundColor:  this.widget.theme.primaryColor,
        foregroundColor: const Color(0xffffffff),
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: this.widget.theme.primaryColor,
        shape: const CircularNotchedRectangle(

        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.stickyNote),
              color: Colors.white,
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.search),
              color: Colors.white,
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _myListContainer(String taskname, String subtask, String taskTime, Color? taskColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: SizedBox(

        height: 80.0,
        child: Material(

          color: this.widget.theme.textTheme.headline1
              ?.color,
          elevation: 14.0,
          shadowColor: this.widget.theme.primaryColor,

          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                    height: 80.0,
                    width: 10.0,
                    color: taskColor,
                  ),
                   Expanded(
                    child: Padding(

                      padding: const EdgeInsets.all(8.0),
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Text(taskname, style: TextStyle(
                                  fontSize: 24.0,
                                  color: taskColor,
                                  fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,

                            child: Container(
                              child: Text(subtask, style: TextStyle(
                                  fontSize: 18.0, color:taskColor)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(taskTime, style: TextStyle(
                          fontSize: 18.0, color: taskColor)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myHiddenContainer(Color taskColor) {
    return Container(

      height: MediaQuery.of(context).size.height,
      color: taskColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                icon: const Icon(FontAwesomeIcons.solidTrashAlt),
                color: Colors.white,
                onPressed: () {
                  setState(() {

                  });
                }),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: const Icon(FontAwesomeIcons.archive),
                color: Colors.white,
                onPressed: () {
                  setState(() {

                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _myHeaderContent() {
    return Align(
      child: ListTile(
       // leading: Icon(Icons.account_box, size: 75, color:  theme.primaryColor),
        title: Text(
            "", style: TextStyle(fontSize: 28.0, color: this.widget.theme.primaryColor)),
        subtitle: Text(
            "", style: TextStyle(fontSize: 24.0, color:  this.widget.theme.primaryColor)),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(image: new AssetImage("assets/newbako/pan.png"), fit: BoxFit.cover,),
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],

      ),
     /* child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
*/
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Image.asset(
            'assets/image/bakoappbar.png',
            fit: BoxFit.cover,
          ),

          EditableCard(
            labelText: 'Name',
            hintText: 'Enter your car name',
            onChanged: (valuename) => print('New name: $value'),
          ),
          EditableCard(
            labelText: 'Model',
            hintText: 'Enter your car model',
            onChanged: (value) => print('New ID: $value'),
          ),
          EditableCard(
            labelText: 'Car year',
            hintText: 'Enter your car year',
            onChanged: (value) => print('New phone: $value'),
          ),
          EditableCard(
            labelText: 'Licence plate',
            hintText: 'Enter your car licence plate',
            onChanged: (value) => print('New school address: $value'),
          ),
          EditableCard(
            labelText: 'Initial kilometrage',
            hintText: 'Enter your car initial kilometrage',
            onChanged: (value) => print('New home address: $value'),
          ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              color: theme.bottomAppBarColor,
              child: const Text("Add", style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: () {
                addcar(this.widget.database ,name, model,year,license_Plate, initial_mileage);

                Navigator.pop(context);
              },
            ),

          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: new IconButton(
              icon: new Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            )
            ,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
class EditableCard extends HookWidget {
  final String initialValue = '';
  final String labelText;
  final String hintText;
  final ValueChanged<String> onChanged;


  const EditableCard({
    Key? key,

    required this.labelText,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _editing = useState(false);
    final _controller = useTextEditingController(text: initialValue ?? '');
    return _editing.value
        ? TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      autofocus: true,
      onEditingComplete: () {
        _editing.value = false;
        onChanged.call(_controller.text);
      },
    )
        : Card(
      child: ListTile(
        onTap: () => _editing.value = true,
        leading: Icon(
          Icons.arrow_back_ios_sharp,
          color: Colors.blue,
        ),
        title: Text(
          labelText,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
            _controller.text.isNotEmpty ? _controller.text : hintText),
      ),
    );
  }
}