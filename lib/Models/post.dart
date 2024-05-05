class Post {
  String id;
  String title;
  String content;
  String? authorName;
  int views;
  DateTime createdAt;
  int upvotes;
  int downvotes;
  String? linkedSubreddit;
  List<dynamic> comments;
  int shares;
  bool isNSFW;
  bool isSpoiler;
  bool isOC;
  bool isCrosspost;
  int awards;
  String? media;
  String? link;
  bool isDraft;
  bool isLocked;
  bool isSaved;
  String voteStatus;
  bool isUserMemberOfItemSubreddit;
  String subredditName;
  dynamic pollVote;
  bool pollEnded;

  Post({
    this.id = '',
    this.title = 'Untitled',
    this.content = '',
    this.authorName,
    this.views = 0,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    this.linkedSubreddit,
    this.comments = const [],
    this.shares = 0,
    this.isNSFW = false,
    this.isSpoiler = false,
    this.isOC = false,
    this.isCrosspost = false,
    this.awards = 0,
    this.media,
    this.link,
    this.isDraft = false,
    this.isLocked = false,
    this.isSaved = false,
    this.voteStatus = 'unvoted',
    this.isUserMemberOfItemSubreddit = false,
    this.subredditName = 'Unknown',
    this.pollVote,
    this.pollEnded = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var postData = json['post'] as Map<String, dynamic>? ?? {};
   var detailsData = json['details'] as Map<String, dynamic>? ?? {};
    return Post(
      id: postData['_id'] as String? ?? '',
      title: postData['title'] as String? ?? 'Untitled',
      content: postData['content'] as String? ?? '',
      authorName: postData['authorName'] as String?,
      views: postData['views'] as int? ?? 0,
      createdAt: postData['createdAt'] != null
          ? DateTime.parse(postData['createdAt'] as String)
          : DateTime.now(),
      upvotes: postData['upvotes'] as int? ?? 0,
      downvotes: postData['downvotes'] as int? ?? 0,
      linkedSubreddit: postData['linkedSubreddit'] as String?,
      comments: postData['comments'] as List<dynamic>? ?? [],
      shares: postData['shares'] as int? ?? 0,
      isNSFW: postData['isNSFW'] as bool? ?? false,
      isSpoiler: postData['isSpoiler'] as bool? ?? false,
      isOC: postData['isOC'] as bool? ?? false,
      isCrosspost: postData['isCrosspost'] as bool? ?? false,
      awards: postData['awards'] as int? ?? 0,
      media: postData['media'] as String?,
      link: postData['link'] as String?,
      isDraft: postData['isDraft'] as bool? ?? false,
      isLocked: postData['isLocked'] as bool? ?? false,
      isSaved: postData['isSaved'] as bool? ?? false,
      voteStatus: detailsData['voteStatus'] as String? ?? 'unvoted',
      isUserMemberOfItemSubreddit: detailsData['isUserMemberOfItemSubreddit'] as bool? ?? false,
      subredditName: detailsData['subredditName'] as String? ?? 'Unknown',
      pollVote: detailsData['pollVote'],
      pollEnded: detailsData['pollEnded'] as bool? ?? false,
    );
  }

  static List<Post> getPosts(List<dynamic> json) {
    return json
        .where((post) => post != null)
        .map((post) => Post.fromJson(post as Map<String, dynamic>))
        .toList();
  }
}