import 'package:flutter/material.dart';

class Login {
  String username;
  String password;
  bool rememberMe;

  Login({
    @required this.username,
    @required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson(){
    return {
      "email": username,
      "password": password,
    };
  }
}

class Register {
  String username;
  String password;
  String email;

  Register({
    @required this.username,
    @required this.email,
    @required this.password,
  });

  Map<String, dynamic> toJson(){
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }
}
