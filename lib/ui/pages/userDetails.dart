import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../DataBase/user_database.dart';
import '../../data/userEntity.dart';
import '../widget/profile-widget/appbar_widget.dart';
import '../widget/profile-widget/button_widget.dart';
import '../widget/profile-widget/numbers_widget.dart';
import '../widget/profile-widget/profile_widget.dart';

class userDetails extends StatefulWidget {
  const userDetails({Key? key}) : super(key: key);

  @override
  State<userDetails> createState() => _userDetailsState();

}

class _userDetailsState extends State<userDetails> {
  late UserDatabase database;
  late User user;


  @override
  Widget build(BuildContext context ) {
    final routes =
    ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, dynamic>;
    user = routes["user"];

    return Scaffold(
          //appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [

              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              Center(child: buildUpgradeButton()),
              const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(user),
            ],
          ),
        );
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.name.toString(),
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {},
  );

  Widget buildAbout(User user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user.birthday,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );

}
