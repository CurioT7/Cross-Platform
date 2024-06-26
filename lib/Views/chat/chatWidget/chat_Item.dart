import 'package:curio/Models/chat_details_model.dart';
import 'package:curio/Models/chatmodel.dart';
import 'package:curio/Views/chat/chat_details_screen.dart';
import 'package:curio/controller/chat_cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatItemWidget extends StatelessWidget {
  ChatItemWidget({
    super.key,
    required this.image,
    required this.chat,
    required this.myUsername,
    required this.token,
    required this.index,
  });

  final ImageProvider<Object> image;
  final Chat chat;
  final String? myUsername;
  final String token;
  int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return InkWell(
          onTap: () {
            cubit.getAllMessages(
              index,
              token: token,
              chatID: chat.id,
              context: context,
              image: image,
              username: chat.participants,
            );
          },
          child: Row(children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: image,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.participants ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${(chat.messages[chat.messages.length - 1].sender) == myUsername ? 'You' : chat.messages[chat.messages.length - 1].sender} : ${chat.messages[chat.messages.length - 1].message ?? ''}",
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            )
          ]),
        );
      },
    );
  }
}
