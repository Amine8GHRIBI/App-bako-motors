import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import '../../DataBase/user_database.dart';
import '../../data/stathome.dart';
import '../../data/userEntity.dart';
import '../Constants.dart';
import '../widget/bottom_nav_item.dart';
import '../widget/homePage/homePage/information.dart';
import '../widget/login_widget/AnimatedNumericText.dart';
import '../widget/login_widget/fadeIn.dart';
import '../widget/login_widget/roundButton.dart';
import 'TransitionRouteObserver.dart';

class car_page extends StatefulWidget {
  static const routeName = '/dashboard';

  const car_page({Key? key}) : super(key: key);

  @override
  State<car_page> createState() => _car_pageState();
}

class _car_pageState extends State<car_page>  with SingleTickerProviderStateMixin, TransitionRouteAware {

  late UserDatabase database;
  User? user;



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

  @override
  void initState() {
    super.initState();

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

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: Colors.indigo,// parm
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.colorScheme.secondary,
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
                                          UniconsLine.bluetooth_b,
                                          color: const Color(0xff3b22a1),
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
                                      child: Text( 'Connected car : bako  ',
                                        style: GoogleFonts.poppins(
                                          color:   Colors.deepPurple.shade700,

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
                                    /* child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const obd_home()),
                                        );

                                      },

                                      child: const Text('connexion'),
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color(0xff3b22a1),
                                          fixedSize: const Size(120, 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50))),
                                    ),*/

                                  ),
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

          //  buildTopBrands(size, themeData),
          // buildMostRented(size, themeData),

          //buildTopBrands(size, themeData),
          //buildMostRented(size, themeData),
        ],
      ),
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
    Size size = MediaQuery.of(context).size; //check the size of device
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
      },
    );
  }



  Widget _buildDashboardGrid() {
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
           ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData themeData = Theme.of(context);
    int currIndex;
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    database = routes["database"];
    user =routes["user"];

    return WillPopScope(

      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar( //bottomNavigationBar
            iconSize: size.width * 0.07,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontSize: 0),
            unselectedLabelStyle: const TextStyle(fontSize: 0),
            currentIndex: currIndex = 0,
            backgroundColor: theme.primaryColor.withOpacity(.08),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: themeData.brightness == Brightness.dark
                ? Colors.indigoAccent
                : Colors.black,
            unselectedItemColor: const Color(0xff3b22a1),
            onTap: (value) {
              switch (value) {
                case 0:
                //Navigator.pushNamed(context , '/users');
                  Navigator.pushNamed(context , '/dashboard',arguments: {"database" : this.database , "user" : this.user});
                  break;
                case 1:
                  Navigator.pushNamed(context , '/dashboard',arguments: {"database" : this.database , "user" : this.user});
                  break;
                case 2:
                  Navigator.pushNamed(context , '/bleu');
                  break;

                case 3:
                  Navigator.pushNamed(context , '/dash');
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
                UniconsLine.apps,
                themeData,
                size,
              ),
              buildBottomNavItem(
                FontAwesomeIcons.carAlt,
                themeData,
                size,
              ),
              buildBottomNavItem(
                FontAwesomeIcons.map,
                themeData,
                size,
              ),
              buildBottomNavItem(
                FontAwesomeIcons.bell,
                themeData,
                size,
              ),
            ],
          ),
          appBar: _buildAppBar(theme),
          body:  Container(

            width: double.infinity,
            height: double.infinity,
            color: const Color(0xfff8f8f8), // background color

            child: Stack(

              children: <Widget>[
                //kilometrage_data(),
                Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 4,
                      child:
                      //buildhead(),
                      _buildHeader(theme),
                    ),
                    /* Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.3,
                      ),),*/
                     Expanded(
                      flex: 8,
                      child:  kilometrage_data(),
                      //_buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      child:  kilometrage_data(),
                      //_buildHeader(theme),
                    ),

                  ],
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}

