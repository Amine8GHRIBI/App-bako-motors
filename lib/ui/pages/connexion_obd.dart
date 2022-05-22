import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mini_project/ui/pages/slider_page.dart';

import '../../DataBase/user_database.dart';
import '../../data/CarEntity.dart';
import '../../data/CarUserEntity.dart';
import '../../data/userEntity.dart';
import 'AppColors.dart';


class connexion extends StatefulWidget {
  ThemeData? theme;
 connexion({Key? key, this.theme}) : super(key: key);

  @override
  State<connexion> createState() => _connexionState();
}

class _connexionState extends State<connexion> {

  late UserDatabase database;
  late User use;
  List<Car> cars =[];


  Future<List<Car>> retrievCarsByuser(int? id , UserDatabase database ) async {
    List<caruser> carsuser = await this.database.caruserDAO.findcaridbyuserid(id!);
    List<int> idcars = [] ;
    List<String> ca =[];
    for (caruser cu in carsuser){
      debugPrint("idcaruser" + cu.id_car.toString());
      idcars.add(cu.id_car);
    }
    for (int id in idcars) {
      Car? cr = await this.database.carDAO.retrieveCar(id);
      cars.add(cr!);
      ca.add(cr.name);
      _elements['List of Cars'] = ca;

    }
    debugPrint("cars " + cars.length.toString());
    debugPrint("user_id :" + use.id.toString());
    return cars;
  }

  Map<String, List> _elements = {
    'List of Cars': []
    //'Team B': ['Toyah Downs', 'Tyla Kane'],
  };

  List<Car> CARS = [];

  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  List<Car> _foundCars = [];

  @override
  initState()  {
    // at the beginning, all users are shown
    //_foundUsers = _allUsers;
    super.initState();
    Future.delayed(Duration.zero,() async  {
      _foundCars = await retrievCarsByuser(this.use.id,this.database);

      setState(()  {
         //this.retrievCarsByuser(use.id, this.database);
        // _foundCars = CARS ;
      });
    });
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Car> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
     // results = _allUsers;
      results =  cars;
      debugPrint("cars founded " + cars.length.toString());

    } else {
      results = cars
          .where((user) =>
          user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
     // _foundUsers = results;
      _foundCars = results;

      debugPrint("cars founded " + cars.length.toString());
    });
  }
 /* @override
  void initState()  {
    super.initState();
    Future.delayed(Duration.zero,() {
      setState(() async {

        final routes =
        ModalRoute
            .of(context)
            ?.settings
            .arguments as Map<String, dynamic>;
        database = routes["database"];
        use = routes["user"];

        await this.retrievCarsByuser(use.id,this.database);

      },
      );
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    use = routes["user"];

    return Scaffold(

      appBar:
      AppBar(
          title: Text(
            'Connexin OBD',
            style: TextStyle(color: this.widget.theme?.iconTheme.color),
          ),
        backgroundColor: this.widget.theme?.bottomAppBarColor,
        iconTheme: IconThemeData(color: this.widget.theme?.iconTheme.color),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
              Text( 'Choose your car ',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  color:   this.widget.theme?.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              //child:FutureBuilder(
                //future : retrievCarsByuser(this.use.id,this.database),
                //builder: (BuildContext context, AsyncSnapshot<List<Car>> snapshot) {
                child: _foundCars.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundCars.length,
                    //itemBuilder: (BuildContext context, int index) =>
                    itemBuilder: (context, index) => Card(
                          key: ValueKey(_foundCars[index].id),
                          color: this.widget.theme?.primaryColor,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            onTap: () {
                              Get.to( slider_connexion(database: this.database, use: this.use , theme : this.widget.theme, car : _foundCars[index] ));
                            },
                            leading: Text(
                              _foundCars[index].name.toString(),
                              style: const TextStyle(fontSize: 24 ,color: Colors.white),

                            ),
                            title: Text(
                                _foundCars[index].license_Plate.toString(),
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                                '${_foundCars[index].year
                                    .toString()} years old',
                                style: const TextStyle(color: Colors.white)),
                          ),
                    ),
                )
                    : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 24),
                ),
            ),
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Group List View Demo'),
        ),
        body: GroupListView(
          sectionsCount: _elements.keys.toList().length,
          countOfItemInSection: (int section) {
           return _elements.values.toList()[section].length;
           },
          itemBuilder: _itemBuilder,
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                _elements.keys.toList()[section],

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
        ),
      ),
    );
  }

   Widget _itemBuilder(BuildContext context, IndexPath index) {
     String user = _elements.values.toList()[index.section][index.index];

     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: Card(
         elevation: 8,
         child: ListTile(
           onTap: (){
             //Navigator.of(context).pushNamed( '/slider',arguments: {"database" : this.database , "user" : this.user});
             Navigator.pushAndRemoveUntil(context,
                 MaterialPageRoute(builder: (context) => slider_connexion(database: database, use: use) ,), (r) => false );
             },

           contentPadding:
           const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
           leading: CircleAvatar(
             child: Text(
               _getInitials(user),
               style: TextStyle(color: Colors.white, fontSize: 18),
             ),
             backgroundColor: _getAvatarColor(user),
           ),

           title: Text(
             _elements.values.toList()[index.section][index.index],
             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
           ),
           trailing: Icon(Icons.arrow_forward_ios),
         ),
       ),
     );
   }

   String _getInitials(String user) {
     var buffer = StringBuffer();
     var split = user.split(" ");
     for (var s in split) buffer.write(s[0]);

     return buffer.toString().substring(0, split.length);
   }

   Color _getAvatarColor(String user) {
     return AppColors
         .avatarColors[user.hashCode % AppColors.avatarColors.length];
   }
*/
}
