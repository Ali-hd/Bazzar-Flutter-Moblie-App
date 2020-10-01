// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    createdAt: json['createdAt'] as String,
    description: json['description'] as String,
    postId: json['postId'] as String,
    updatedAt: json['updatedAt'] as String,
    id: json['_id'] as String,
    user: json['user'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'description': instance.description,
      'postId': instance.postId,
      'updatedAt': instance.updatedAt,
      '_id': instance.id,
      'user': instance.user,
    };
