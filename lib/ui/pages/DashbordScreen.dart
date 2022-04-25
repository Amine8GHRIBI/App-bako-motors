import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:flutter_login/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mini_project/DataBase/user_database.dart';
import 'package:mini_project/customswitch/app.dart';
import 'package:mini_project/data/stathome.dart';
import 'package:mini_project/tesla_app/app.dart';
import 'package:mini_project/ui/pages/Dashboard.dart';
import 'package:mini_project/ui/pages/SpeedometerContainer.dart';
import 'package:mini_project/ui/pages/connexion_obd.dart';
import 'package:mini_project/ui/pages/profile_page.dart';
import 'package:mini_project/ui/pages/realtime_db.dart';
import 'package:mini_project/ui/widget/speedo-widget.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import '../../data/OBDParametres.dart';
import '../../data/model.dart';
import '../../tesla_app/screens/settings_screen.dart';
import '../widget/bottom_nav_bar.dart';
import '../widget/bottom_nav_item.dart';
import '../widget/drawer/drawer.dart';
import '../widget/homePage/homePage/car.dart';

import '../../data/userEntity.dart';
import '../Constants.dart';
import '../widget/homePage/homePage/information.dart';
import '../widget/homePage/homePage/most_rented.dart';
import '../widget/login_widget/AnimatedNumericText.dart';
import '../widget/login_widget/fadeIn.dart';
import '../widget/login_widget/roundButton.dart';
import 'Obd-Home-page.dart';

import 'TransitionRouteObserver.dart';
import 'car_page.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
   UserDatabase database;
   User user;
   DashboardScreen({Key? key ,  required this.database, required this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {

  bool _showDrawer = false;
  List<OBD> obds = [];
  List<OBD> obdss= [];
//  late UserDatabase database;
//  late User? user;

  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/log')
    // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;


  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await this.widget.database.obdDAO.retrieveAllOBD();
    //debugPrint("obd diagno " + obds.length.toString());
    setState(()  {},);
    return obds;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      setState(() async {
       obdss = await retrieveOBD(this.widget.database);
       debugPrint("obd car cnx " + obdss.length.toString());
      },);
    },);

    /*debugPrint("user" + this.widget.user!.surName.toString());
    Future.delayed(Duration.zero,() {
      setState(()  {
        final routes =
        ModalRoute
            .of(context)
            ?.settings
            .arguments as Map<String, dynamic>;
        database = routes["database"];
        user = routes["user"];
      },
      );
      },
    );*/

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
          parent: _loadingController!,
          curve: headerAniInterval,
        ));

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }
  void showDrawer() {
    print('tapped on show drawer!');
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {

    final menuBtn = IconButton(
      color:  HexColor("#175989"),// parm color
      icon: const Icon(FontAwesomeIcons.bars),
        onPressed: showDrawer
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color:  HexColor("#175989"),
      onPressed: () => _goToLogin(context),
    );


    final title = Center(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/image/bako.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),

         // const SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      // toolbarTextStyle: TextStle(),
      // textTheme: theme.accentTextTheme,
      // iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {

    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;//3.467
    final accentColor =
        Colors.primaries.where((c) => c == theme.colorScheme.secondary).first;
    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(const Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, //color: accentColor.shade400,

                children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center, //color: accentColor.shade400,
              children: <Widget>[

                Icon(FontAwesomeIcons.chargingStation, color: accentColor.shade400 , size : 32),
                const SizedBox(width: 5),
                AnimatedNumericText(
                  initialValue: 00,
                  targetValue: 80,
                  curve: const Interval(0, .5, curve: Curves.easeOut),
                  controller: _loadingController!,
                  style: theme.textTheme.headline3!.copyWith(
                    foreground: Paint()..shader = linearGradient,
                  ),
                ),
                // Text('Account Balance', style: theme.textTheme.caption),
              ],

            ),
//            Text('Account Balance', style: theme.textTheme.caption),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //color: accentColor.shade400,
            children: <Widget>[
              Icon(FontAwesomeIcons.road , color: accentColor.shade400 , size : 32),
              const SizedBox(width: 5),
              AnimatedNumericText(
                initialValue: 00,
                targetValue: 80,
                curve: const Interval(0, .5, curve: Curves.easeOut),
                controller: _loadingController!,
                style: theme.textTheme.headline3!.copyWith(
                  foreground: Paint()..shader = linearGradient,
                ),
              ),
            ],

          ),
         ]

      ),
      ]
        ),
      ),
    );
  }

  Widget buildhead() {
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    
    return SafeArea(
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
                /*image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(HexColor("#175989"), BlendMode.softLight),
                  image: AssetImage(
                    'assets/image/back.png',
                  ),
                ),*/
                border: Border.all(
                    width: 0.5,
                    color: HexColor("#175989")
                ),

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
                      top: size.width * 0.052,

                    ),
                    child: SizedBox(
                        height: size.width * 0.15,
                        child : Container(
                            decoration: BoxDecoration(


                              border: Border.all(
                                  width: 0.5,
                                  color: HexColor("#175989")
                              ),
                              color:Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(7),
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
                                      height: size.width * 0.18,
                                      width: size.width * 0.1,
                                      child: Container(

                                        child: Icon(
                                          UniconsLine.bluetooth_b,
                                          color:  HexColor("#175989"),
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
                                      child: Text( 'Connected car : bako',
                                        style: GoogleFonts.poppins(
                                          color:    HexColor("#175989"),
                                          fontSize: size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.005,
                                      left : size.width*0.235,
                                    ),

                                  ),
                                ]
                            )
                        )

                    ),),
                  /* */

                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.015,
                      left: size.width * 0.02,
                      bottom: size.height * 0.035,
                    ),
                    child:
                    SizedBox(
                        width: size.width * 0.99,
                        height: size.height * 0.148,
                        child:  information(size, themeData) // information list
                    ),
                  ),
                ],
              ),
            ),
          ),

          //  buildTopBrands(size, themeData),

        ],
      ),
    );

  }

  Widget _buildButton(
      {Widget? icon, String? label, required Interval interval}) {


    Size size = MediaQuery.of(context).size; //check the size of device
    //ThemeData themeData = Theme.of(context);

    return RoundButton(
      size: 72,
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.1),
      ),

      onPressed: () {
        debugPrint("pr " + label!);
        if( label == "Profile"){
          Get.to( profile_page() ,arguments: {"database" : this.widget.database , "user" : this.widget.user});
        }
        if( label == "connexion"){
          Get.to( connexion() ,arguments: {"database" : this.widget.database , "user" : this.widget.user});
        }
        if( label == "Station"){
          Get.to( obd_home( database : this.widget.database , user : this.widget.user) );
        }
        if (label == "Dashboard") {
          //buildCar(1, size, themeData);
          Get.to( speedo() ,arguments: {"database" : this.widget.database , "user" : this.widget.user});
          //Get.to( SpeedometerContainer(),arguments: {"database" : this.widget.database , "user" : this.widget.user});
        }
        if (label == "Maintenance") {
          //buildCar(1, size, themeData);
          Get.to(SettingsScreen(), );
          //Navigator.pushNamed(context , '/cnxobd' , arguments: {"database" : this.database , "user" : this.user});
        }
        if (label == "Settings") {
          //buildCar(1, size, themeData);
          Get.to(realtime_db());
        }
      },
    );
  }


  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 14,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: const Icon(UniconsLine.dashboard),
          label: 'Dashboard',
          interval: const Interval(0, aniInterval),
        ),

        _buildButton(
          icon: const Icon(FontAwesomeIcons.chargingStation),
          label: 'Station',
          interval: const Interval(0, aniInterval),
        ),
        _buildButton(
          icon: const Icon(Icons.car_repair_outlined, size: 20),
          label: 'Maintenance',
          interval: const Interval(step * 6, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Container(
            // fix icon is not centered like others for some reasons
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: const Icon(FontAwesomeIcons.bluetooth, size: 20,),
          ),
          label: 'connexion',
          interval: const Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.user),
          label: 'Profile',
          interval: const Interval(0, aniInterval),
        ),
        _buildButton(
          icon: const Icon(FontAwesomeIcons.slidersH, size: 20),
          label: 'Settings',
          interval: const Interval(step * 2, aniInterval + step * 2),
        ),//Icon( Icons.car_repair_outlined, ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
   // Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    int currIndex;
    return WillPopScope(

      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          //bottomNavigationBar: buildBottomNavBar(1,size ,themeData,context , this.widget.database , this.widget.user),

          appBar: _buildAppBar(theme),
          body:  Container(

            width: double.infinity,
            height: double.infinity,
            //color: const Color(0xfff8f8f8), // background color
             decoration: BoxDecoration(

             image: new DecorationImage(
             fit: BoxFit.cover,

             colorFilter: new ColorFilter.mode(HexColor("#175989"), BlendMode.softLight),
             image: AssetImage(
       'assets/image/back.png',
    ),
    ),),
    child :BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Stack(
              children: <Widget>[
                //kilometrage_data(),
                Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 6,
                      child:
                      buildhead(),
                     // _buildHeader(theme),
                    ),
                   /* Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.3,
                      ),),*/
                  /*  Expanded(
                      flex: 14,
                      child:  kilometrage_data(),
                      //_buildHeader(theme),
                    ),*/
                    const SizedBox(height : 5),
                    Expanded(
                      flex: 6,

                      //child:// ShaderMask(
                        // blendMode: BlendMode.srcOver,
                       /* shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                            colors: <Color>[
                              Colors.white60,
                              Colors.white60,
                              Colors.white60,
                              Colors.white60,

                              HexColor("#175989"),
                              HexColor("#175989"),
                              HexColor("#175989"),
                              //Colors.lightBlue.shade900,

                            ],
                          ).createShader(bounds);
                        },
*/
                        child:

                        _buildDashboardGrid(),
                      ),

                  ],
                ),

                if (_showDrawer)
                  DrawerWidget(
                    closeFunction: showDrawer,
                  ),
              ],
           ),),
          ),
        ),
      ),
    );
  }
}
