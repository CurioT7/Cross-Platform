import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddModeratorPage extends StatefulWidget {
  final String subredditName;
  const AddModeratorPage({Key? key, required this.subredditName}) : super(key: key);

  @override
  State<AddModeratorPage> createState() => _AddModeratorPageState();
}

class _AddModeratorPageState extends State<AddModeratorPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _fullPermissions = false;
  bool _manageUsers = false;
  bool _createLifeChat = false;
  bool _managePostsComments = false;
  bool _manageSettings = false;

  Future<void> addModerator( String moderationName,String subredditName, bool manageUsers,bool createLiveChats,bool manageSettings,bool managePostsAndComments,bool everything) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // If token is available, make the post request
      print('Token: $token');
      Map<String, dynamic> response = await ApiServiceMahmoud().inviteModerator(token, moderationName, subredditName, manageUsers, createLiveChats, manageSettings, managePostsAndComments, everything);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Moderator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _usernameController,
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
              title: const Text('createLiveChats'),
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
              title: const Text('manageSettings'),
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
                  print("Username: ${_usernameController.text}");
                  print("Full Permissions: $_fullPermissions");
                  print("Manage Users: $_manageUsers");
                  print("Create Live Chat: $_createLifeChat");
                  print("Manage Posts & Comments: $_managePostsComments");
                  print("Manage Settings: $_manageSettings");
                  addModerator(_usernameController.text, widget.subredditName, _manageUsers, _createLifeChat, _manageSettings, _managePostsComments, _fullPermissions);
                  // Add prints or logic for other permissions similarly
                },
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
