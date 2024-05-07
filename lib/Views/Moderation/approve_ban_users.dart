import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String time;
  final String reason;
  final bool isBanned;

  UserCard({
    required this.username,
    required this.time,
    required this.reason,
    this.isBanned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text('u/$username'),
        subtitle: Text('$time • $reason'),
        trailing: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (isBanned)
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('See Details'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Handle see details
                        },
                      )
                    else
                      ListTile(
                        leading: Icon(Icons.mail),
                        title: Text('Send Message'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Handle send message
                        },
                      ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('View Profile'),
                      onTap: () {
                        // Handle view profile
                      },
                    ),
                    if (isBanned)
                      ListTile(
                        leading: Icon(Icons.gavel , color: Colors.red),
                        title: Text('Unban', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          // Handle unban
                        },
                      )
                    else
                      ListTile(
                        leading: Icon(Icons.close , color: Colors.red),
                        title: Text('Remove', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          // Handle remove
                        },
                      ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
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

class BannedUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Banned Users'),
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
          UserCard(username: 'user1', time: '1h', reason: 'Banned', isBanned: true),
          UserCard(username: 'user2', time: '2h', reason: 'Banned', isBanned: true),
          // Add more UserCards
        ],
      ),
    );
  }
}