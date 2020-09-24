import 'dart:convert';
import 'package:bazzar/models/models.dart';
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
      setLoading(false);
      notifyListeners();
    }).catchError((err){
      print('error getting user $err');
      setLoading(false);
      notifyListeners();
    });
  }

  Future editProfile(String username, EditProfile data){
    setLoading(true);
    API().editProfile(username, data).then((res){
      print(res.statusCode);
      print(jsonDecode(res.body));
      if(res.statusCode == 200){
        // merge new details with present.
        print('merge coin');
        Map<String, dynamic> copyUser = _user..addAll(data.toJson());
        _user = copyUser;
        setLoading(false);
        notifyListeners();
      }
      return true;
    }).catchError((err){
      setLoading(false);
      notifyListeners();
      return false;
    });
  }

  handlePostLike(String likeType, String postId){
    // Map<String, dynamic> accountCopy = _account;
    if(likeType == 'liked'){
      _account['liked'].add(postId);
    }else if(likeType == 'unliked'){
      _account['liked'].removeWhere((post) => post == postId);
    }
    print('account from provider $_account');
    notifyListeners();
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