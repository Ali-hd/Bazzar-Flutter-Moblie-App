import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  Map user;
  bool loading = false;

}