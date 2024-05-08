import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditModeratorPage extends StatefulWidget {
  final String subredditName;
  final String Username;

  const EditModeratorPage({Key? key, required this.subredditName, required this.Username}) : super(key: key);

  @override
  State<EditModeratorPage> createState() => _EditModeratorPageState();
}

class _EditModeratorPageState extends State<EditModeratorPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _fullPermissions = false;
  bool _manageUsers = false;
  bool _createLifeChat = false;
  bool _managePostsComments = false;
  bool _manageSettings = false;

  Future<void> editModerator(String moderationName, String subredditName, bool manageUsers, bool createLiveChats, bool manageSettings, bool managePostsAndComments, bool everything) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // If token is available, make the post request
      print('Token: $token');
      Map<String, dynamic> response = await ApiServiceMahmoud().editPermissions(token, moderationName, subredditName, manageUsers, createLiveChats, manageSettings, managePostsAndComments, everything);

      print(response);
      // Show snackbar based on the response
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.Username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Moderator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _usernameController,
                onChanged: (newValue) {
                  // Update the text controller value when the text field value changes
                  // This will reflect the changes immediately
                },
                decoration: const InputDecoration(
                  labelText: 'Username*',
                  hintText: 'Enter username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            CheckboxListTile(
              title: const Text('Full Permissions'),
              value: _fullPermissions,
              onChanged: (bool? newValue) {
                setState(() {
                  _fullPermissions = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Manage Users'),
              value: _manageUsers,
              onChanged: (bool? newValue) {
                setState(() {
                  _manageUsers = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Create Live Chats'),
              value: _createLifeChat,
              onChanged: (bool? newValue) {
                setState(() {
                  _createLifeChat = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Manage Posts & Comments'),
              value: _managePostsComments,
              onChanged: (bool? newValue) {
                setState(() {
                  _managePostsComments = newValue!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Manage Settings'),
              value: _manageSettings,
              onChanged: (bool? newValue) {
                setState(() {
                  _manageSettings = newValue!;
                });
              },
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to handle submission here
                  editModerator(
                    _usernameController.text,
                    widget.subredditName,
                    _manageUsers,
                    _createLifeChat,
                    _manageSettings,
                    _managePostsComments,
                    _fullPermissions,
                  );
                },
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
