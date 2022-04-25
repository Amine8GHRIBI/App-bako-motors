import 'package:flutter/material.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:mini_project/tesla_app/screens/settings_screen.dart';
import 'package:mini_project/ui/pages/Dashboard.dart';
import 'package:mini_project/ui/pages/DashbordScreen.dart';
import 'package:mini_project/ui/pages/slider_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unicons/unicons.dart';


import '../../DataBase/user_database.dart';
import '../../data/OBDParametres.dart';
import '../../data/userEntity.dart';
import '../../ui/pages/connexion_obd.dart';
import '../configs/colors.dart';
import 'home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class BaseScreen extends StatefulWidget {

   UserDatabase database;
   User user;
  BaseScreen({Key? key ,required this.database ,required this.user}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 4;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    super.dispose();
  }



  List<OBD> obds = [];
  List<OBD> newobd = [];

  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await this.widget.database.obdDAO.retrieveAllOBD();
    debugPrint("obd diagno " + obds.length.toString());
    setState(() {});
    return obds;
  }



  @override
  void initState()  {
    super.initState();
    _tabController = TabController(length: _tabLength, vsync: this);

      //  retrieveOBD(this.widget.database);
      //debugPrint("obd diagno " + obds.last.speed.toString());
      setState(()  {

      },);

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [ HomeScreen(database: this.widget.database ,user: this.widget.user , key: GlobalKey()), DashboardScreen(database: this.widget.database ,user: this.widget.user,key: GlobalKey()),
      dashboard(database: this.widget.database ,user: this.widget.user,key: GlobalKey()),
      SettingsScreen(),];

    navigateTo(int index) {
      setState(() {
     //   _pages.removeAt(0);
      //  _pages.insert(0,  HomeScreen(database: this.widget.database ,user: this.widget.user ,key: GlobalKey()));
        _selectedIndex = index;
      });
    }
   /* navigateTo(int index)  {


      Future.delayed(Duration.zero,() {
      setState(() async {
        _pages.removeAt(0);
        _pages.insert(0,  HomeScreen(database: this.widget.database ,user: this.widget.user ,key: GlobalKey()));
       // obds =await this.widget.database.obdDAO.retrieveAllOBD();
        //debugPrint("obdss" + obds.length.toString());
        _tabController.animateTo(index);
        _selectedIndex = index;
      });
      });

    }
*/
    Widget _bottomAppBarIcon({required int index, required IconData icon}) {
      return IconButton(
        onPressed: () {

          navigateTo(index);
        },
        icon: Icon(
          icon,
          color: _selectedIndex == index ? kPrimaryColor : null,
        ),
        iconSize: 25,
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(

        child: SafeArea(
          child: Container(
            height: 70,
            color: kBottomAppBarColor,
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  _bottomAppBarIcon(index: 0, icon: Icons.home_rounded),
                  _bottomAppBarIcon(index: 1, icon: Icons.directions_car),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 20,
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: buttonGradient),
                              child: IconButton(
                                  iconSize: 60,
                                  onPressed: () {
                                    Get.to( connexion(),arguments: {"database" : this.widget.database , "user" : this.widget.user});
                                  },
                                  icon: Icon(
                                    Icons.power_settings_new_rounded,
                                    color: Colors.white,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  _bottomAppBarIcon(index: 2, icon: IconData(0xebef, fontFamily: 'MaterialIcons')),
                  _bottomAppBarIcon(index: 3, icon: Icons.settings),

                ],
              ),
            ),
          ),
        ),
      ),
      body:
     /* NotificationListener(
      onNotification: (scrollNotification) {
      if (scrollNotification is ScrollEndNotification) _onTabChanged();
      return false;
      },
    child:*/ Container(
        decoration: BoxDecoration(
          gradient: kBackGroundGradient
        ),
        /*child: TabBarView(
          controller: _tabController,
          children:
            _pages
            /*HomeScreen(database: this.widget.database ,user: this.widget.user), DashboardScreen(database: this.widget.database ,user: this.widget.user),
            dashboard(database: this.widget.database ,user: this.widget.user),
            SettingsScreen(),*/

        ),*/
      child: IndexedStack(
        index: _selectedIndex,
        children: _pages
      ),
      ),

    );
  }

  void _onTabChanged() {
    switch (_tabController.index) {
      case 0:
      // handle 0 position
        break;
      case 1:
      // handle 1 position
        break;
    }
    setState(() {});
  }

}
