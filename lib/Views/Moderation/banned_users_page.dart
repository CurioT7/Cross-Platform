import 'package:curio/Views/Moderation/add_banned.dart';
import 'package:curio/Views/Moderation/user_card.dart';
import 'package:curio/services/ModerationService.dart';
import 'package:flutter/material.dart';

class BannedUsersPage extends StatefulWidget {
  final String subredditName;

  BannedUsersPage({required this.subredditName});

  @override
  _BannedUsersPageState createState() => _BannedUsersPageState();
}

class _BannedUsersPageState extends State<BannedUsersPage> {
  late Future<dynamic> futureBannedUsers;

  @override
  void initState() {
    super.initState();
    futureBannedUsers = ApiService().getBannedUsers(widget.subredditName);
  }

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
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBannedUserPage(subredditName: widget.subredditName)),
              );
              setState(() {
                futureBannedUsers = ApiService().getBannedUsers(widget.subredditName);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
  future: futureBannedUsers,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<dynamic> bannedUsers = snapshot.data['bannedUsers'] ?? [];
      return ListView(
        children: bannedUsers.map((user) {
          var banDetails = user['banDetails'][0];
          return UserCard(
            username: banDetails['bannedUsername'],
            reason: banDetails['violation'],
            modNote: banDetails['modNote'],
            userMessage: banDetails['userMessage'],
            linkedSubreddit: widget.subredditName,
            isBanned: true,
            onUnban: () {
              setState(() {
                futureBannedUsers = ApiService().getBannedUsers(widget.subredditName);
              });
            },
          );
        }).toList(),
      );
    }
  },
),
    );
  }
}