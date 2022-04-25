import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/data/stathome.dart';
import 'package:mini_project/ui/pages/Obd-Home-page.dart';
import 'package:unicons/unicons.dart';

import '../../data/userEntity.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/bottom_nav_item.dart';
import '../widget/drawer/drawer.dart';
import '../widget/homePage/homePage/most_rented.dart';
import '../widget/homePage/homePage/information.dart';
import '../widget/homePage/homePage/top_brands.dart';
import '../widget/login_widget/roundButton.dart';


class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  bool _showDrawer = false;
  AnimationController? _loadingController;


  void showDrawer() {
    print('tapped on show drawer!');
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }

  GlobalKey<ScaffoldState> _key = GlobalKey(); // add this

  late UserDatabase database ;
  late User user;

  @override
  Widget build(BuildContext context) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user=routes["user"];

    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    int currIndex;

    return Stack(
      children :[

        Scaffold(
          key: _key,
          //drawer: MyDrawer(),
          appBar: PreferredSize(

            preferredSize: const Size.fromHeight(60.0), //appbar size
            child: AppBar(
              bottomOpacity: 0.0,
              elevation: 0.0,
             // shadowColor: Colors.transparent,
              backgroundColor: themeData.backgroundColor,
              leading: Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.05,
                ),
                child: SizedBox(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeData.backgroundColor.withOpacity(0.03),

                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                        icon : Icon(
                          UniconsLine.setting,
                          color: themeData.secondaryHeaderColor,
                          size: size.height * 0.025,
                        ),
                        onPressed: showDrawer
                    ),

                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leadingWidth: size.width * 0.15,
              title: Image.asset(
                themeData.brightness == Brightness.dark
                    ? 'assets/icons/SobGOGdark.png'
                    :'assets/icons/SobGOGlight.png'
                    '', //logo
                height: size.height * 0.06,
                width: size.width * 0.35,
              ),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    right: size.width * 0.05,
                  ),
                  child: SizedBox(
                    height: size.width * 0.1,
                    width: size.width * 0.1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeData.backgroundColor.withOpacity(0.03),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        UniconsLine.search,
                        color: themeData.secondaryHeaderColor,
                        size: size.height * 0.025,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: BottomNavigationBar( //bottomNavigationBar

            iconSize: size.width * 0.07,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontSize: 0),
            unselectedLabelStyle: const TextStyle(fontSize: 0),
            currentIndex: currIndex = 0,
            backgroundColor: const Color(0x00ffffff),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: themeData.brightness == Brightness.dark
                ? Colors.indigoAccent
                : Colors.black,
            unselectedItemColor: const Color(0xff3b22a1),
            onTap: (value) {
              switch (value) {
                case 0:
                  //Navigator.pushNamed(context , '/users');
                  Navigator.pushNamed(context , '/users',arguments: {"database" : this.database , "user" : this.user});
                  break;
                case 1:
                  Navigator.pushNamed(context , '/kilo',arguments: {"database" : this.database , "user" : this.user});
                  break;
                case 2:
                  Navigator.pushNamed(context , '/login',arguments: {"database" : this.database , "user" : this.user});
                  break;

                case 3:
                  Navigator.pushNamed(context , '/cars',arguments: {"database" : this.database , "user" : this.user});
                  break;
              }
              setState(() => currIndex = value);


/*
      if (value != currIndex) {
        if (value == 2) {
          Get.off(const MeteoPage());
        }
      }*/
            },
            items: [
              buildBottomNavItem(
                UniconsLine.bell,
                themeData,
                size,
              ),
              buildBottomNavItem(
                UniconsLine.map,
                themeData,
                size,
              ),
              buildBottomNavItem(
                UniconsLine.battery_bolt,
                themeData,
                size,
              ),
              buildBottomNavItem(
                UniconsLine.apps,
                themeData,
                size,
              ),
            ],
          ),

          //buildBottomNavBar(1, size, themeData),
          backgroundColor: themeData.backgroundColor,
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  //padding ALL
                  padding: EdgeInsets.only(
                    top: size.height * 0.02,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),

                      ),
                      color: themeData.cardColor, //section bg color
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            //padd cnx+bako
                            left: size.width *0.04,
                            right: size.width*0.06,
                            top: size.width * 0.04,

                          ),
                          child: SizedBox(
                              height: size.width * 0.15,
                              child : Container(
                                  decoration: BoxDecoration(
                                    color:Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        offset: Offset(2, 4), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child : Row(

                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            //right: size.width * 0.01,
                                          ),
                                          child: SizedBox(
                                            height: size.width * 0.1,
                                            width: size.width * 0.1,
                                            child: Container(

                                              child: Icon(
                                                UniconsLine.car_sideview,
                                                color: themeData.secondaryHeaderColor,
                                                size: size.height * 0.035,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: size.height * 0.005,
                                            left: size.width *0.001,

                                          ),
                                          child: Align(
                                            child: Text( 'BAKO',
                                              style: GoogleFonts.poppins(
                                                color: themeData.secondaryHeaderColor,
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                     /*   Padding(
                                          padding: EdgeInsets.only(
                                            top: size.height * 0.005,
                                            left : size.width*0.235,
                                          ),
                                         child: ElevatedButton(
                                            onPressed: () {
                                             Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const obd_home()),
                                              );

                                            },
                                            child: const Text('connexion'),
                                            style: ElevatedButton.styleFrom(
                                                primary: themeData.secondaryHeaderColor,
                                                fixedSize: const Size(120, 15),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(50))),
                                          ),

                                        ),*/
                                      ]
                                  )
                              )

                          ),),
                        /* */

                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            left: size.width * 0.02,
                            bottom: size.height * 0.035,
                          ),
                          child:
                          SizedBox(
                              width: size.width * 0.99,
                              height: size.height * 0.138,
                              child:  information(size, themeData) // information list
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               // _buildDashboardGrid(size),

                //  buildTopBrands(size, themeData),
               // buildMostRented(size, themeData),

                //buildTopBrands(size, themeData),
                //buildMostRented(size, themeData),
              ],
            ),
          ),
        ),
       if (_showDrawer)
         DrawerWidget(
          closeFunction: showDrawer,
         ),
      ]
    );

    // ignore: dead_code

  }

  Widget _buildDashboardGrid(Size size) {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 18,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
/*
         SizedBox(
           width: 200,
          height: 0,
          child : RaisedButton(
              color : Colors.lightBlue,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            onPressed:() {

        }),),
*/
        _buildButton(
          icon: const Icon(UniconsLine.dashboard),
          label: 'Dashboard',
          interval: const Interval(0, aniInterval),
        ),
        ],
    );
  }

  Widget _buildButton(
      {Widget? icon, String? label, required Interval interval}) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user =routes["user"];
   // Size size = MediaQuery.of(context).size; //check the size of device
    //ThemeData themeData = Theme.of(context);

    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.42),
      ),
      onPressed: () {
        debugPrint("pr " + label!);
        if( label == "Profile"){
          Navigator.pushNamed(context , '/profile',arguments: {"database" : this.database , "user" : this.user});
        }
        if( label == "connexion"){
          Navigator.pushNamed(context , '/conn',arguments: {"database" : this.database , "user" : this.user});
        }
        if (label == "dashboard") {
          //buildCar(1, size, themeData);
          Navigator.pushNamed(context , '/users',arguments: {"database" : this.database , "user" : this.user});
        }
        if (label == "maintenance") {
          //buildCar(1, size, themeData);
          Navigator.pushNamed(context , '/cnxobd' , /*,arguments: {"database" : this.database , "user" : this.user}*/);
        }
        //
      },
    );
  }

  OutlineInputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}
