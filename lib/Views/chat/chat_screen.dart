import 'dart:async';
import 'dart:developer';

import 'package:curio/Views/chat/chatWidget/chat_Item.dart';
import 'package:curio/Views/chat/new_chat_screen.dart';
import 'package:curio/controller/chat_cubit/chat_cubit.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    super.key,
    required this.token,
    required this.myUsername,
  });
  String? token;
  String? myUsername;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateNewChatScreen(
                            token: token,
                          )),
                );
              },
              child: const Icon(
                CupertinoIcons.chat_bubble_fill,
                color: Color(0xffff4400),
                size: 25,
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                "Chat",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      cubit.getChatRequest(token: token!);
                      ();
                    },
                    child: const Text(
                      'chat requests',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
            body: (cubit.chats.isEmpty)
                ? const Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to chat!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        """
Chat with other Redditors about your
favorite topics.""",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))
                : ListView.builder(
                    itemBuilder: (context, index) {
                      String? profilePicture =
                          cubit.chats[index].participants[0].profilePicture ??
                              '';
                      ImageProvider image = profilePicture == ''
                          ? const AssetImage('lib/assets/images/Curio.png')
                              as ImageProvider<Object>
                          : NetworkImage(profilePicture);
                      return ChatItemWidget(
                          index: index,
                          token: token!,
                          image: image,
                          chat: cubit.chats[index],
                          myUsername: myUsername);
                    },
                    itemCount: cubit.chats.length,
                  ));
      },
    );
  }
}
