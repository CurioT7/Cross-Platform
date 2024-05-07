class Message {
  final String id;
  final User sender;
  final User recipient;
  final String type;
  final String? subject;
  final String message;
  final bool isRead;
  final bool? isSent;
  final bool? isPrivate;
  final DateTime timestamp;
  final int v;
  final Subreddit? senderSubreddit;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.type,
    this.subject,
    required this.message,
    required this.isRead,
    this.isSent,
    this.isPrivate,
    required this.timestamp,
    required this.v,
    this.senderSubreddit,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sender: User.fromJson(json['sender']),
      recipient: User.fromJson(json['recipient']),
      type: json['type'],
      subject: json['subject'],
      message: json['message'],
      isRead: json['isRead'],
      isSent: json['isSent'],
      isPrivate: json['isPrivate'],
      timestamp: DateTime.parse(json['timestamp']),
      v: json['__v'],
      senderSubreddit: json['senderSubreddit'] != null ? Subreddit.fromJson(json['senderSubreddit']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender.toJson(),
      'recipient': recipient.toJson(),
      'type': type,
      'subject': subject,
      'message': message,
      'isRead': isRead,
      'isSent': isSent,
      'isPrivate': isPrivate,
      'timestamp': timestamp.toIso8601String(),
      '__v': v,
      'senderSubreddit': senderSubreddit?.toJson(),
    };
  }
}

class Subreddit {
  final String id;
  final String name;

  Subreddit({required this.id, required this.name});

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class User {
  final String id;
  final String username;

  User({this.id = '', this.username = 'you'});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? 'you',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
    };
  }
}