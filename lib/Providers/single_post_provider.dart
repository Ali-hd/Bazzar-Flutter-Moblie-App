import 'dart:convert';
import 'package:bazzar/services/api.dart';
import 'package:flutter/foundation.dart';

class SinglePostProvider with ChangeNotifier {
  Map<String, dynamic> _singlePost;
  Map<String, dynamic> get getSinglePost => _singlePost;
  bool spLoading = false;

  Future fetchSinglePost(String id) {
    setSPLoading(true);
    print('getting single post');
    API().getSinglePost(id).then((res) {
      setSinglePost(jsonDecode(res.body)['post']);
      print('status code 200:=> ${jsonDecode(res.body)}');
      setSPLoading(false);
    }).catchError((err) {
      print('error getting single post: $err');
      setSPLoading(false);
    });
  }

  Future comment(String text, String postId) {
    API().postComment(text, postId).then((res) async {
      print('comment posted');
      print(res.body);
      await fetchSinglePost(postId);
    }).catchError((err) {
      print('error posting comment $err');
    });
  }

  Future handleLike(String postId) async {
    try {
      dynamic response = await API().likePost(postId);
      String type = jsonDecode(response.body)['msg'];
      Map<String, dynamic> postCopy = _singlePost;
      print('res of liked = $type');
      if (type == "liked") {
        postCopy['likes']++;
      } else {
        postCopy['likes']--;
      }
      notifyListeners();
      return type;
    } catch (err) {
      print('error liking post $err');
      return 'error';
    }
  }

  void setSPLoading(bool value) {
    spLoading = value;
    notifyListeners();
  }

  void setSinglePost(value) {
    _singlePost = value;
  }
}
