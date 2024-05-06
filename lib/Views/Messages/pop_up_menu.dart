import 'package:curio/Views/Messages/new_message_screen.dart';
import 'package:curio/Views/insettingspage/notificationSettings.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('New message'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewMessageScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.markunread),
                    title: Text('Mark all Inbox tabs as read'),
                    onTap: () {
                      // Handle mark all as read action here
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Edit notification settings'),
                    onTap: () { 
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>NotificationSettingsPage()),
                    );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}