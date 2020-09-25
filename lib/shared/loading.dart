import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;

  const Loading({Key key, @required this.backgroundColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size: 50,
        ),
      ),
    );
  }
}