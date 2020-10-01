import 'package:json_annotation/json_annotation.dart';
import 'package:bazzar/models/models.dart';

part 'post.g.dart';
@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: '_id')
  String id;
  bool approved;
  List bids;
  List<Comment> comments;
  String createdAt;
  String description;
  List<String> images;
  int likes;
  String location;
  bool open;
  String price;
  String startBid;
  String title;
  String updatedAt;
  User user;
  int views;

  Post({
    this.id,
    this.approved,
    this.bids,
    this.comments,
    this.createdAt,
    this.description,
    this.images,
    this.likes,
    this.location,
    this.open,
    this.price,
    this.startBid,
    this.title,
    this.updatedAt,
    this.user,
    this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

class SellPost {
  String title;
  String description;
  String location;
  List<String> images;

  SellPost({
    this.title,
    this.description,
    this.location,
    this.images
  });

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "description": description,
      "location": location,
      "images": images
    };
  }
}