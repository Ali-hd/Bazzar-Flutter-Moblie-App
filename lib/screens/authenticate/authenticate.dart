import 'package:flutter/material.dart';
import 'package:bazzar/screens/authenticate/login_screen.dart';
import 'package:bazzar/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  final bool showSignIn;
  const Authenticate({Key key, this.showSignIn}) : super(key: key);
  
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  void initState() {
    super.initState();
    showSignIn = widget.showSignIn;
  }

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