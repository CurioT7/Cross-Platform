import 'dart:developer';

import 'package:curio/Models/chatmodel.dart';
import 'package:curio/Views/chat/chatWidget/dialog.dart';
import 'package:curio/Views/chat/chat_details_screen.dart';
import 'package:curio/controller/chat_cubit/chat_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewChatScreen extends StatefulWidget {
  CreateNewChatScreen({super.key, required this.token});
  String? token;
  @override
  State<CreateNewChatScreen> createState() => _CreateNewChatScreenState();
}

class _CreateNewChatScreenState extends State<CreateNewChatScreen> {
  var searchController;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is CreateNewChatError) {
          Navigator.pop(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.blue,
            ),
          );
          var cubit = ChatCubit.get(context);
          cubit.getChats(token: widget.token!);
        }
        if (state is CreateNewChatSuccess) {
          Navigator.pop(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(state.response['message']),
              backgroundColor: Colors.blue,
            ),
          );
          var cubit = ChatCubit.get(context);
          cubit.getChats(token: widget.token!);
        }
      },
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return Scaffold(
          backgroundColor: const Color(0xfff9f8f9),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              "New chat",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // actions: [
            //   ElevatedButton(
            //     onPressed: () {
            //       //todo : implement create new chat
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xffff4400),
            //     ),
            //     child: const Text("Create"),
            //   ),
            // ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Search for people by usename to chat with them"),
              ),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  //todo : implement search
                  if (value.length >= 3) {
                    cubit.checkUserNameAvilability(value);
                  } else {
                    cubit.toinitState();
                  }
                },
                cursorColor: Colors.black,
                cursorRadius: const Radius.circular(10),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search Username",
                  prefixIcon: Icon(CupertinoIcons.search),
                ),
              ),
              if (state is CheckUserNameAvilabilitySuccess) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "${state.response['username']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => NewChatDialog(
                              username: state.response[
                                  'username'], // Replace with actual username
                              token: widget
                                  .token!, // Replace with your authentication token
                              onCreateChat: (message, media) {
                                cubit.createNewChat(state.response['username'],
                                    widget.token!, message,
                                    media: media);
                              },
                            ),
                          );

                          // cubit.createNewChat(
                          //     state.response['username'], widget.token!, '');
                        },
                        child: const Text(
                          'start chat',
                        ),
                      ),
                    ],
                  ),
                )
              ],
              if (state is CheckUserNameAvilabilityLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ],
              if (state is! CheckUserNameAvilabilityError &&
                  state is! CheckUserNameAvilabilitySuccess) ...[
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Type at least 3 characters to start searching"),
                ),
              ],
              if (state is CheckUserNameAvilabilityError) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          state.error,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Double-check yoour spelling or try another username to adjust your search.',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
