import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'auth.dart';
import 'home.dart';

class Choose extends StatefulWidget{
  Choose({this.choice});
  final Type choice;

  @override
  State<StatefulWidget> createState() => ChooseState();

}

class ChooseState extends State<Choose>{

  Widget build(BuildContext context){
    return(
      Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              
            )
          ],
          )
          ,
      )
    );
  }
}