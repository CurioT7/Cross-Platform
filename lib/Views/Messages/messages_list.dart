import 'package:curio/Models/message.dart';
import 'package:curio/services/messageService.dart';
import 'package:curio/widgets/messege_card.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatefulWidget {
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  Future<List<Message>>? _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _refreshMessages();
  }

  Future<List<Message>> _refreshMessages() async {
    final apiService = ApiService();
    List<Message> sentMessages = await apiService.getSentMessages();
    List<Message> inboxMessages = await apiService.getInboxMessages('all');
    return [...sentMessages, ...inboxMessages];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _messagesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<Message> _messages = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async {
            _messagesFuture = _refreshMessages();
            setState(() {});
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              print('Message ${index + 1}: ${_messages[index].message}');
              return MessageCard(
                message: _messages[index],
              );
            },
          ),
        );
      },
    );
  }
}