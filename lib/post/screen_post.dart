import 'dart:io';

import 'package:curio/Views/community/createCommunity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curio/post/post_to_page.dart';
import 'package:curio/post/post_card.dart';

class AddPostScreen extends StatefulWidget {
  final String type;
  const AddPostScreen({Key? key, required this.type}) : super(key: key);
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  bool optionSelected = false; // Add this line
  bool isAttachmentAdded = false; // Add this line
  String? selectedCommunity;
  Attachment? attachment;
  XFile? _pickedImage;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    bool NextScreen() {
      if (titleController.text.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }

    if (attachment != null) {
      attachment!.component = URLComponent(
        controller: linkController,
        onClear: () {
          setState(() {
            attachment = null;
            isAttachmentAdded = false;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.close,
                size: 30, color: Color.fromRGBO(26, 39, 30, 1)),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: titleController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return ElevatedButton(
                onPressed: value.text.isNotEmpty
                    ? () async {
                        if (selectedCommunity != null) {
                          List<PostCard> posts = List.generate(
                              4,
                              (index) => PostCard(
                                    title: titleController.text,
                                    content: descriptionController.text,
                                    upvotes: 1,
                                    comments: 0,
                                    downvotes: 0,
                                    username: selectedCommunity,
                                    postTime: 'postTime',
                                  ));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text('Posts'),
                                ),
                                body: ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return posts[index];
                                  },
                                ),
                              ),
                            ),
                          );
                        } else {
                          // ignore: unused_local_variable
                          String? selectedCommunity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostToPage()),
                          );
                          if (selectedCommunity != null) {
                            setState(() {
                              this.selectedCommunity = selectedCommunity;
                            });
                          }
                        }
                        // List<PostCard> posts = List.generate(
                        //     4,
                        //     (index) => PostCard(
                        //       title: titleController.text,
                        //       content: descriptionController.text,
                        //       upvotes: 1,
                        //       comments: 0,
                        //       downvotes: 0,
                        //       username: 'username',
                        //       postTime: 'postTime',
                        //         ));
                        //
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Scaffold(
                        //       appBar: AppBar(
                        //         title: const Text('Posts'),
                        //       ),
                        //       body: ListView.builder(
                        //         itemCount: posts.length,
                        //         itemBuilder: (context, index) {
                        //           return posts[index];
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: value.text.isNotEmpty
                      ? Colors.blue.shade800
                      : Colors
                          .transparent, // This will give the button a white text color
                  side: BorderSide(
                    color: value.text.isNotEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(selectedCommunity != null ? 'Post' : 'Next'),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 0, 1, 1),
            child: Column(
              children: [
                if (selectedCommunity != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          // Add this line
                          child: CommunityBar(
                            community: selectedCommunity,
                            onTap: () async {
                              // ignore: unused_local_variable
                              String? selectedCommunity = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PostToPage(),
                                ),
                              );
                              if (selectedCommunity != null) {
                                setState(() {
                                  this.selectedCommunity = selectedCommunity;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Title',
                    border: InputBorder.none,
                    fillColor: theme.cardColor,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 0 + (attachment != null ? 50.0 : 0),
                  child: Visibility(
                    visible: attachment != null && !optionSelected,
                    child: Builder(
                      builder: (context) {
                        return Row(
                          children: [
                            Expanded(child: attachment!.component),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (widget.type == 'text')
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'body (optional)',
                        border: InputBorder.none,
                        fillColor: theme.cardColor,
                        counterText: '',
                      ),
                      maxLines: null,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width / (keyboardOpen ? 2 : 1),
            child: Column(
              children: [
                if (!keyboardOpen)
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 10), // Adjust this value as needed
                    child: Text(
                      'What do you want to add?',
                      style: TextStyle(
                        fontSize: 16, // Adjust text size as needed
                        color: Colors.black, // Adjust text color as needed
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.link),
                          onPressed: isAttachmentAdded
                              ? null
                              : () {
                                  setState(() {
                                    attachment = Attachment(
                                      type: 'link',
                                      data: linkController.text,
                                      component:
                                          Container(), // Temporary component
                                    );
                                    attachment!.component = URLComponent(
                                      controller: linkController,
                                      onClear: () {
                                        setState(() {
                                          attachment = null;
                                          isAttachmentAdded = false;
                                        });
                                      },
                                    );
                                    isAttachmentAdded = true;
                                  });
                                },
                        ),
                        if (!keyboardOpen) const Text('Link'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.image),
                          onPressed: isAttachmentAdded
                              ? null
                              : () async {
                                  final ImagePicker picker0 = ImagePicker();
                                  final XFile? image = await picker0.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    optionSelected = false;
                                    _pickedImage = image;
                                    attachment = Attachment(
                                        type: 'image',
                                        data: image,
                                        component:
                                            Image.file(File(image!.path)));
                                    isAttachmentAdded = true;
                                  });
                                },
                        ),
                        if (!keyboardOpen) const Text('Image'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.video),
                          onPressed: isAttachmentAdded
                              ? null
                              : () {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? video = picker.pickVideo(
                                      source: ImageSource.gallery) as XFile?;
                                  // Add your action for the video icon here
                                },
                        ),
                        if (!keyboardOpen) const Text('Video'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.chartBar),
                          onPressed: isAttachmentAdded
                              ? null
                              : () {
                                  // Add your action for the poll icon here
                                },
                        ),
                        if (!keyboardOpen) const Text('Poll'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Attachment {
  final String type;
  final dynamic data;
  Widget component;

  Attachment({required this.type, required this.data, required this.component});
}

class URLComponent extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const URLComponent(
      {super.key, required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'URL',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            controller.clear();
            onClear();
          },
        ),
      ),
    );
  }
}

class CommunityBar extends StatelessWidget {
  final String? community;
  final VoidCallback onTap;

  const CommunityBar({super.key, required this.community, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add this line
          children: [
            Row(
              // Wrap the first two widgets in a Row
              children: [
                const Icon(Icons.arrow_drop_down),
                const SizedBox(width: 8), // Add some spacing
                Text(community ?? 'Select a community'),
              ],
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Rules'),
                      content: const Text('This is a dummy popup message.'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Rules'),
            ),
          ],
        ),
      ),
    );
  }
}
