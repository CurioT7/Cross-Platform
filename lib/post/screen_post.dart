import 'dart:io';
import 'package:curio/services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curio/post/post_to_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/community_bar.dart';
import 'package:curio/Models/community_model.dart';
import 'package:curio/widgets/tags.dart';
import 'package:curio/widgets/poll_component.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

Future<void> uploadImage(XFile imageFile) async {
  var request =
      http.MultipartRequest('POST', Uri.parse('your_server_endpoint_here'));

  request.files.add(await http.MultipartFile.fromPath(
    'image', // consider 'image' as the key for the image file in your server
    imageFile.path,
  ));

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Image uploaded");
  } else {
    print("Image upload failed");
  }
}

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
  XFile? _pickedVideo;

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
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom >
        0; // Add more icons as needed
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
                          String type = attachment != null ? attachment!.type : 'post';
                          if(type == 'image' || type == 'video') {
                            type = 'media';
                          }
                          List<String>? options = [];
                          String? voteLength = '';

                          if(type == 'poll'){
                            // get the options list
                          options = (attachment!.component as PollComponent).getOptions();
                          print(options);

                          voteLength = (attachment!.component as PollComponent).getSelectedOption();
                          }

                          Map<String, dynamic> post = {
                            'title': titleController.text,
                            'content': descriptionController.text,
                            'isNSFW': selectedTags.contains('NSFW'),
                            'isSpoiler': selectedTags.contains('Spoiler'),
                            'isOC': selectedTags.contains('isOC'),
                            'subreddit': selectedCommunity.name,
                            // 'destination': "subreddit",
                            'type': type,
                          };
                          //check if the attachment has been added
                          if (attachment != null && attachment!.type == 'url') {
                            // print the attachment type
                            post['media'] = attachment!.data;
                          }
                          if(type=='poll'){
                            post['Options'] = options;
                            post['voteLength'] = voteLength;
                          }

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final String token = prefs.getString('token')!;
                          final response = await ApiService().submitPost(
                              post, token, _pickedImage ?? (_pickedVideo));
                          if (response['success'] == true) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response['message']),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 700),
              child: SingleChildScrollView(
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
                                  communityId: selectedCommunity.id,
                                  onTap: () async {
                                    // ignore: unused_local_variable
                                    selectedCommunity = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PostToPage(),
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
                                            this
                                                .selectedTags
                                                .addAll(selectedTags);
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
                          (attachment != null
                              ? attachment!.type == "poll"
                                  ? 200
                                  : 50
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
                      SingleChildScrollView(
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
                          ],
                        ),
                      ),
                  ],
                ),
              ),
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
                                    attachment!.component = ImageComponent(
                                      image: image,
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
                        if (!keyboardOpen) const Text('Image'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.video),
                          onPressed: isAttachmentAdded
                              ? null
                              : () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? video = await picker.pickVideo(
                                      source: ImageSource.gallery);
                                  if (video != null) {
                                    setState(() {
                                      _pickedVideo = video;
                                      attachment = Attachment(
                                        type: 'video',
                                        data: video,
                                        component: VideoComponent(
                                          video: video,
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
                                  }
                                },
                        ),
                        if (!keyboardOpen) const Text('Video'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.poll),
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
                                        pollComponentKey: GlobalKey(),
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

class ImageComponent extends StatelessWidget {
  final XFile image;
  final VoidCallback onClear;

  const ImageComponent({super.key, required this.image, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(File(image.path)),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClear,
          ),
        ),
      ],
    );
  }
}

class VideoComponent extends StatelessWidget {
  final XFile video;
  final VoidCallback onClear;

  const VideoComponent({super.key, required this.video, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController controller =
        VideoPlayerController.file(File(video.path));
    controller.initialize();
    return Stack(
      children: [
        VideoPlayer(controller),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClear,
          ),
        ),
      ],
    );
  }
}
