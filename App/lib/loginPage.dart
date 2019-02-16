import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginPage extends StatefulWidget{
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          String user = await widget.auth.signInWithEmailAndPassword(_email, _password);
        }
        else{
          String user = await widget.auth.createUserWIthEmailAndPassword(_email, _password); 
        }
        widget.onSignedIn();
      }
      catch(e){
        print(e);
      }

    }
  }

  void googleLogin() async{
    String user = await widget.auth.signInWithGoogle();
    widget.onSignedIn();
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
        });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
          _formType = FormType.login;
        });
  }
  
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons() + googleButton(),
          ),
        )
      ),
      resizeToAvoidBottomPadding: false,
    );
    
  }

  List<Widget> buildInputs(){
    return[
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty': null ,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty': null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
      return[
        new RaisedButton(
          child: new Text('login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create Account', style: TextStyle( fontSize: 20.0)),
          onPressed: moveToRegister,
        )
      ];
    }
    else{
      return[
        new RaisedButton(
          child: new Text('Create account', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Already have an account?', style: TextStyle( fontSize: 20.0)),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  List<Widget> googleButton(){
    return [
      FlatButton(
        child: Text("Sign in with Google", style: TextStyle( fontSize: 20.0)),
        onPressed: googleLogin,
      ),
    ];
  }
}