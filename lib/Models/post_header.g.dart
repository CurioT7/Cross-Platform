// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostHeader _$PostHeaderFromJson(Map<String, dynamic> json) => PostHeader(
      id: json['_id'] as String? ?? 'null',
      title: json['title'] as String?,
      content: json['content'] as String?,
      authorName: json['authorName'] as String?,
      views: (json['views'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      upvotes: (json['upvotes'] as num?)?.toInt(),
      downvotes: (json['downvotes'] as num?)?.toInt(),
      linkedSubreddit: json['linkedSubreddit'] as String? ?? "",
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      shares: (json['shares'] as num?)?.toInt(),
      searchCount: (json['searchCount'] as num?)?.toInt(),
      isNSFW: json['isNSFW'] as bool? ?? false,
      isSpoiler: json['isSpoiler'] as bool? ?? false,
      isOC: json['isOC'] as bool? ?? false,
      isCrosspost: json['isCrosspost'] as bool? ?? false,
      awards: (json['awards'] as num?)?.toInt(),
      media: json['media'] as String?,
      link: json['link'] as String?,
      isDraft: json['isDraft'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      voteStatus: json['voteStatus'] as String?,
      isUserMemberOfItemSubreddit:
          json['isUserMemberOfItemSubreddit'] as bool? ?? false,
      subredditName: json['subredditName'] as String?,
      voteLength: json['voteLength'],
      options: json['options'] as List<dynamic>?,
    );

Map<String, dynamic> _$PostHeaderToJson(PostHeader instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorName': instance.authorName,
      'views': instance.views,
      'createdAt': instance.createdAt,
      'searchCount': instance.searchCount,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'linkedSubreddit': instance.linkedSubreddit,
      'comments': instance.comments,
      'shares': instance.shares,
      'isNSFW': instance.isNSFW,
      'isSpoiler': instance.isSpoiler,
      'isOC': instance.isOC,
      'isCrosspost': instance.isCrosspost,
      'awards': instance.awards,
      'media': instance.media,
      'link': instance.link,
      'isDraft': instance.isDraft,
      'voteLength': instance.voteLength,
      'options': instance.options,
      'isSaved': instance.isSaved,
      'isLocked': instance.isLocked,
      'voteStatus': instance.voteStatus,
      'isUserMemberOfItemSubreddit': instance.isUserMemberOfItemSubreddit,
      'subredditName': instance.subredditName,
    };
