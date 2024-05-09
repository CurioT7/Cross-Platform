import 'dart:convert';

class MessageInChatDetails {
  String sender;
  String message;
  String status;
  String id;
  String timestamp;

  MessageInChatDetails({
    required this.sender,
    required this.message,
    required this.status,
    required this.id,
    required this.timestamp,
  });

  factory MessageInChatDetails.fromJson(json) {
    return MessageInChatDetails(
      sender: json['sender'].toString(),
      message: json['message'].toString(),
      status: json['status'].toString(),
      id: json['_id'].toString(),
      timestamp: json['timestamp'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'status': status,
      '_id': id,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  MessageInChatDetails copyWith({
    String? sender,
    String? message,
    String? status,
    String? id,
    String? timestamp,
  }) {
    return MessageInChatDetails(
      sender: sender ?? this.sender,
      message: message ?? this.message,
      status: status ?? this.status,
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ParticipantInChatDetails {
  final String username;
  final String id;

  ParticipantInChatDetails({
    required this.username,
    required this.id,
  });

  factory ParticipantInChatDetails.fromJson(json) {
    return ParticipantInChatDetails(
      username: json['username'].toString(),
      id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  ParticipantInChatDetails copyWith({
    String? username,
    String? id,
  }) {
    return ParticipantInChatDetails(
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }
}

class ChatDetails {
  String id;
  List<MessageInChatDetails> messages;
  List<ParticipantInChatDetails> participants;
  List<ParticipantInChatDetails> senders;

  ChatDetails({
    required this.id,
    required this.messages,
    required this.participants,
    required this.senders,
  });

  factory ChatDetails.fromJson(json) {
    return ChatDetails(
      id: json['_id'],
      messages: (json['messages'] as List<dynamic>)
          .map((messageJson) => MessageInChatDetails.fromJson(messageJson))
          .toList(),
      participants: (json['participants'] as List<dynamic>)
          .map((participantJson) =>
              ParticipantInChatDetails.fromJson(participantJson))
          .toList(),
      senders: (json['senders'] as List<dynamic>)
          .map((senderJson) => ParticipantInChatDetails.fromJson(senderJson))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
      'participants':
          participants.map((participant) => participant.toJson()).toList(),
      'senders': senders.map((sender) => sender.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  ChatDetails copyWith({
    String? id,
    List<MessageInChatDetails>? messages,
    List<ParticipantInChatDetails>? participants,
    List<ParticipantInChatDetails>? senders,
  }) {
    return ChatDetails(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      participants: participants ?? this.participants,
      senders: senders ?? this.senders,
    );
  }
}
