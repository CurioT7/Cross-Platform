class Post {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final int views;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final String linkedSubreddit;
  final List<dynamic> comments;
  final int shares;
  final bool isNSFW;
  final bool isSpoiler;
  final bool isOC;
  final bool isCrosspost;
  final int awards;
  final String media;
  final String link;
  final bool isDraft;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.views,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.linkedSubreddit,
    required this.comments,
    required this.shares,
    required this.isNSFW,
    required this.isSpoiler,
    required this.isOC,
    required this.isCrosspost,
    required this.awards,
    required this.media,
    required this.link,
    required this.isDraft,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      authorName: json['authorName'],
      views: json['views'],
      createdAt: DateTime.parse(json['createdAt']),
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      linkedSubreddit: json['linkedSubreddit'],
      comments: json['comments'],
      shares: json['shares'],
      isNSFW: json['isNSFW'],
      isSpoiler: json['isSpoiler'],
      isOC: json['isOC'],
      isCrosspost: json['isCrosspost'],
      awards: json['awards'],
      media: json['media'],
      link: json['link'],
      isDraft: json['isDraft'],
    );
  }
}
