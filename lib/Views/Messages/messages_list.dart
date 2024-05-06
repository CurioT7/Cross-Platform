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

  Future<List<Message>> _refreshMessages() async {
    final apiService = ApiService();
    _messages = await apiService.getSentMessages();
    return _messages!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: _messages == null || _messages!.isEmpty ? _refreshMessages() : Future.value(_messages),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.hasData) {
          _messages = snapshot.data!;
          if (_messages!.isEmpty) {
            return Center(child: Text('WOW, such empty'));
          }
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
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            width: 30,
            height: 30,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}