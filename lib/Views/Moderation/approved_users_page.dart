
import 'package:curio/Views/Moderation/user_card.dart';
import 'package:flutter/material.dart';

class ApprovedUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Approved Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle add user
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          UserCard(username: 'user1', time: '1h', reason: 'Approved'),
          UserCard(username: 'user2', time: '2h', reason: 'Approved'),
          // Add more UserCards
        ],
      ),
    );
  }
}
