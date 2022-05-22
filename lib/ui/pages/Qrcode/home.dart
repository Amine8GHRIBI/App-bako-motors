import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/ui/pages/Qrcode/scanpage.dart';

import 'generatepage.dart';

class HomePage extends StatefulWidget {

  ThemeData? theme;
  HomePage({Key? key,required this.theme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor :this.widget.theme?.cardTheme.color,
      appBar: AppBar(
        title: Text(
          'QR Code',
          style: TextStyle(color: this.widget.theme?.iconTheme.color),
        ),
        backgroundColor: this.widget.theme?.cardColor,
        iconTheme: IconThemeData(color: this.widget.theme?.iconTheme.color),
      ),
      body: Container(

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              child: new Image.asset(
                'assets/images/qrcode.png',
                //height: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            flatButton("Scan QR CODE", ScanPage()),
            SizedBox(height: 20.0,),
            flatButton("Generate QR CODE", GeneratePage()),
          ],
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return FlatButton(
      padding: EdgeInsets.all(15.0),
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: this.widget.theme?.iconTheme.color,fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: (this.widget.theme?.iconTheme.color)! , width: 3.0),
          borderRadius: BorderRadius.circular(20.0)),
    );
  }
}
