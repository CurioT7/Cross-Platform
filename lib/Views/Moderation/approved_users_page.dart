
import 'package:curio/Views/Moderation/add_approved.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddApprovedUserPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          UserCard(
            username: 'john_doe',
            isApproved: true,  
          ),
          UserCard(
            username: 'jane_doe',
            isApproved: true,  
          ),
        ],
      ),
    );
  }
}
