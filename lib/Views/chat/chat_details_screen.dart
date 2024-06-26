import 'dart:developer';

import 'package:curio/Models/chatmodel.dart';
import 'package:curio/Views/chat/chatWidget/message_item.dart';
import 'package:curio/Views/chat/chat_socket.dart';
import 'package:curio/controller/chat_cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/chat_details_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  ChatDetails chat;
  ImageProvider<Object> image;
  String token;
  int index;
  String username;

  ChatDetailsScreen({
    super.key,
    required this.chat,
    required this.image,
    required this.index,
    required this.token,
    required this.username,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var messageController;
  late String myID;

  @override
  initState() {
    // ChatSocket.initializeSocket();
    // ChatSocket.connect();

    myID = widget.chat.participants[0].username == widget.username
        ? myID = widget.chat.participants[1].id
        : myID = widget.chat.participants[0].id;

    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    // ChatSocket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SendMessageSuccess) {
          setState(() {});
        }
      },
      builder: (context, state) {
        String? profilePicture = '';
        ImageProvider image = profilePicture == ''
            ? const NetworkImage(
                    'https://www.redditstatic.com/avatars/avatar_default_13_46D160.png')
                as ImageProvider<Object>
            : NetworkImage(profilePicture);
        var cubit = ChatCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: image,
                    radius: 14,
                  ),
                  const SizedBox(width: 10),
                  Text(widget.username ?? ''),
                ],
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: image,
                ),
                const SizedBox(height: 20),
                Text(
                  widget.username ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cubit.chat!.messages.length,
                      itemBuilder: (context, index) {
                        List<MessageInChatDetails> reversedMessages =
                            cubit.chat!.messages.reversed.toList();

                        return MessageItemWidget(
                            index: index,
                            image: image,
                            message: reversedMessages[index],
                            myUsername: (reversedMessages[index].sender ==
                                    widget.chat.participants[0].id)
                                ? widget.chat.participants[0].username
                                    .toString()
                                : widget.chat.participants[1].username
                                        .toString() ??
                                    '',
                            isSame: (index == 0)
                                ? false
                                : (reversedMessages[index].sender ==
                                        reversedMessages[index - 1].sender)
                                    ? true
                                    : false);
                      }),
                ),
                const Divider(),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // CupertinoButton(
                    //   padding: EdgeInsets.zero,
                    //   onPressed: () {
                    //     // TODO: implement camera option
                    //   },
                    //   child: const CircleAvatar(
                    //     backgroundColor: Colors.black12,
                    //     child: Icon(Icons.camera_alt_outlined),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Messgae ${widget.username ?? ''}',
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    (state is SendMessageLoading)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (messageController.text != '') {
                                cubit.sendMessage(
                                    index: widget.index,
                                    token: widget.token,
                                    message: messageController.text,
                                    chatID: widget.chat.id);
                              }
                              //close key board
                              FocusManager.instance.primaryFocus?.unfocus();
                              messageController.clear();
                            },
                            child: const Icon(
                              CupertinoIcons.play_arrow_solid,
                              color: Color(0xffff4400),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ));
      },
    );
  }
}
