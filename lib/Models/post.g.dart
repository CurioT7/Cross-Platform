// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      post: PostHeader.fromJson(json['post'] as Map<String, dynamic>),
      details: json['details'] == null
          ? null
          : PostDetails.fromJson(json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'post': instance.post,
      'details': instance.details,
    };
