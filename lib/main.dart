import 'package:bazzar/screens/authenticate/authenticate.dart';
import 'package:bazzar/screens/home.dart';
import 'package:bazzar/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:bazzar/Providers/providers.dart';
import 'bottom_nav_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  String token;
  Map<String, dynamic> decodedToken;
    Future<bool> _checktoken() async {
      final storage = FlutterSecureStorage();
      token = await storage.read(key: 'token');
      decodedToken = JwtDecoder.decode(token);
      final bool isExpired = JwtDecoder.isExpired(token);
      print('token= $token');
      print('token is expired $isExpired');
      return isExpired;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SinglePostProvider(),
        )
      ],
      child: MaterialApp(
        home: FutureBuilder(
          future: _checktoken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //is expired = true
              if (snapshot.data) {
                return Authenticate();
              } else {
                return BottomNavigationBarController();
              }
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }
}
