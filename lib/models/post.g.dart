// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['_id'] as String,
    approved: json['approved'] as bool,
    bids: json['bids'] as List,
    comments: (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    createdAt: json['createdAt'] as String,
    description: json['description'] as String,
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    likes: json['likes'] as int,
    location: json['location'] as String,
    open: json['open'] as bool,
    price: json['price'] as String,
    startBid: json['startBid'] as String,
    title: json['title'] as String,
    updatedAt: json['updatedAt'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    views: json['views'] as int,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      '_id': instance.id,
      'approved': instance.approved,
      'bids': instance.bids,
      'comments': instance.comments?.map((e) => e?.toJson())?.toList(),
      'createdAt': instance.createdAt,
      'description': instance.description,
      'images': instance.images,
      'likes': instance.likes,
      'location': instance.location,
      'open': instance.open,
      'price': instance.price,
      'startBid': instance.startBid,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
      'user': instance.user?.toJson(),
      'views': instance.views,
    };
