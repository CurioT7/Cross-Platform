class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String recipient;
  final bool isRead;
  final DateTime timestamp;
  final bool isSent;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.recipient,
    required this.isRead,
    required this.timestamp,
    required this.isSent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      recipient: json['recipient'],
      isRead: json['isRead'],
      timestamp: DateTime.parse(json['timestamp']),
      isSent: json['isSent'],
    );
  }

  static List<NotificationModel> getNotifications(List<dynamic> json) {
    return json
        .map((notification) => NotificationModel.fromJson(notification))
        .take(30).toList();

    //TODO Correct amount of notifications returned
  }
}