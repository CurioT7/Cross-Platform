import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:curio/Models/post.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Models/comment.dart';
class editComment extends StatefulWidget {
  final String postID;
  final String commentId;
  editComment({ required this.postID, required this.commentId});
  @override
  _editCommentState createState() => _editCommentState();
}

class _editCommentState extends State<editComment> {
  Comment? _comment;

  @override
  void initState() {
    super.initState();
    _fetchComment();
  }
  Future<void> _fetchComment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token is null');
    }
    logicAPI api = logicAPI();
    Comment comment = await api.fetchCommentByID(widget.commentId );
    setState(() {
      _comment = comment;
      _commentController.text = comment.content;
    });
  }
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
        title: Text('Edit comment', style: TextStyle(fontSize: 18,)),
      ),
      body: Column(
          children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
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
        onPressed: _updateComment,
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

  Future<void> _updateComment() async {
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
        api.updateComment(widget.commentId, _commentController.text, token);
        Navigator.of(context).pop();

      }
      catch(e){
        print(e);
      }

    }
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