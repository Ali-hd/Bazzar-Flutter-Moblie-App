import 'package:bazzar/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

class AuthBtns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.only(top: 100),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAuthButton('LOGIN', context),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text('OR')),
                  Expanded(child: Divider())
                ],
              ),
              _buildAuthButton('REGISTER', context),
            ],
          )),
    );
  }

  Widget _buildAuthButton(String type, BuildContext context) {
    return Container(
      width: 220,
      height: 40,
      child: RaisedButton(
        elevation: 5,
        child: Text(
          type,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSans'),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) =>
                  Authenticate(showSignIn: type == 'LOGIN' ? true : false),
            ),
          );
        },
      ),
    );
  }
}
