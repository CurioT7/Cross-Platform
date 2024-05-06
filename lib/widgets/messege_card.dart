import 'package:flutter/material.dart';
import 'package:curio/Models/message.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  MessageCard({required this.message});

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(message.timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.mail,
          color: message.isRead ? Colors.grey : Colors.blue,
        ),
        title: Text(
          message.sender.username,
          style: TextStyle(
            fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                fontWeight: message.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            Text(
              timeAgo,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle tap event, e.g., mark message as read
        },
      ),
    );
  }
}