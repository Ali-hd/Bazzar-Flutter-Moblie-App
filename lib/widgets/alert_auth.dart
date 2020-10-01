import 'package:bazzar/screens/profile.dart';
import 'package:flutter/material.dart';

class AlertAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: ,
      content: Text('Please Sign In to use this feature'),
      actions: [
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Sign In"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                    username: 'Please login',
                    profileImg: 'https://i.imgur.com/iV7Sdgm.jpg',
                    heroIndex: 'user_profile'),
              ),
            ).then((result) {
              Navigator.of(context).pop();
            });
          },
        ),
      ],
    );
  }
}
