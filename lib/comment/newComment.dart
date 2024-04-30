import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:curio/Models/post.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class newComment extends StatefulWidget {
  final Post post;
  newComment({required this.post});

  @override
  _newCommentState createState() => _newCommentState();
}

class _newCommentState extends State<newComment> {
  final linkController = TextEditingController();
  bool optionSelected = false; // Add this line
  bool isAttachmentAdded = false; // Add this line
  bool isCommunitySelected = false;
  Attachment? attachment;
  XFile? _pickedImage;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _isAttachmentAdded = false;
  String _attachmentType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Comment', style: TextStyle(fontSize: 18,)),
      ),

      body: Column(
        children: <Widget>[

          Divider(color: Colors.grey[300]),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.post.title, // Access the post title from the widget
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.expand_more),
                  onPressed: () => _showBottomSheet(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
              ),


              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Your comment',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitComment,
        child: Icon(Icons.send),
      ),
    );
  }

  void _showDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add $type'),
          content: TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'URL',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _isAttachmentAdded = true;
                  _attachmentType = type;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isNotEmpty || _urlController.text.isNotEmpty) {
      print('Comment: ${_commentController.text}');
      print('$_attachmentType URL: ${_urlController.text}');
      logicAPI api = logicAPI();
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        if (token == null) {
          throw Exception('Token is null');
        }
        api.postComment(widget.post.id, _commentController.text, token);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          //height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'ORIGINAL POST',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10), // Add some space

                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.post.content,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

