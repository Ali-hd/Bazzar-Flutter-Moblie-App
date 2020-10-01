// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String,
    username: json['username'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    description: json['description'] as String,
    profileImg: json['profileImg'] as String,
    phoneNumber: json['phoneNumber'] as String,
    location: json['location'] as String,
    admin: json['admin'] as bool,
    posts: (json['posts'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    liked: (json['liked'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    conversations:
        (json['conversations'] as List)?.map((e) => e as String)?.toList(),
    ratings: json['ratings'] as List,
    rated: json['rated'] as List,
    notifications: json['notifications'] as List,
    updatedAt: json['updatedAt'] as String,
    createdAt: json['createdAt'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'description': instance.description,
      'profileImg': instance.profileImg,
      'phoneNumber': instance.phoneNumber,
      'location': instance.location,
      'admin': instance.admin,
      'posts': instance.posts?.map((e) => e?.toJson())?.toList(),
      'liked': instance.liked?.map((e) => e?.toJson())?.toList(),
      'conversations': instance.conversations,
      'ratings': instance.ratings,
      'rated': instance.rated,
      'notifications': instance.notifications,
      'updatedAt': instance.updatedAt,
      'createdAt': instance.createdAt,
    };
