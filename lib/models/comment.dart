import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String createdAt;
  String description;
  String postId;
  String updatedAt;
  @JsonKey(name: '_id')
  String id;
  Map<String, dynamic> user;

  Comment({
    this.createdAt,
    this.description,
    this.postId,
    this.updatedAt,
    this.id,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
