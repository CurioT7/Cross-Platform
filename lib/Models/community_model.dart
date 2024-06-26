import 'package:flutter/material.dart';
class Moderator {
  final String username;
  final String role;
  final bool manageUsers;
  final bool createLiveChats;
  final bool manageSettings;
  final bool managePostsAndComments;
  final bool everything;
  final String id;
  Moderator({
    required this.username,
    required this.role,
    required this.manageUsers,
    required this.createLiveChats,
    required this.manageSettings,
    required this.managePostsAndComments,
    required this.everything,
    required this.id,
  });
  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
      username: json['username'],
      role: json['role'],
      manageUsers: json['manageUsers'],
      createLiveChats: json['createLiveChats'],
      manageSettings: json['manageSettings'],
      managePostsAndComments: json['managePostsAndComments'],
      everything: json['everything'],
      id: json['_id'],
    );
  }
}
class Community {
  final String id;
  final String name;
  final String description;
  final List<dynamic> posts;
  final bool isOver18;
  final String privacyMode;
  final String? banner;
  final String? icon;
  final bool isNSFW;
  final bool isSpoiler;
  final bool isOC;
  final bool isCrosspost;
  final List<dynamic> rules;
  final String category;
  final String language;
  final bool allowImages;
  final bool allowVideos;
  final bool allowText;
  final bool allowLink;
  final bool allowPoll;
  final bool allowEmoji;
  final bool allowGif;
  final List<Member> members;
  final List<Moderator> moderators;
  final String createdAt;
  @override
  String toString() {
    return 'Community{id: $id, name: $name, description: $description, isOver18: $isOver18, privacyMode: $privacyMode, isNSFW: $isNSFW, isSpoiler: $isSpoiler, isOC: $isOC, isCrosspost: $isCrosspost, rules: $rules, category: $category, language: $language, allowImages: $allowImages, allowVideos: $allowVideos, allowText: $allowText, allowLink: $allowLink, allowPoll: $allowPoll, allowEmoji: $allowEmoji, allowGif: $allowGif, createdAt: $createdAt}';
  }


  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.posts,
    required this.banner,
    required this.icon,
    required this.isOver18,
    required this.privacyMode,
    required this.isNSFW,
    required this.isSpoiler,
    required this.isOC,
    required this.isCrosspost,
    required this.rules,
    required this.category,
    required this.language,
    required this.allowImages,
    required this.allowVideos,
    required this.allowText,
    required this.allowLink,
    required this.allowPoll,
    required this.allowEmoji,
    required this.allowGif,
    required this.members,
    required this.moderators,
    required this.createdAt,

  });

  factory Community.fromJson(Map<String, dynamic> json) {

    return Community(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      posts: json['posts'],
      banner: json['banner'],
      icon: json['icon'],
      isOver18: json['isOver18'],
      privacyMode: json['privacyMode'],
      isNSFW: json['isNSFW'],
      isSpoiler: json['isSpoiler'],
      isOC: json['isOC'],
      isCrosspost: json['isCrosspost'],
      rules: json['rules'],
      category: json['category'],
      language: json['language'],
      allowImages: json['allowImages'],
      allowVideos: json['allowVideos'],
      allowText: json['allowText'],
      allowLink: json['allowLink'],
      allowPoll: json['allowPoll'],
      allowEmoji: json['allowEmoji'],
      allowGif: json['allowGif'],
      members: (json['members'] as List).map((i) => Member.fromJson(i)).toList(),
      moderators: (json['moderators'] as List).map((i) => Moderator.fromJson(i)).toList(),
      createdAt: json['createdAt'],

    );
  }
}

class Member {
  final String username;
  final String id;

  Member({
    required this.username,
    required this.id,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      username: json['username'],
      id: json['_id'],
    );
  }
}
