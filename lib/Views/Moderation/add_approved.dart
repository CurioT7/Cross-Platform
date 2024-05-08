import 'package:flutter/material.dart';
class AddApprovedUserPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add an approved user'),
        actions: [
          TextButton(
            child: Text('Add', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              // Handle add user
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixText: 'u/',
                hintText: 'username',
              ),
            ),
            SizedBox(height: 16.0),
            Text('The user will be able to submit content to your community.'),
          ],
        ),
      ),
    );
  }
}