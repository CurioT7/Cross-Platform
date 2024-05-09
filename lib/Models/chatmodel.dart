import 'package:intl/intl.dart';

class Chat {
  String id;
  List<Participant> participants;
  List<Message> messages;
  bool isRead;
  bool isSent;
  bool isDelivered;
  bool isGroupChat;
  bool isPendingRequest;
  DateTime timestamp;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
    required this.isRead,
    required this.isSent,
    required this.isDelivered,
    required this.isGroupChat,
    required this.isPendingRequest,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['_id'],
        participants: (json['participants'] as List<dynamic>)
            .map((p) => Participant.fromJson(p))
            .toList(),
        messages: (json['messages'] as List<dynamic>)
            .map((m) => Message.fromJson(m))
            .toList(),
        isRead: json['isRead'] ?? false,
        isSent: json['isSent'] ?? false,
        isDelivered: json['isDelivered'] ?? false,
        isGroupChat: json['isGroupChat'] ?? false,
        isPendingRequest: json['isPendingRequest'] ?? false,
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'participants': participants.map((p) => p.toJson()).toList(),
        'messages': messages.map((m) => m.toJson()).toList(),
        'isRead': isRead,
        'isSent': isSent,
        'isDelivered': isDelivered,
        'isGroupChat': isGroupChat,
        'isPendingRequest': isPendingRequest,
        'timestamp': timestamp.toIso8601String(),
      };
}

class Participant {
  String id;
  String username;
  String profilePicture;

  Participant({
    required this.id,
    required this.username,
    required this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json['_id'],
        username: json['username'] ?? '',
        profilePicture: json['profilePicture'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'profilePicture': profilePicture,
      };
}

class Message {
  String id;
  Participant sender;
  String message;
  String media;
  DateTime timestamp;

  Message({
    required this.id,
    required this.sender,
    required this.message,
    this.media = '',
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['_id'],
        sender: Participant.fromJson(json['sender']),
        message: json['message'],
        media: json['media'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'sender': sender.toJson(),
        'media': media ?? '',
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };
}
