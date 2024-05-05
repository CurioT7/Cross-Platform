import 'package:json_annotation/json_annotation.dart';

import 'post.dart';
part 'posts_response.g.dart';

@JsonSerializable()
class PostsResponse {
  int? tottalCount;
  int? totalPages;
  List<Post> posts;

  PostsResponse({required this.tottalCount,required this.totalPages, required this.posts,});

  factory PostsResponse.fromJson(Map<String, dynamic> json) => _$PostsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostsResponseToJson(this);
}