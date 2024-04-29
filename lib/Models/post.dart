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
  late  bool isNSFW;
  late  bool isSpoiler;
  final bool isOC;
  final bool isCrosspost;
  final int awards;
  final String? media;
  final String? link;
  final bool isDraft;
  bool isLocked = false;
  bool isSaved = false;
  final String voteStatus;
  final bool isUserMemberOfItemSubreddit;
  final String subredditName;
  final dynamic pollVote;
  final bool pollEnded;


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
    required this.isLocked,
    required this.isSaved,
    required this.voteStatus,
    required this.isUserMemberOfItemSubreddit,
    required this.subredditName,
    required this.pollVote,
    required this.pollEnded,

  });

  factory Post.fromJson(Map<String, dynamic> json) {
  var postData = json['post'] as Map<String, dynamic>; // Access the nested 'post' object
  var detailsData = json['details'] as Map<String, dynamic>; // Access the nested 'details' object
  return Post(
    id: postData['_id'] as String? ?? '',
    title: postData['title'] as String? ?? 'Untitled',
    content: postData['content'] as String? ?? '',
    authorName: postData['authorName'] as String? ?? 'Unknown',
    views: postData['views'] as int? ?? 0,
    createdAt: postData['createdAt'] != null
        ? DateTime.parse(postData['createdAt'] as String)
        : DateTime.now(),
    upvotes: postData['upvotes'] as int? ?? 0,
    downvotes: postData['downvotes'] as int? ?? 0,
    linkedSubreddit: postData['linkedSubreddit'] as String? ?? 'Unknown',
    comments: postData['comments'] as List<dynamic>? ?? [],
    shares: postData['shares'] as int? ?? 0,
    isNSFW: postData['isNSFW'] as bool? ?? false,
    isSpoiler: postData['isSpoiler'] as bool? ?? false,
    isOC: postData['isOC'] as bool? ?? false,
    isCrosspost: postData['isCrosspost'] as bool? ?? false,
    awards: postData['awards'] as int? ?? 0,
    media: postData['media'] as String?,
    link: postData['link'] as String? ?? '',
    isDraft: postData['isDraft'] as bool? ?? false,
    isLocked: postData['isLocked'] as bool? ?? false, // new field
    isSaved: postData['isSaved'] as bool? ?? false, // new field
    voteStatus: detailsData['voteStatus'] as String? ?? 'unvoted',
    isUserMemberOfItemSubreddit: detailsData['isUserMemberOfItemSubreddit'] as bool? ?? false,
    subredditName: detailsData['subredditName'] as String? ?? 'Unknown',
    pollVote: detailsData['pollVote'],
    pollEnded: detailsData['pollEnded'] as bool? ?? false,
  );
}
  
  static List<Post> getPosts(List<dynamic> json) {
    return json
        .map((post) => Post.fromJson(post as Map<String, dynamic>))
        .toList();
  }
}
