import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curio/post/post_to_page.dart';
import '../widgets/community_bar.dart';
import '../widgets/poll_component.dart';
import 'package:curio/Models/community_model.dart';
import 'package:curio/widgets/tags.dart';

class AddPostScreen extends StatefulWidget {
  final String type;
  const AddPostScreen({super.key, required this.type});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final selectedTags = <String>[];
  bool optionSelected = false; // Add this line
  bool isAttachmentAdded = false; // Add this line
  late Community selectedCommunity;
  bool isCommunitySelected = false;
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
  void initState() {
    super.initState();
    selectedCommunity = Community(
      id: 'Community ID',
      name: 'Community Name',
      description: 'Community Description',
      posts: [],
      isOver18: false,
      privacyMode: 'Public',
      isNSFW: false,
      isSpoiler: false,
      isOC: false,
      isCrosspost: false,
      rules: [],
      category: 'Category',
      language: 'Language',
      allowImages: true,
      allowVideos: true,
      allowText: true,
      allowLink: true,
      allowPoll: true,
      allowEmoji: true,
      allowGif: true,
      members: [],
      moderators: [],
      createdAt: DateTime.now().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final icons = [
      Icons.home,
      Icons.star,
      Icons.school,
      Icons.work
    ]; // Add more icons as needed
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
                        if (isCommunitySelected) {
                          // TODO: Add the post to the selected community
                          // call the api to add the post to the selected community
                        } else {
                          selectedCommunity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PostToPage(),
                            ),
                          );
                          setState(() {
                            isCommunitySelected = true;
                          });
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
                child: // I want make it Post when the selected Community is set and Post whenn the selecetcommunity is not set
                    Text(isCommunitySelected ? 'Post' : 'Next'),
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
                if (isCommunitySelected)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          // Add this line
                          child: CommunityBar(
                              community: selectedCommunity.name,
                              communityId: selectedCommunity
                                  .id, // TODO: Change this to the actual community ID
                              onTap: () async {
                                // ignore: unused_local_variable
                                selectedCommunity = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PostToPage(),
                                  ),
                                );
                                setState(() {
                                  isCommunitySelected = true;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 0 + (selectedTags.isNotEmpty ? 50 : 0),
                  child: Builder(
                    builder: (context) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warning,
                                    size: 20), // Add this line
                                ...selectedTags
                                    .map(
                                      (tag) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
                SizedBox(
                  height: 0 + (isCommunitySelected ? 50 : 0),
                  child: Builder(
                    builder: (context) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return TagBottomSheet(
                                  onDismiss: (List<String> selectedTags) {
                                    // Handle selectedTags list here
                                    setState(
                                      () {
                                        this.selectedTags.clear();
                                        this.selectedTags.addAll(selectedTags);
                                      },
                                    );
                                  },
                                  selectedTags: this.selectedTags,
                                );
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300], // text color
                          ),
                          child: const Text(
                            'tags(optional)',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 0 +
                      (attachment != null && attachment?.type != 'poll'
                          ? 50
                          : 0),
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
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
                          if (attachment?.type == 'poll' && attachment != null)
                            SizedBox(
                              height: 200, // Set the height to 200
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
                        ],
                      ),
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
                                  setState(() {
                                    attachment = Attachment(
                                      type: 'poll',
                                      data: null,
                                      component: PollComponent(
                                        onClear: () {
                                          setState(() {
                                            attachment = null;
                                            isAttachmentAdded = false;
                                          });
                                        },
                                      ),
                                    );
                                    isAttachmentAdded = true;
                                  });
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
