import 'dart:convert';
import 'package:bazzar/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:bazzar/services/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic> _account;
  Map<String, dynamic> get getAccount => _account;
  Map<String, dynamic> _user;
  Map<String, dynamic> get getUser => _user;
  bool loading = false;
  bool authLoading = false;
  final _storage = FlutterSecureStorage();
  
  Future handleLogin(Login values) async{
    setAuthLoading(true);
    dynamic response = await API().login(values);
    await _storage.write(key: 'token', value: jsonDecode(response.body)['token']);
    // await fetchAccout();
    // await fetchUser(values.username);
    setAuthLoading(false);
    notifyListeners();
    return 'Signed in';
  }

  Future handleRegister(Register values) async{
    setAuthLoading(true);
    notifyListeners();
    dynamic response = await API().register(values);
    if(jsonDecode(response.body)['msg'] == 'created successfully'){
      final data = Login(username: values.username, password: values.password);
      await handleLogin(data);
    }
    // await _storage.write(key: 'token', value: jsonDecode(response.body)['token']);
    // await fetchAccout();
    setAuthLoading(false);
    return 'success';
  }
  

  Future fetchAccout() {
    setLoading(true);
    print('getting account');
    API().getAccount().then((res) {
      if (res.statusCode == 200) {
        setAccount(jsonDecode(res.body)['account']);
        setLoading(false);
        notifyListeners();
      }
    }).catchError((err) {
      print('error getting account $err');
      setLoading(false);
      notifyListeners();
    });
  }

  Future fetchUser(String username) async {
    setLoading(true);
    print('getting user');
    try{  
      dynamic res = await API().getUser(username);
      print(res.body);
      setUser(jsonDecode(res.body)['user']);
      setLoading(false);
      notifyListeners();
      return jsonDecode(res.body);
    }catch(err){
      print('error getting user $err');
      setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future editProfile(String username, EditProfile data) {
    setLoading(true);
    API().editProfile(username, data).then((res) {
      print(res.statusCode);
      print(jsonDecode(res.body));
      if (res.statusCode == 200) {
        // merge new details with present.
        print('merge coin');
        // firstname cant be merged with firstName
        Map<String, dynamic> copyUser = _user..addAll(data.toJson());
        _user = copyUser;
        copyUser['firstName'] = data.firstname;
        setLoading(false);
        notifyListeners();
      }
      return true;
    }).catchError((err) {
      setLoading(false);
      notifyListeners();
      return false;
    });
  }

  handleLogOut(){
    _user = null;
    _account = null;
    notifyListeners();
  }

  handlePostLike(String likeType, String postId) {
    // Map<String, dynamic> accountCopy = _account;
    if (likeType == 'liked') {
      _account['liked'].add(postId);
    } else if (likeType == 'unliked') {
      _account['liked'].removeWhere((post) => post == postId);
    }
    print('account from provider $_account');
    notifyListeners();
  }

  setAccount(Map<String, dynamic> value) {
    _account = value;
  }

  setUser(Map<String, dynamic> value) {
    _user = value;
  }

  setLoading(value) {
    loading = value;
  }

  setAuthLoading(value){
    authLoading = value;
  }
}
