import 'package:flutter/material.dart';
import 'package:curio/Models/message.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  MessageCard({required this.message});

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool _isRead = false;

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(widget.message.timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.mail,
                color: _isRead ? Colors.grey : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _isRead = !_isRead;
                });
              },
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.subject ?? 'No Subject',
                    style: TextStyle(
                      fontWeight: _isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    widget.message.message,
                    style: TextStyle(
                      fontWeight: _isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'u/${widget.message.sender.username} • $timeAgo',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}