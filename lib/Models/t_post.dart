class TPost {
  String? id;
  String? title;
  String? content;
  String? authorName;
  int? views;
  int? searchCount;
  int? upvotes;
  int? downvotes;
  List<dynamic>? comments;
  int? shares;
  bool? isNsfw;
  bool? isSpoiler;
  bool? isOc;
  bool? isCrosspost;
  int? awards;
  bool? isDraft;
  bool? isSaved;
  String? originalPostId;
  bool? sendReplies;
  bool? isLocked;
  DateTime? createdAt;
  int? v;

  TPost({
    this.id,
    this.title,
    this.content,
    this.authorName,
    this.views,
    this.searchCount,
    this.upvotes,
    this.downvotes,
    this.comments,
    this.shares,
    this.isNsfw,
    this.isSpoiler,
    this.isOc,
    this.isCrosspost,
    this.awards,
    this.isDraft,
    this.isSaved,
    this.originalPostId,
    this.sendReplies,
    this.isLocked,
    this.createdAt,
    this.v,
  });

  factory TPost.fromJson(Map<String, dynamic> json) => TPost(
    id: json['_id'] as String?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    authorName: json['authorName'] as String?,
    views: json['views'] as int?,
    searchCount: json['searchCount'] as int?,
    upvotes: json['upvotes'] as int?,
    downvotes: json['downvotes'] as int?,
    comments: json['comments'] as List<dynamic>?,
    shares: json['shares'] as int?,
    isNsfw: json['isNSFW'] as bool?,
    isSpoiler: json['isSpoiler'] as bool?,
    isOc: json['isOC'] as bool?,
    isCrosspost: json['isCrosspost'] as bool?,
    awards: json['awards'] as int?,
    isDraft: json['isDraft'] as bool?,
    isSaved: json['isSaved'] as bool?,
    originalPostId: json['originalPostId'] as String?,
    sendReplies: json['sendReplies'] as bool?,
    isLocked: json['isLocked'] as bool?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    v: json['__v'] as int?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'content': content,
    'authorName': authorName,
    'views': views,
    'searchCount': searchCount,
    'upvotes': upvotes,
    'downvotes': downvotes,
    'comments': comments,
    'shares': shares,
    'isNSFW': isNsfw,
    'isSpoiler': isSpoiler,
    'isOC': isOc,
    'isCrosspost': isCrosspost,
    'awards': awards,
    'isDraft': isDraft,
    'isSaved': isSaved,
    'originalPostId': originalPostId,
    'sendReplies': sendReplies,
    'isLocked': isLocked,
    'createdAt': createdAt?.toIso8601String(),
    '__v': v,
  };

  static List<TPost> getTrendingPosts(List<dynamic> json) {
    return json.map((post) => TPost.fromJson(post)).toList();
  }
}
