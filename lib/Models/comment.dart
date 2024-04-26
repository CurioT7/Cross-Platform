class Comment {
  final String id;
  final String content;
  final String authorUsername;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final String linkedPost;
  final String linkedSubreddit;
  final int awards;

  Comment({
    required this.id,
    required this.content,
    required this.authorUsername,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.linkedPost,
    required this.linkedSubreddit,
    required this.awards,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      content: json['content'],
      authorUsername: json['authorName'],
      createdAt: DateTime.parse(json['createdAt']),
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      linkedPost: json['linkedPost'],
      linkedSubreddit: json['linkedSubreddit'],
      awards: json['awards'],
    );
  }

  static List<Comment> getComments(List<dynamic> json) {
    return json.map((comment) => Comment.fromJson(comment)).toList();
  }
}
