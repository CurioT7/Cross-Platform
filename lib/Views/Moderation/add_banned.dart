import 'package:flutter/material.dart';

class AddBannedUserPage extends StatefulWidget {
  @override
  _AddBannedUserPageState createState() => _AddBannedUserPageState();
}

class _AddBannedUserPageState extends State<AddBannedUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _modNotesController = TextEditingController();
  final TextEditingController _banMessageController = TextEditingController();
  String _banReason = 'Spam';

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
            onPressed: () {
              // Handle add user
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