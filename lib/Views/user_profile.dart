import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;

  const UserProfilePage({
    required this.userId,
    required this.isCurrentUser,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isFollowing = false;
  String _message = '';
  int _selectedIndex = 0;

  static const List<String> _sections = ['Posts', 'Comments', 'About'];

  Future<void> _toggleFollow() async {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _message = 'You started following the user.';
      } else {
        _message = 'You unfollowed the user.';
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showReportProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What do you want to report?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Username'),
                onTap: () {
                  // Handle selecting username
                },
              ),
              ListTile(
                title: Text('Avatar/Profile Image'),
                onTap: () {
                  // Handle selecting avatar/profile image
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User reported.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                _showReportProfileDialog(context);
              } else {
                // Handle other actions
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'message',
                  child: Text('Send a Message'),
                ),
                PopupMenuItem(
                  value: 'custom_feed',
                  child: Text('Add to Custom Feed'),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Text('Block'),
                ),
                PopupMenuItem(
                  value: 'report',
                  child: Text('Report Profile'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage('https://placeholder.com/150'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _toggleFollow();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_message),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    _isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'username',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: BottomNavigationBar(
                items: _sections.map((section) {
                  return BottomNavigationBarItem(
                    icon: Icon(Icons.accessibility_new),
                    label: section,
                  );
                }).toList(),
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.black,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}