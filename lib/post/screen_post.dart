import 'dart:io';
import 'package:curio/post/schudledPostPage.dart';
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
import 'package:curio/post/shcudlesheet.dart';

Future<void> uploadImage(File imageFile) async {
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

String validatePost(Map<String, dynamic> post, Community community) {
  // Check if images are allowed and if the post type is 'image'
  if (!community.allowImages && post['type'] == 'media' ||
      !community.allowVideos && post['type'] == 'media') {
    return 'Images and videos are not allowed in this community';
  }
  // Check if text posts are allowed and if the post type is 'text'
  if (!community.allowText && post['content'] != '') {
    return 'Text posts are not allowed in this community';
  }

  // Check if link posts are allowed and if the post type is 'link'
  if (!community.allowLink && post['type'] == 'link') {
    return 'Link posts are not allowed in this community';
  }

  // Check if poll posts are allowed and if the post type is 'poll'
  if (!community.allowPoll && post['type'] == 'poll') {
    return 'Poll posts are not allowed in this community';
  }

  // Check if the post contains any tags that are not allowed in the community
  if (!community.isNSFW && post['isNSFW'] ||
      !community.isSpoiler && post['isSpoiler'] ||
      !community.isOC && post['isOC']) {
    return 'The post contains tags that are not allowed in this community';
  }
  // If all checks pass, return true
  return '';
}

class AddPostScreen extends StatefulWidget {
  final String type;
  final bool isScheduled;
  final Map<String, dynamic> post;
  final Map<String, dynamic> subreddit;
  final bool canChooseCommunity;
  final bool editingPost;
  final bool schudlePostEdit;

  const AddPostScreen(
      {super.key,
      required this.type,
      this.isScheduled = false,
      this.post = const {},
      this.subreddit = const {},
      this.editingPost = false,
      this.schudlePostEdit = false,
      this.canChooseCommunity = true});
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;
  List<String>? selectedTags;
  late bool isAttachmentAdded;
  late Community selectedCommunity;
  late bool isCommunitySelected;
  File? image;
  File? video;
  Attachment? attachment;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void handleTap() async {
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
  }

  Future<void> _submitPost(Map<String, dynamic> post) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    var media = post['type'] == 'media' ? image ?? video : null;
    final response = await ApiService().submitPost(post, token, media);
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
  }

  Future<void> _editSchudledPost(Map<String, dynamic> post) async {
    var content = post['content'];
    var id = widget.post['_id'];
    // call the api to save the post
    var success = await ApiService().editScheduledPost(id, content);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduledPostsPage(
              post: post, community: {'subreddit': selectedCommunity}),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to schedule post'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _editPost(Map<String, dynamic> post) async {
    var id = widget.post['id'];
    var content = post['content'];
    var success = await ApiService().editusertext(id, content);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to edit post'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> fetchCommunityDetails() async {
    if (widget.editingPost) {
      selectedCommunity = await ApiService()
          .fetchCommunityByName(widget.subreddit['subreddit']);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    selectedCommunity = Community(
      id: 'Community ID',
      name: 'Community Name',
      description: 'Community Description',
      posts: [],
      icon: "",
      banner: "",
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
    titleController = TextEditingController(
      text: widget.post['title'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.post['content'] ?? '',
    );
    linkController = TextEditingController(
      text: widget.post['type'] == 'link' ? widget.post['media'] : '',
    );

    selectedTags = [];
    if (widget.post['isNSFW'] != null && widget.post['isNSFW']) {
      selectedTags!.add('NSFW');
    }
    if (widget.post['isSpoiler'] != null && widget.post['isSpoiler']) {
      selectedTags!.add('Spoiler');
    }
    if (widget.post['isOC'] != null && widget.post['isOC']) {
      selectedTags!.add('OC');
    }
    // check if the media is there if it is there then make it true
    isAttachmentAdded = widget.post['media'] != null;
    isCommunitySelected = widget.subreddit['subreddit'] != null;
    if (widget.subreddit['subreddit'] != null &&
        widget.subreddit['subreddit'] is Community) {
      selectedCommunity = widget.subreddit['subreddit'];
    } else {
      selectedCommunity = Community(
        id: '1', // Change this to the actual community id
        name: widget.subreddit['subreddit'] ?? 'General',
        allowImages: true,
        allowVideos: true,
        allowText: true,
        allowLink: true,
        allowPoll: true,
        isNSFW: true,
        isSpoiler: true,
        isOC: true,
        description: '',
        posts: [],
        isOver18: false,
        privacyMode: 'public',
        members: [],
        moderators: [],
        createdAt: '1',
        isCrosspost: false,
        rules: [],
        category: 'General',
        language: 'English',
        allowEmoji: false,
        allowGif: true,
        icon: 'assets/images/loft.png', banner: 'assets/images/loft.png',
      );
      fetchCommunityDetails();
    }
    if (widget.post['type'] == 'media') {
      if (widget.post['media'] is ImageComponent) {
        isAttachmentAdded = true;
        attachment = Attachment(
          type: 'image',
          data: null,
          component: ImageComponent(
            image: widget.post['media'].image,
            onClear: () {
              setState(() {
                attachment = null;
                isAttachmentAdded = false;
              });
            },
          ),
        );
      } else if (widget.post['media'] is VideoComponent) {
        isAttachmentAdded = true;
        attachment = Attachment(
          type: 'video',
          data: null,
          component: VideoComponent(
            video: widget.post['media'].video,
            onClear: () {
              setState(() {
                attachment = null;
                isAttachmentAdded = false;
              });
            },
          ),
        );
      } else if (widget.post['media'] is VideoComponent) {
        isAttachmentAdded = true;
        attachment = Attachment(
          type: 'video',
          data: null,
          component: VideoComponent(
            video: widget.post['media'],
            onClear: () {
              setState(() {
                attachment = null;
                isAttachmentAdded = false;
              });
            },
          ),
        );
      }
    } else if (widget.post['type'] == 'poll') {
      isAttachmentAdded = true;
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
    } else if (widget.post['type'] == 'link') {
      isAttachmentAdded = true;
      linkController = TextEditingController(
        text: widget.post['media'],
      );
      attachment = Attachment(
        type: 'link',
        data: widget.post['media'],
        component: URLComponent(
          controller: linkController,
          onClear: () {
            setState(() {
              attachment = null;
              isAttachmentAdded = false;
            });
          },
        ),
      );
    } else {
      attachment = Attachment(type: 'post', data: null, component: Container());
      isAttachmentAdded = false;
    }
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
                          dynamic media;
                          String type =
                              attachment != null ? attachment!.type : 'post';
                          if (type == 'image' || type == 'video') {
                            type = 'media';
                          }
                          List<String>? options = [];
                          String? voteLength = '';

                          if (type == 'poll') {
                            // get the options list
                            options = (attachment!.component as PollComponent)
                                .getOptions();

                            voteLength =
                                (attachment!.component as PollComponent)
                                    .getSelectedOption();
                            // split the vote length string "1 day" to get the number of days into just 1
                            voteLength = voteLength!.split(' ')[0];
                          }

                          Map<String, dynamic> post = {
                            'title': titleController.text,
                            'content': descriptionController.text,
                            'isNSFW': selectedTags!.contains('NSFW'),
                            'isSpoiler': selectedTags!.contains('Spoiler'),
                            'isOC': selectedTags!.contains('isOC'),
                            'subreddit': selectedCommunity.name,
                            'type': type,
                          };
                          //check if the attachment has been added
                          if (attachment != null &&
                              attachment!.type == 'link') {
                            post['media'] = linkController.text;
                          }
                          if (type == 'poll') {
                            post['options'] = options!.join(',');
                            post['voteLength'] = voteLength;
                            post['media'] = 'assets/images/poll.png';
                          }
                          String validate =
                              validatePost(post, selectedCommunity);
                          if (validate != '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors
                                    .blue, // Change this to your desired color
                                content: Text(
                                  validate,
                                  style: const TextStyle(
                                      color: Colors
                                          .white), // Change this to your desired style
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                          if (widget.isScheduled && !widget.schudlePostEdit) {
                            if (post['type'] == 'media') {
                              print("Schdeuling media post");
                              print(
                                  "The component is ${attachment?.component}");
                              post['media'] = attachment?.component;
                            }
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return PostSettingsBottomSheet(
                                    post: post,
                                    community: {
                                      'subreddit': selectedCommunity,
                                    });
                              },
                            );
                          } else {
                            if (widget.schudlePostEdit) {
                              print("Editing the schudled post");
                              _editSchudledPost(post);
                            } else if (widget.editingPost) {
                              _editPost(post);
                            } else {
                              _submitPost(post);
                            }
                          }
                        } else if (!isCommunitySelected &&
                            widget.canChooseCommunity) {
                          print("Navigating to the post to page");
                          print(
                              "widget.canChooseCommunity ${widget.canChooseCommunity}");
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
                    Text(isCommunitySelected
                        ? widget.isScheduled
                            ? 'Schedule'
                            : 'Post'
                        : 'Next'),
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
                                communityIcon: selectedCommunity.icon?.toString() ??
                                    'https://example.com/default_image.png',
                                onTap: widget.canChooseCommunity
                                    ? handleTap
                                    : () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 0 + (selectedTags!.isNotEmpty ? 50 : 0),
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
                                    ...selectedTags!
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
                                            this.selectedTags!.clear();
                                            this
                                                .selectedTags!
                                                .addAll(selectedTags);
                                          },
                                        );
                                      },
                                      selectedTags: selectedTags!,
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
                          (attachment != null && isAttachmentAdded
                              ? attachment!.type == "poll" ||
                                      attachment!.type == "video"
                                  ? 200
                                  : 50
                              : 0),
                      child: Visibility(
                        visible: attachment != null && isAttachmentAdded,
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
                                  final dynamic image = (await picker0
                                      .pickImage(source: ImageSource.gallery));
                                  if (image != null) {
                                    final dynamic imageFile = File(image.path);
                                    setState(() {
                                      attachment = Attachment(
                                          type: 'image',
                                          data: image,
                                          component: Image.file(imageFile));
                                      attachment!.component = ImageComponent(
                                        image: imageFile,
                                        onClear: () {
                                          setState(() {
                                            attachment = null;
                                            isAttachmentAdded = false;
                                          });
                                        },
                                      );
                                      isAttachmentAdded = true;
                                      this.image = imageFile;
                                    });
                                  }
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
                                  final dynamic video = (await picker.pickVideo(
                                      source: ImageSource.gallery));
                                  if (video != null) {
                                    final File videoFile = File(video.path);
                                    setState(() {
                                      attachment = Attachment(
                                        type: 'video',
                                        data: video,
                                        component: VideoComponent(
                                          video: videoFile,
                                          onClear: () {
                                            setState(() {
                                              attachment = null;
                                              isAttachmentAdded = false;
                                            });
                                          },
                                        ),
                                      );
                                      isAttachmentAdded = true;
                                      this.video = videoFile;
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
                          icon: const Icon(FontAwesomeIcons.squarePollVertical),
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

class ImageComponent extends StatefulWidget {
  final File image;
  final VoidCallback onClear;

  ImageComponent({Key? key, required this.image, required this.onClear})
      : super(key: key);
  Map<String, dynamic> toJson() => {
        'image': image.path,
      };
  @override
  _ImageComponentState createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  late Future<File> _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = _loadImageFromHDD();
  }

  Future<File> _loadImageFromHDD() async {
    // Load image from local storage
    return widget.image;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoComponent{video: ${widget.image.path}}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Stack(
              children: [
                Image.file(snapshot.data!),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: widget.onClear,
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}

class VideoComponent extends StatefulWidget {
  final File video;
  final VoidCallback onClear;

  Map<String, dynamic> toJson() => {
        'video': video.path,
      };
  VideoComponent({Key? key, required this.video, required this.onClear})
      : super(key: key);

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  late Future<VideoPlayerController> _controller;
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoComponent{video: ${widget.video.path}}';
  }

  @override
  void initState() {
    super.initState();
    _controller = _loadVideoFromHDD();
  }

  Future<VideoPlayerController> _loadVideoFromHDD() async {
    // Load video from local storage
    final VideoPlayerController controller =
        VideoPlayerController.file(widget.video);
    await controller.initialize();
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoPlayerController>(
      future: _controller,
      builder: (BuildContext context,
          AsyncSnapshot<VideoPlayerController> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Stack(
              children: [
                VideoPlayer(snapshot.data!),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: widget.onClear,
                  ),
                ),
              ],
            );
          }
        }
      },
    );
  }
}
