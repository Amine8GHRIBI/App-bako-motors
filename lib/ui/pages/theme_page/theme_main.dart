import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_project/ui/pages/theme_page/materialexample.dart';

import 'CupertinoExample.dart';

class theme_main extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const theme_main({Key? key , this.savedThemeMode}) : super(key: key);

  @override
  State<theme_main> createState() => _theme_mainState();
}

class _theme_mainState extends State<theme_main> {
  bool isMaterial = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: isMaterial
          ? MaterialExample(
          savedThemeMode: widget.savedThemeMode,
          onChanged: () => setState(() => isMaterial = false))
          : CupertinoExample(
          savedThemeMode: widget.savedThemeMode,
          onChanged: () => setState(() => isMaterial = true)),
    );
  }
}
