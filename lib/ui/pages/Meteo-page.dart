import 'package:flutter/material.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({Key? key}) : super(key: key);

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  int counter = 0;

  void initState(){
    super.initState();
    print("initialisation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Méteo Page'),),
      body: Column(
        children: [
          Center(
            child :Text("Counter Value ${counter} ",
             style: TextStyle(fontSize: 22 ),),
    ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),

              child: RaisedButton(
                child: Text('Incrementer' , style: TextStyle(color: Colors.white),),
                color: Colors.deepOrange,
                //shape : CircleBorder(),

                onPressed: (){
                  setState(() {
                    ++counter;
                  });
              },
              ),
          )
        ],

      ),
    );
  }
}
