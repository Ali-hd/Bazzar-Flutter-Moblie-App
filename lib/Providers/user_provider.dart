import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bazzar/services/api.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _account;
  Map<String, dynamic> get getAccount => _account;
  Map<String, dynamic> _user;
  Map<String, dynamic> get getUser => _user;
  bool loading = false;

  Future fetchAccout(){
    setLoading(true);
    print('getting account');
    API().getAccount().then((res){
      if (res.statusCode == 200) {
        setAccount(jsonDecode(res.body)['account']);
        setLoading(false);
        notifyListeners();
      }
    }).catchError((err){
      print('error getting account $err');
      setLoading(false);
      notifyListeners();
    });
  }

  Future fetchUser(String username){
    setLoading(true);
    print('getting user');
    API().getUser(username).then((res){
      setUser(jsonDecode(res.body)['user']);
      print(jsonDecode(res.body)['user']);
      setLoading(false);
      notifyListeners();
    }).catchError((err){
      print('error getting user $err');
      setLoading(false);
      notifyListeners();
    });
  }
  
  setAccount(Map<String, dynamic> value){
    _account = value;
  }

  setUser(Map<String, dynamic> value){
    _user = value;
  }

  setLoading(value){
    loading = value;
  }
}