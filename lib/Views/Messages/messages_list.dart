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
  Stream<List<Message>>? _messagesStream;

  @override
  void initState() {
    super.initState();
    _refreshMessages();
  }

  void _refreshMessages() async {
    final apiService = ApiService();
    List<Message> sentMessages = await apiService.getSentMessages();
    List<Message> inboxMessages = await apiService.getInboxMessages('all');
    _messages = [...sentMessages, ...inboxMessages];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: _messagesStream,
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.hasData) {
          _messages!.addAll(snapshot.data!);
        }
        if (_messages == null || _messages!.isEmpty) {
          return Center(child: Text('WOW, such empty'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            _refreshMessages();
          },
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