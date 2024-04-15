class Post {
  final String id;
  final String title;
  final String content;
  final String? authorName;
  final int views;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final String? linkedSubreddit;
  final List<dynamic> comments;
  final int shares;
  final bool isNSFW;
  final bool isSpoiler;
  final bool isOC;
  final bool isCrosspost;
  final int awards;
  final String? media;
  final String? link;
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
      id: json['_id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      content: json['content'] as String? ?? '',
      authorName: json['authorName'] ?? 'Unknown',
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      linkedSubreddit: json['linkedSubreddit'] ?? 'Unknown',
      comments: json['comments'] ?? [],
      shares: json['shares'] ?? 0,
      isNSFW: json['isNSFW'] ?? false,
      isSpoiler: json['isSpoiler'] ?? false,
      isOC: json['isOC'] ?? false,
      isCrosspost: json['isCrosspost'] ?? false,
      awards: json['awards'] ?? 0,
      media: json['media'] as String?,
      link: json['link'] ?? '',
      isDraft: json['isDraft'] ?? false,
    );
  }

  static List<Post> getPosts(List<dynamic> json) {
    return json
        .map((post) => Post(
              id: post['_id'],
              title: post['title'],
              content: post['content'],
              authorName: post['authorName'],
              views: post['views'],
              createdAt: DateTime.parse(post['createdAt']),
              upvotes: post['upvotes'],
              downvotes: post['downvotes'],
              linkedSubreddit: post['linkedSubreddit'],
              comments: List<String>.from(post['comments']),
              shares: post['shares'],
              isNSFW: post['isNSFW'],
              isSpoiler: post['isSpoiler'],
              isOC: post['isOC'],
              isCrosspost: post['isCrosspost'],
              awards: post['awards'],
              media: post['media'],
              link: post['link'],
              isDraft: post['isDraft'],
            ))
        .toList();
  }
}
