import 'package:curio/Models/message.dart';
import 'package:curio/services/messageService.dart';
import 'package:curio/widgets/messege_card.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatefulWidget {
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  List<Message>? _messages;

  @override
  void initState() {
    super.initState();
    _refreshMessages();
  }

  Future<List<Message>> _refreshMessages() async {
    final apiService = ApiService();
    List<Message> sentMessages = await apiService.getSentMessages();
    List<Message> inboxMessages = await apiService.getInboxMessages('all');
    _messages = [...sentMessages, ...inboxMessages];
    return _messages!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _refreshMessages(),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        _messages = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refreshMessages,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _messages!.length,
            itemBuilder: (context, index) {
              print('Message ${index + 1}: ${_messages![index].message}');
              return MessageCard(
                message: _messages![index],
              );
            },
          ),
        );
      },
    );
  }
}