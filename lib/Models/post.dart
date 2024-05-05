import 'package:curio/Models/post_header.dart';
import 'package:json_annotation/json_annotation.dart';

import 'post_details.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final PostHeader post;
  final PostDetails? details;

  Post({
    required this.post,
    this.details,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}