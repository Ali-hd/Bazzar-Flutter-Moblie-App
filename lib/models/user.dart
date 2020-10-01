import 'package:json_annotation/json_annotation.dart';
import 'post.dart';

part 'user.g.dart';
@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
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
  List<Post> posts;
  List<Post> liked;
  List<String> conversations;
  List ratings;
  List rated;
  List notifications;
  String updatedAt;
  String createdAt;

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
    this.posts,
    this.liked,
    this.conversations,
    this.ratings,
    this.rated,
    this.notifications,
    this.updatedAt,
    this.createdAt
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}



class EditProfile {
  String firstname;
  String description;
  String location;
  String profileImg;

  EditProfile({
    this.firstname,
    this.description,
    this.location,
    this.profileImg
  });

  Map<String, dynamic> toJson(){
    return {
      "firstname": firstname,
      "description": description,
      "location": location,
      "profileImg": profileImg
    };
  }
}

class ReviewUser {
  double star;
  String description;

  ReviewUser({
    this.star,
    this.description
  });

  Map<String, dynamic> toJson(){
    return {
      "star": star,
      "description": description
    };
  }
}
