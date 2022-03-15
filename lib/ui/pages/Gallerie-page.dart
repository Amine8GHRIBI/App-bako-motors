import 'package:flutter/material.dart';

class GalleriePage extends StatelessWidget {
  const GalleriePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallerie'),),
      body: Center(
        child: Text("Gallerie page ",style: Theme.of(context).textTheme.headline3,),
      ),
    );
  }
}
