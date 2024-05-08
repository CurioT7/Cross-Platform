import 'package:curio/services/ModerationService.dart';
import 'package:flutter/material.dart';

class AddBannedUserPage extends StatefulWidget {
  final String subredditName;

  AddBannedUserPage({required this.subredditName});

  @override
  _AddBannedUserPageState createState() => _AddBannedUserPageState();
}

class _AddBannedUserPageState extends State<AddBannedUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _modNotesController = TextEditingController();
  final TextEditingController _banMessageController = TextEditingController();
  String _banReason = 'Spam';

  final ApiService _apiService = ApiService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add a banned user'),
        actions: [
          TextButton(
            child: Text('Add', style: TextStyle(color: Colors.blue)),
            onPressed: () async {
              // Handle add user
              String subredditName = widget.subredditName;
              String userToBan = _usernameController.text;
              String violation = _banReason;
              String modNote = _modNotesController.text;
              String userMessage = _banMessageController.text;

              var response = await _apiService.banUser(subredditName, userToBan, violation, modNote, userMessage);

              if (response.statusCode == 200) {
                // User was banned successfully
                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User banned successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Close the page after 2 seconds
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
              } else {
                // An error occurred
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${response.statusCode}'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username'),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'u/',
                  prefixStyle: TextStyle(color: Colors.black),
                  hintText: 'username',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Reason for ban'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _banReason,
                onChanged: (String? newValue) {
                  setState(() {
                    _banReason = newValue!;
                  });
                },
                items: <String>['Spam', 'Personal and Confidential Information', 'Threatening, Harassing, or Inciting Violence']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              ),
              SizedBox(height: 16.0),
              Text('Mod notes'),
              TextField(
                controller: _modNotesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Only mods will see this',
                ),
              ),
              SizedBox(height: 16.0),
              Text('Note to include in ban message'),
              TextField(
                controller: _banMessageController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'The user will receive this note in a message',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}