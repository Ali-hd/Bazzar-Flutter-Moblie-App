import 'package:flutter/cupertino.dart';

class User {
  String id;
  String username;
  String firstName;
  String lastName;
  String email;
  String password;
  String description;
  String profileImg;
  String phoneNumber;
  String location;
  bool admin;
  List<String> following;
  List<String> posts;
  List<String> comments;
  List<String> liked;
  List<String> conversations;
  List ratings;
  List rated;
  List notifications;
  bool success;

  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.description,
    this.profileImg,
    this.phoneNumber,
    this.location,
    this.admin,
    this.following,
    this.posts,
    this.comments,
    this.liked,
    this.conversations,
    this.ratings,
    this.rated,
    this.notifications,
    this.success
  });
}

// factory User.fromJson(Map<String, dynamic> jsonData) {
//     Map<String, dynamic> map = {
//       ...jsonData, // add all of jsonData key-value pairs to the map
//       'id': jsonData['_id'], // assign the value of _id to id
//       '_id': null, // replace _id value with null
//     };
//     return serializers.deserializeWith(User.serializer, map);
//   }