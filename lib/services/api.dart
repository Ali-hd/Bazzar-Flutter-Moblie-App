import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bazzar/models/models.dart';
import 'package:http/http.dart' as http;

class API {
  static const API_URL = 'https://bazaar-api-v1.herokuapp.com';
  static const headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  final storage = FlutterSecureStorage();

  Future<Map<String, String>> createHeaderAuth() async{
    String token = await storage.read(key: 'token');
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return header;
  }

  Future<User> login(Login values) {
    return http
        .post(
      API_URL + '/auth/login',
      body: json.encode(values.toJson()),
      headers: headers,
    )
        .then((res) async {
      await storage.write(key: 'token', value: jsonDecode(res.body)['token']);
      print(res.statusCode);
      print(jsonDecode(res.body));
      print(jsonDecode(res.body)['token']);
    }).catchError((err) => print(err));
  }

  Future<User> register(Register values) {
    return http
        .post(
      API_URL + '/auth/register',
      body: json.encode(values.toJson()),
      headers: headers,
    )
        .then((res) {
      print(res.statusCode);
      print(jsonDecode(res.body));
    }).catchError((err) => print(err));
  }

  Future getPosts(String city, int page, String time) {
    print('/post?page=$page&limit=16&city=${city.toLowerCase()}&time=$time');
    return http.get(
        API_URL +
            '/post?page=$page&limit=16&city=${city.toLowerCase()}&time=$time',
        headers: headers);
  }

  Future getSinglePost(String id) {
    print('api get single post');
    return http.get(API_URL + '/post/$id');
  }

  Future getAccount() async {
    Map<String, String> headerAuth = await createHeaderAuth();
    return http.get(API_URL + '/auth/user', headers: headerAuth);
  }

  Future handleSearch(String text, String city, String time) {
    return http.post(
      API_URL + '/post/search?city=${city.toLowerCase()}&time=$time',
      headers: headers,
      body: jsonEncode(<String, String>{
      'search': text,
    }),
    );
  }

  Future postComment(String text, String postId) async{
    Map<String, String> headerAuth = await createHeaderAuth();
    return http.post(
      API_URL + '/post/$postId/comment',
      headers: headerAuth,
      body: jsonEncode(<String, String>{
      'description': text,
    }),
    );
  }

  Future getUser(String username){
    // to get email of user pass auth token
    return http.get(API_URL + '/user/$username', headers: headers);
  }

  Future likePost(String postId) async {
    Map<String, String> headerAuth = await createHeaderAuth();
    return http.post(
      API_URL + '/post/$postId/like',
      headers: headerAuth,
    );
  }
}
