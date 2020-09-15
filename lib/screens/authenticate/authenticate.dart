import 'package:flutter/material.dart';
import 'package:bazzar/screens/authenticate/login_screen.dart';
import 'package:bazzar/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

   bool showSignIn = true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return LoginScreen(toggleView: toggleView);
    }else {
      return RegisterScreen(toggleView: toggleView);
    }
  }
}