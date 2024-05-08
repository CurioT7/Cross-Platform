class CommentModel {
  bool? isEdited;
  bool? isReportApproved;
  bool? isRemoved;
  String? id;
  String? content;
  String? authorName;
  DateTime? createdAt;
  int? upvotes;
  int? downvotes;
  String? linkedPost;
  String? linkedSubreddit;
  int? awards;
  int? v;

  CommentModel({
    this.isEdited,
    this.isReportApproved,
    this.isRemoved,
    this.id,
    this.content,
    this.authorName,
    this.createdAt,
    this.upvotes,
    this.downvotes,
    this.linkedPost,
    this.linkedSubreddit,
    this.awards,
    this.v,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        isEdited: json['isEdited'] as bool?,
        isReportApproved: json['isReportApproved'] as bool?,
        isRemoved: json['isRemoved'] as bool?,
        id: json['_id'] as String?,
        content: json['content'] as String?,
        authorName: json['authorName'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        upvotes: json['upvotes'] as int?,
        downvotes: json['downvotes'] as int?,
        linkedPost: json['linkedPost'] as String?,
        linkedSubreddit: json['linkedSubreddit'] as String?,
        awards: json['awards'] as int?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'isEdited': isEdited,
        'isReportApproved': isReportApproved,
        'isRemoved': isRemoved,
        '_id': id,
        'content': content,
        'authorName': authorName,
        'createdAt': createdAt?.toIso8601String(),
        'upvotes': upvotes,
        'downvotes': downvotes,
        'linkedPost': linkedPost,
        'linkedSubreddit': linkedSubreddit,
        'awards': awards,
        '__v': v,
      };
}
