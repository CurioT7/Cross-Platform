import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notificationModel.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late Future<List<NotificationModel>> readNotifications;

  @override
  void initState() {
    super.initState();
    initializeReadNotifications();
  }

  Future<void> initializeReadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    if (token == null) {
      throw Exception('Token is null');
    } else {
      readNotifications = logicAPI().getReadNotifications(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        tileColor: Colors.white,
        leading: Image.asset(
            "lib/assets/images/example.jpg"), // replace with the URL of your image
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 8.0),
                Text(
                  widget.notification.title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.notification.timestamp != null
                      ? timeago.format(widget.notification.timestamp)
                      : 'Unknown time',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 8),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.notification.message,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 9.0, bottom: 8.0),
                            child: Text(
                              "Manage Notifications",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const Divider(color: Colors.grey, thickness: 0.5),
                        ListTile(
                          leading: Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.grey.shade500,
                          ),
                          title: const Text("Hide this notification",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                        ListTile(
                          leading: Icon(Icons.highlight_off_outlined,
                              color: Colors.grey.shade500),
                          title: const Text(
                              "Disable updates from this community",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications_off_outlined,
                              color: Colors.grey.shade500),
                          title: const Text("Turn off this notification type",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.95,
                                  40), // adjust the height as needed
                            ),
                            child: const Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
