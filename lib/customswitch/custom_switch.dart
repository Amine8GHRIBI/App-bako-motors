import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({Key? key}) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  final double _switchWidth = 120.0;
  final double _switchHeight = 50.0;

  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Duration _animationDurationThumb = const Duration(milliseconds: 100);

  bool _isNight = true;

  void _onTapSwitch() {
    setState(() {
      _isNight = !_isNight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(child: AnimatedOpacity(
          opacity: _isNight ? 0 : 1,
          duration: _animationDuration,
          child: Container(
            color: Colors.black,
          ),
        )),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: _onTapSwitch,
                child: SizedBox(
                  width: _switchWidth,
                  height: _switchHeight,
                  child: Stack(
                    children: [
                      //night background
                      AnimatedPositioned(
                        duration: _animationDuration,
                        width: _isNight ? _switchWidth : 0,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: _switchWidth,
                          height: _switchHeight,
                          child: Ink.image(
                            image: const AssetImage(
                                'lib/customswitch/images/night_background.png'),
                            fit: BoxFit.cover,
                          ),
                          decoration: const BoxDecoration(),
                        ),
                      ),
                      //moon
                      AnimatedPositioned(
                        duration: _animationDuration,
                        top: 0,
                        bottom: 0,
                        left: _isNight ? 0 : (_switchWidth - _switchHeight),
                        child: AnimatedOpacity(
                          opacity: _isNight ? 1 : 0,
                          duration: _animationDurationThumb,
                          child: Container(
                            child:
                                Image.asset('lib/customswitch/images/moon.png'),
                          ),
                        ),
                      ),

                      //Day Background
                      AnimatedPositioned(
                        duration: _animationDuration,
                        width: _isNight ? 0 : _switchWidth,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: _switchWidth,
                          height: _switchHeight,
                          child: Ink.image(
                            image: const AssetImage(
                                'lib/customswitch/images/day_background.png'),
                            fit: BoxFit.cover,
                          ),
                          decoration: const BoxDecoration(),
                        ),
                      ),

                      //sun
                      AnimatedPositioned(
                        duration: _animationDuration,
                        top: 0,
                        bottom: 0,
                        left: _isNight ? 0 : (_switchWidth - _switchHeight),
                        child: AnimatedOpacity(
                          opacity: _isNight ? 0 : 1,
                          duration: _animationDurationThumb,
                          child: Container(
                            child:
                                Image.asset('lib/customswitch/images/sun.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
