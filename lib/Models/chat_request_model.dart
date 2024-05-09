class ChatRequest {
  final ReqChat chat;
  final String id;
  final String timestamp;

  ChatRequest({required this.chat, required this.id, required this.timestamp});

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      chat: ReqChat.fromJson(json['chat']),
      id: json['_id'],
      timestamp: json['timestamp'],
    );
  }
}

class ReqChat {
  final String id;
  final List<Message> messages;
  final bool isPendingRequest;

  ReqChat(
      {required this.id,
      required this.messages,
      required this.isPendingRequest});

  factory ReqChat.fromJson(Map<String, dynamic> json) {
    return ReqChat(
      id: json['_id'],
      messages: (json['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList(),
      isPendingRequest: json['isPendingRequest'],
    );
  }
}

class Message {
  final Sender sender;
  final String message;
  final String id;
  final String timestamp;

  Message(
      {required this.sender,
      required this.message,
      required this.id,
      required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: Sender.fromJson(json['sender']),
      message: json['message'],
      id: json['_id'],
      timestamp: json['timestamp'],
    );
  }
}

class Sender {
  final String id;
  final String username;

  Sender({required this.id, required this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'],
      username: json['username'],
    );
  }
}
