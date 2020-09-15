import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bazzar/services/api.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _account;
  Map<String, dynamic> get getAccount => _account;
  bool loading = false;

  Future fetchAccout(){
    setLoading(true);
    print('getting account');
    API().getAccount().then((res){
      if (res.statusCode == 200) {
        setLoading(false);
        setAccount(jsonDecode(res.body)['account']);
      }
    }).catchError((err){
      print('error getting account $err');
      setLoading(false);
      notifyListeners();
    });
  }
  
  setAccount(Map<String, dynamic> value){
    _account = value;
    notifyListeners();
  }

  setLoading(value){
    loading = value;
  }
}