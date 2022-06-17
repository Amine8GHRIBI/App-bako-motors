import 'package:app_settings/app_settings.dart';
import
'package:flutter/material.dart';
import 'package:mini_project/ui/pages/profile_page.dart';

import 'drawer_collapse.dart';
import 'drawer_item.dart';
import 'drawer_user.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key, required this.closeFunction}) : super(key: key);
  final Function closeFunction;

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  late double height;
  late double width;
  double backgroundOpacity = 0;
  bool isCollapsed = true;
  bool isCollapsedAfterSec = true;

  void initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
    startAnimation();
  }

  void startAnimation() {
    _controller.forward();
    _animation.addListener(() {
      setState(() {
        backgroundOpacity = 0.7 * _animation.value;
      });
    });
  }

  void stopAnimation() {
    _controller.stop();
  }

  void reverseAnimation() {
    _controller.reverse();
  }

  void onCollapseTap() {
    if (isCollapsed) {
      Future.delayed(const Duration(
        milliseconds: 70,
      )).then((value) {
        setState(() {
          isCollapsedAfterSec = !isCollapsedAfterSec;
        });
      });
    } else if (!isCollapsed) {
      setState(() {
        isCollapsedAfterSec = !isCollapsedAfterSec;
      });
    }
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size; //check the size of device
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white12,
      body: Row(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (ctx, child) {
              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 70,
                ),
                width: (isCollapsed)
                    ? width * .2 * _animation.value
                    : width * .5 * _animation.value,
                margin: EdgeInsets.only(
                  left: width * .04 * _animation.value,
                  top: height * .04,
                  bottom: height * .04,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: (_animation.value > 0.7)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 23,
                          ),
                          DrawerUser(
                            theme : theme,
                            afterCollapse: 'PR',
                            beforeCollapse: 'Parametres',
                            isCollapsed: isCollapsed,
                          ),

                          DrawerItem(
                            icon:IconButton(
                                icon: Icon(Icons.account_circle_rounded,color:  theme.iconTheme.color,
                                  size: 20,),
//                  tooltip: "Admin",
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const profile_page()));                                }),

                            label: const Text(
                              'Profile         ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,

                              ),
                            ),
                            isCollapsed: isCollapsedAfterSec,
                          ),
                          DrawerItem(
                            icon:IconButton(
                                icon: Icon(Icons.bluetooth_connected,color: theme.iconTheme.color,
                                  size: 20,),
//                  tooltip: "Admin",
                                onPressed: () {
                                  Navigator.pushNamed(context , '/conn');
                                }),

                            label: const Text(
                              'connexion',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            isCollapsed: isCollapsedAfterSec,
                          ),

                          DrawerItem(
                            icon:IconButton(
                                icon: Icon(Icons.ev_station,color: theme.iconTheme.color,
                                  size: 20,),
//                  tooltip: "Admin",
                                onPressed: () {
                                  AppSettings.openBluetoothSettings();
                                }),

                            label: Text(
                              'station      ',
                              style: TextStyle(
                                color: theme.iconTheme.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            isCollapsed: isCollapsedAfterSec,
                          ),
                          DrawerItem(
                            icon:IconButton(
                                icon: Icon(Icons.wifi
                                  ,color: theme.iconTheme.color,
                                  size: 20,),
//                  tooltip: "Admin",
                                onPressed: () {
                                  AppSettings.openWIFISettings();
                                }),

                            label: Text(
                              'WIFI',
                              style: TextStyle(
                                color: theme.iconTheme.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            isCollapsed: isCollapsedAfterSec,
                          ),

                          DrawerItem(

                            icon:IconButton(
                                icon: const Icon(Icons.logout),
//                  tooltip: "Admin",
                                onPressed: () {
                                  Navigator.pushNamed(context , '/conn');
                                }),
                            label: Text(
                              'DECONNEXION',
                              style: TextStyle(
                                color: theme.iconTheme.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            isCollapsed: isCollapsedAfterSec,
                          ),
                          const Spacer(),
                          // * Bottom Toggle Button
                          if (_controller.value >= 1)
                            DrawerCollapse(
                              isCollapsed: isCollapsed,
                              onTap: onCollapseTap,
                            ),
                        ],
                      )
                    : const SizedBox(),
              );
            },
          ),

          // * The left area on the side which will used
          // * to close the drawer when tapped

          Expanded(
            flex: 3,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  reverseAnimation();
                  Future.delayed(
                    const Duration(
                      milliseconds: 500,
                    ),
                  ).then(
                    (value) => widget.closeFunction(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
