import 'package:curio/Models/message.dart';
import 'package:flutter/material.dart';

class ReplyPage extends StatefulWidget {
  final Message message;

  ReplyPage({required this.message});

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Reply to Message'),
        actions: [
          TextButton(
            child: Text('POST'),
            onPressed: () {
              // Handle the reply post action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.message,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your reply here...',
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}