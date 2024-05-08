import 'package:curio/services/ModerationService.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String username;
  final String reason;
  final String modNote;
  final String userMessage;
  final bool isApproved;
  final bool isBanned;
  final String linkedSubreddit;
  final Function? onUnban;


  UserCard({
    this.username = '',
    this.reason = '',
    this.modNote = '',
    this.userMessage = '',
    this.isApproved = false,
    this.isBanned = false,
    this.linkedSubreddit = '',
    this.onUnban,
  });

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text('u/${widget.username}'),
        subtitle: widget.isApproved ? null : Text('Reason: ${widget.reason}\nMod Note: ${widget.modNote}\nUser Message: ${widget.userMessage}\nSubreddit: ${widget.linkedSubreddit}'),
        trailing: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.mail),
                      title: Text('Send Message'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        //Navigate to message screen with username as argument
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('View Profile'),
                      onTap: () {
                        // Handle view profile
                      },
                    ),
                    if (widget.isBanned)
                      ListTile(
                        leading: Icon(Icons.gavel , color: Colors.red),
                        title: Text('Unban', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          await ApiService().unbanUser(widget.linkedSubreddit, widget.username);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User has been unbanned successfully')),
                          );
                          if (widget.onUnban != null) {
                            widget.onUnban!();
                          }
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