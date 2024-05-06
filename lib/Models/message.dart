class Message {
  final String id;
  final User sender;
  final User recipient;
  final String type;
  final String message;
  final bool isRead;
  final bool isSent;
  final bool isPrivate;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.type,
    required this.message,
    required this.isRead,
    required this.isSent,
    required this.isPrivate,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      sender: User.fromJson(json['sender']),
      recipient: User.fromJson(json['recipient']),
      type: json['type'],
      message: json['message'],
      isRead: json['isRead'],
      isSent: json['isSent'],
      isPrivate: json['isPrivate'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender.toJson(),
      'recipient': recipient.toJson(),
      'type': type,
      'message': message,
      'isRead': isRead,
      'isSent': isSent,
      'isPrivate': isPrivate,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class User {
  final String id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
    };
  }
}