import 'package:curio/Views/Messages/reply_page.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/message.dart';

class MessageDetailPage extends StatelessWidget {
  final Message message;

  MessageDetailPage({required this.message});

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
              'u/${message.sender.username} • ${message.timestamp}',
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
            ElevatedButton(
              child: Text('REPLY TO MESSAGE'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReplyPage(message: message),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

