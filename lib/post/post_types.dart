import 'package:flutter/material.dart';

class PostTypesPage extends StatefulWidget {
  @override
  _PostTypesPageState createState() => _PostTypesPageState();
}

class _PostTypesPageState extends State<PostTypesPage> {
  bool _allowImagePosts = false;
  bool _allowPollPosts = false;
  String _postType = 'Any';
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Types'),
        actions: [
          TextButton(
            onPressed:_hasChanges? () {
              // Save state changes
              setState(() {
                _hasChanges = false;
              });
              // pop the screen
              Navigator.pop(context);
            } : null,
            child: Text(
              'Save',
              style: TextStyle(color: _hasChanges ? Colors.blue : Colors.grey),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Post type option'),
            subtitle: const Text(
                'Choose the types of posts you allow in your community'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _postType,
                  style: const TextStyle(color: Colors.lightBlue, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              title: const Text('Any'),
                              subtitle: const Text(
                                  'Allow any type of post: link, text, image, video, or poll'),
                              onTap: () {
                                setState(() {
                                  if(_postType != 'Any') {
                                    _hasChanges = true;
                                  }
                                  _postType = 'Any';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Link Only '),
                              subtitle: const Text('Only allow link posts'),
                              onTap: () {
                                setState(() {
                                  if(_postType != 'Link Only') {
                                    _hasChanges = true;
                                  }
                                  _postType = 'Link Only';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Text Only '),
                              subtitle: const Text('Only allow text posts'),
                              onTap: () {
                                setState(() {
                                  if(_postType != 'Text Only') {
                                    _hasChanges = true;
                                  }
                                  _postType = 'Text Only';
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.lightBlue,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Image posts'),
            subtitle: const Text(
                'Allow images uploaded directly to Reddit as well as links to popular image hosting sites such as imgur'),
            value: _allowImagePosts,
            onChanged: (bool value) {
              setState(() {
                if(_allowImagePosts != value) {
                  _hasChanges = true;
                }
                _allowImagePosts = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Poll posts'),
            subtitle: const Text('Allow poll posts in your community'),
            value: _allowPollPosts,
            onChanged: (bool value) {
              setState(() {
                if(_allowPollPosts != value) {
                  _hasChanges = true;
                }
                _allowPollPosts = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
