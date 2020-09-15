import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:bazzar/services/api.dart';

class PostProvider with ChangeNotifier {
  Map<String, dynamic> _posts;
  Map<String, dynamic> get getPosts => _posts;
  List _postResults;
  List get getPostsResults => _postResults;
  Map<String, dynamic> _singlePost;
  Map<String, dynamic> get getSinglePost => _singlePost;
  bool loading = false;
  bool spLoading = false;
  bool get getLoading => loading;
  String _currentCity = 'All';
  String get getCurrentCity => _currentCity;
  int _currentPage = 1;

  Future fetchPosts() {
    setLoading(true);
    print('helllooo');
    API().getPosts(_currentCity, _currentPage).then((res) {
      if (res.statusCode == 200) {
        if (_posts == null || _currentPage == 1) {
          setPosts(jsonDecode(res.body), false);
        } else if (_currentPage > 1) {
          // merge old posts with new posts
          setPosts(jsonDecode(res.body), true);
        }
      } else {
        print(res.statusCode);
      }
      setLoading(false);
    }).catchError((err) {
      print('error getting posts $err');
    });
  }

  Future fetchSinglePost(String id) {
    setSPLoading(true);
    print('getting single post');
    API().getSinglePost(id).then((res) {
      setSinglePost(jsonDecode(res.body)['post']);
      print('status code 200:=> ${jsonDecode(res.body)}');
      setSPLoading(false);
    }).catchError((err) {
      print('error getting single post: $err');
    });
  }

  void setCurrentCity(String value) {
    _currentCity = value;
    _currentPage = 1;
    fetchPosts();
    notifyListeners();
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

  void setSPLoading(bool value) {
    spLoading = value;
  }

  void setPosts(value, bool merge) {
    _posts = value;
    if (!merge) {
      _postResults = value['results'];
    } else {
      _postResults = [..._postResults, ...value['results']];
      print(_postResults);
    }
    notifyListeners();
  }

  void setSinglePost(value) {
    _singlePost = value;
    notifyListeners();
  }
}
