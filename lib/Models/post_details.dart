import 'package:json_annotation/json_annotation.dart';

part 'post_details.g.dart';

@JsonSerializable()
class PostDetails {
  final String? voteStatus;
  final bool isUserMemberOfItemSubreddit;
  final String? subredditName;
  final bool? pollVote;
  final bool pollEnded;
  
  PostDetails({
    required this.voteStatus,
    required this.isUserMemberOfItemSubreddit,
    required this.subredditName,
    this.pollVote,
    required this.pollEnded,
  });

  factory PostDetails.fromJson(Map<String, dynamic> json) =>
      _$PostDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailsToJson(this);
}