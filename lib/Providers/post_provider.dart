import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bazzar/services/api.dart';
import 'package:bazzar/models/models.dart';

class PostProvider with ChangeNotifier {
  Map<String, dynamic> _posts;
  Map<String, dynamic> get getPosts => _posts;
  List<Post> _postResults = [];
  List<Post> get getPostsResults => _postResults;
  bool loading = false;
  bool searchLoading = false;
  bool get getLoading => loading;
  String _currentCity = 'All';
  String get getCurrentCity => _currentCity;
  int _currentPage = 1;
  String time = 'a-t';

  Future<bool> fetchPosts() {
    setLoading(true);
    // notifyListeners();
    // when set state as soon as I load it creates an error
    API().getPosts(_currentCity, _currentPage, time).then((res) {
      if (res.statusCode == 200) {
        setLoading(false);
        if (_posts == null || _currentPage == 1) {
          setPosts(res.body, false);
        } else if (_currentPage > 1) {
          // merge old posts with new posts
          setPosts(res.body, true);
        }
      } else {
        print(res.statusCode);
      }
      return true;
    }).catchError((err) {
      print('error getting posts $err');
      setLoading(false);
      notifyListeners();
      return true;
    });
  }

  Future searchPosts(String text) {
    setSearchLoading(true);
    notifyListeners();
    API().handleSearch(text, _currentCity, time).then((res) {
      if (_posts == null || _currentPage == 1) {
        setPosts(jsonDecode(res.body), false);
      } else if (_currentPage > 1) {
        // merge old posts with new posts
        setPosts(jsonDecode(res.body), true);
      }
      setSearchLoading(false);
    }).catchError((err) {
      print('error getting posts $err');
      setSearchLoading(false);
    });
  }

  void setCurrentCity(String value) {
    _currentCity = value;
    _currentPage = 1;
    fetchPosts();
    notifyListeners();
  }

  void setTime(String value) {
    String type;
    switch (value) {
      case 'All Time':
          type = 'a-t';
        break;
      case 'Past month':
          type = 'l-m';
        break;
      case 'Past week':
           type = 'l-w';
        break;
      case 'Past 24 hours':
           type = 'l-d';
        break;
      default:
          type = time;
        break;
    }
    if (time != type) {
      time = type;
      _currentPage = 1;
      fetchPosts();
      notifyListeners();
    }
  }

  void loadMore() {
    if (_posts['next'] != null) {
      _currentPage++;
      fetchPosts();
    }
  }

  void setLoading(bool value) {
    loading = value;
  }

  void setSearchLoading(bool value) {
    searchLoading = value;
  }

  void setPosts(value, bool merge) {
    _posts = jsonDecode(value);
    List<dynamic> data = _posts['results'];
    List<Post> results = data.map((post)=>Post.fromJson(post)).toList();
    if (!merge) {
      _postResults = results;
    } else {
      _postResults = [..._postResults, ...results];
      print(_postResults);
    }
    notifyListeners();
  }
}
