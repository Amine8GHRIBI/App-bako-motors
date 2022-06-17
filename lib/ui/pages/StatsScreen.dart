import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../DataBase/user_database.dart';
import '../../config/styles.dart';
import '../../data/CarEntity.dart';
import '../../data/OBDParametres.dart';
import '../../data/data.dart';
import '../../data/userEntity.dart';
import '../Constants.dart';
import '../widget/StatsGrid.dart';
import '../widget/covid_bar_chart.dart';
import '../widget/login_widget/fadeIn.dart';
import 'TransitionRouteObserver.dart';

class StatsScreen extends StatefulWidget {
  UserDatabase database;
  User user;
  Car car;

  StatsScreen({Key? key , required this.database, required this.user, required this.car}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin, TransitionRouteAware{

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

  bool _showDrawer = false;
  List<OBD> obds = [];
  List<OBD> obdss= [];
  late UserDatabase database;
  late User user;


  Future<List<OBD>> retrieveOBD(UserDatabase db) async {
    obds =await db.obdDAO.retrieveAllOBD();
    //debugPrint("obd diagno " + obds.length.toString());
    setState(()  {},);
    return obds;
  }

  Future<List<OBD>> retrieveLastOBD(UserDatabase db) async {
    obdss = await db.obdDAO.retrieveLastOBD(widget.car.id!);

    setState(()  {},);
    return obdss;
  }



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async {
      await retrieveLastOBD(widget.database);
      setState(() {
        debugPrint("last obd " + obdss.last.speed.toString());

      });
    });

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
        color: theme.iconTheme.color,// parm color
        icon: const Icon(FontAwesomeIcons.bars),
        onPressed: showDrawer
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.iconTheme.color,
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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Container(
        color: theme.primaryColor,
        child : CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(theme),
          _buildRegionTabBar(theme),
         // _buildStatsTabBar(theme),
         SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(database: widget.database ,user: widget.user ,car : widget.car),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: CovidBarChart(covidCases: covidUSADailyNewCases ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  SliverPadding _buildHeader(ThemeData theme) {
    return const SliverPadding(
      padding: EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
         // obdss.length.toString(),
          "Statistique",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar(ThemeData theme) {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            indicator: const BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor:theme.primaryColor,
            unselectedLabelColor: theme.indicatorColor,
            tabs: const <Widget>[
             Text('Offline'),
              Text('Online'),
            ],
            onTap: (index) async {

            },
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar(ThemeData theme) {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 3,
         child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle: Styles.tabTextStyle,
            labelColor: theme.secondaryHeaderColor,
            unselectedLabelColor: theme.indicatorColor ,
            tabs: const <Widget>[
              Text('Total'),
              Text('Today'),
              Text('Yesterday'),
            ],
            onTap: (index) {},
          ),
        ),
      ),
    );
  }
}
