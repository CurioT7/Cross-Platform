class MiniPost {
  final String id;
  final String authorName;
  final String subredditName;
  final DateTime createdAt;
  final String title;
  final int upvotes;
  final int comments; // Change this to int

  MiniPost({
    required this.id,
    required this.authorName,
    required this.subredditName,
    required this.createdAt,
    required this.title,
    required this.upvotes,
    required this.comments,
  });

  factory MiniPost.fromJson(Map<String, dynamic> json) {
    return MiniPost(
      id: json['_id'] is String ? json['_id'] : '',
      authorName: json['authorName'] is String ? json['authorName'] : '',

      subredditName: json['linkedSubreddit'] is String ? json['linkedSubreddit'] : '',
      createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt']) : DateTime.now(),
      title: json['title'] is String ? json['title'] : '',
      upvotes: json['upvotes'] is int ? json['upvotes'] : 0,
      comments: json['comments'] is List ? json['comments'].length : 0,
    );
  }
  @override
  String toString() {
    return 'MiniPost {authorName: $authorName, subredditName: $subredditName, createdAt: $createdAt, title: $title, upvotes: $upvotes, comments: $comments}';
  }
}
