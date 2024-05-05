import 'package:json_annotation/json_annotation.dart';

part 'post_header.g.dart';

@JsonSerializable()
class PostHeader {
  @JsonKey(name:"_id")
  final String? id;
  final String? title;
  final String? content;
  final String? authorName;
  final int? views;
  final String? createdAt;
  final int? searchCount;
  final int? upvotes;
  final int? downvotes;
  final String linkedSubreddit;
  final List<String> comments;
  final int? shares;
  final bool isNSFW;
  final bool isSpoiler;
  final bool isOC;
  final bool isCrosspost;
  final int? awards;
  final String? media;
  final String? link;
  final bool isDraft;
  final dynamic? voteLength;
  final List<dynamic>? options;
  final bool isSaved;
  final bool isLocked;
  final String? voteStatus;
  final bool isUserMemberOfItemSubreddit;

  PostHeader({
    this.id='null',
     this.title,
     this.content,
     this.authorName,
     this.views,
     this.createdAt,
     this.upvotes,
     this.downvotes,
     this.linkedSubreddit="",
     this.comments=const [],
     this.shares,
     this.searchCount,
     this.isNSFW=false,
     this.isSpoiler=false,
     this.isOC=false,
     this.isCrosspost=false,
     this.awards,
     this.media,
     this.link,
     this.isDraft = false,
     this.isLocked = false,
     this.isSaved = false,
     this.voteStatus,
     this.isUserMemberOfItemSubreddit=false,
     this.subredditName,
     this.voteLength,
     this.options,
  });

  factory PostHeader.fromJson(Map<String, dynamic> json) => _$PostHeaderFromJson(json);

  Map<String, dynamic> toJson() => _$PostHeaderToJson(this);
}