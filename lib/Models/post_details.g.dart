// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetails _$PostDetailsFromJson(Map<String, dynamic> json) => PostDetails(
      voteStatus: json['voteStatus'] as String?,
      isUserMemberOfItemSubreddit: json['isUserMemberOfItemSubreddit'] as bool,
      subredditName: json['subredditName'] as String?,
      pollVote: json['pollVote'] as bool?,
      pollEnded: json['pollEnded'] as bool,
    );

Map<String, dynamic> _$PostDetailsToJson(PostDetails instance) =>
    <String, dynamic>{
      'voteStatus': instance.voteStatus,
      'isUserMemberOfItemSubreddit': instance.isUserMemberOfItemSubreddit,
      'subredditName': instance.subredditName,
      'pollVote': instance.pollVote,
      'pollEnded': instance.pollEnded,
    };
