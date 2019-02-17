import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'auth.dart';
import 'home.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;



  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

enum Market{
  unset,
  nanny,
  toddler
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  Market choice = Market.unset;

    void initState() {
      super.initState();
      widget.auth.currentUser().then((userId){
        setState(() {
           authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;       
        });
      });
    }
  
  void _signedIn(){
    setState((){
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState((){
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context){
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return LoginPage(auth:  Auth(), onSignedIn: _signedIn,);
      case AuthStatus.signedIn:
        return HomePage(auth: Auth(), onSignedOut: _signedOut, choice: choice);
    }
  }

}