import 'package:curio/Views/Messages/reply_page.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/message.dart';

class MessageDetailPage extends StatelessWidget {
  final Message message;

  MessageDetailPage({required this.message});

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(message.timestamp);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('u/${message.sender.username}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.subject ?? 'No Subject',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'u/${message.sender.username} • $timeAgo',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              message.message,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            // ElevatedButton(
            //   child: Text('Reply to Message', style: TextStyle(color: Colors.white)),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ReplyPage(message: message),
            //       ),
            //     );
            //   },
            //   style: ButtonStyle(
            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //       RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(18.0),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}