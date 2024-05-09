import 'dart:convert';

// Class representing a single message

// Class representing a single chat
class Chat {
  String id;
  List<Message> messages;
  String participants;
  int unReadMessagesNumber;
  String? profilePicture;
  String sender;

  Chat({
    required this.id,
    required this.messages,
    required this.participants,
    required this.unReadMessagesNumber,
    this.profilePicture,
    required this.sender,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['_id'],
    messages: (json['messages'] as List<dynamic>)
        .map((message) => Message.fromJson(message))
        .toList(),
    participants: json['participants'] ?? '',
    unReadMessagesNumber: json['unReadMessagesNumber'] ?? '',
    profilePicture: json['profilePicture'] ?? '',
    sender: json['sender'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'messages': messages.map((message) => message.toJson()).toList(),
    'participants': participants,
    'unReadMessagesNumber': unReadMessagesNumber,
    'profilePicture': profilePicture,
    'sender': sender,
  };

  @override
  String toString() =>
      'Chat(id: $id, messages: $messages, participants: $participants, unReadMessagesNumber: $unReadMessagesNumber, profilePicture: $profilePicture, sender: $sender)';

  Chat copyWith({
    String? id,
    List<Message>? messages,
    String? participants,
    int? unReadMessagesNumber,
    String? profilePicture,
    String? sender,
  }) =>
      Chat(
        id: id ?? this.id,
        messages: messages ?? this.messages,
        participants: participants ?? this.participants,
        unReadMessagesNumber: unReadMessagesNumber ?? this.unReadMessagesNumber,
        profilePicture: profilePicture ?? this.profilePicture,
        sender: sender ?? this.sender,
      );
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

  factory Participant.fromJson(json) {
    return Participant(
      id: json['_id'] ?? '', // directly access the value using the key
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'username': username,
    'profilePicture': profilePicture,
  };
}

class Message {
  String sender;
  String message;
  String status;
  String id; // Use lowercase 'id' to avoid conflicts with Dart's 'Id'
  String timestamp;

  Message({
    required this.sender,
    required this.message,
    required this.status,
    required this.id,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    sender: json['sender'] ?? '',
    message: json['message'] ?? '',
    status: json['status'] ?? '',
    id: json['_id'] ?? '',
    timestamp: json['timestamp'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'message': message,
    'status': status,
    '_id': id,
    'timestamp': timestamp,
  };

  @override
  String toString() =>
      'Message(sender: $sender, message: $message, status: $status, id: $id, timestamp: $timestamp)';

  Message copyWith({
    String? sender,
    String? message,
    String? status,
    String? id,
    String? timestamp,
  }) =>
      Message(
          sender: sender ?? this.sender,
          message: message ?? this.message,
          status: status ?? this.status,
          id: id ?? this.id,
          timestamp: timestamp ?? this.timestamp,
          );
}
