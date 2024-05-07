import 'package:curio/Views/Messages/message_detail.dart';
import 'package:flutter/material.dart';
import 'package:curio/Models/message.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    _loadReadStatus();
  }

  _loadReadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRead = (prefs.getBool('isRead_${widget.message.id}') ?? false);
    });
  }

  _saveReadStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRead_${widget.message.id}', _isRead);
  }
void markAllAsRead(List<String> messageIds) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var messageId in messageIds) {
    prefs.setBool('isRead_$messageId', true);
  }
}
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isRead = true;
        });
        _saveReadStatus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailPage(message: widget.message),
          ),
        );
      },
      child: Card(
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
                  _saveReadStatus();
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
      ),
    );
  }
}