import 'package:flutter/material.dart';
import 'package:curio/services/api_service.dart';

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
  Map<String, dynamic> _userData = {};

  static const List<String> _sections = ['Posts', 'Comments', 'About'];

  Future<void> _toggleFollow() async {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _message = 'You started following lofi.';
      } else {
        _message = 'You unfollowed lofi.';
      }
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
                title: Text('User'),
                onTap: () {
                  _reportUser();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Avatar/Profile Image'),
                onTap: () {
                  _reportProfileImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reportUser() async {
    try {
      final response = await ApiService().reportUser();
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      print('Error reporting user: $e');
    }
  }

  void _reportProfileImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile image reported.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _fetchUserProfile() async {
    try {
      // Fetch user profile data here
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _sections.length,
      child: Scaffold(
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
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'lib/assets/images/loft.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          _toggleFollow ();
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
                        'lofi', // Display username here
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _userData['displayName'] ?? '',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            TabBar(
              tabs: _sections.map((section) {
                return Tab(
                  text: section,
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Text(''), // Removed 'Posts'
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 16.0),
                        Text(
                          '', // Removed 'Comments'
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  _userData['postKarma'].toString() ?? '0',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Post Karma'),
                              ],
                            ),
                            SizedBox(width: 125.0), // Add space here
                            Column(
                              children: [
                                Text(
                                  _userData['commentKarma'].toString() ?? '0',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Comment Karma'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40.0), // Adjust spacing as needed
                        // Send Message button
                        ListTile(
                          leading: Icon(Icons.mail),
                          title: Text('Send Message'),
                          onTap: () {
                            // Handle Send Message action
                          },
                        ),
                        SizedBox(height: 0.0), // Adjust spacing as needed
                        // Start Chat button
                        ListTile(
                          leading: Icon(Icons.chat),
                          title: Text('Start Chat'),
                          onTap: () {
                            // Handle Start Chat action
                          },
                        ),
                        SizedBox(height: 0.0), // Adjust spacing as needed
                        // Trophies bar
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Trophies',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

