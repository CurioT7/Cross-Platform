import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/Notifications/notificationModel.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;

  NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  List<String> readNotificationIds = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      initializeReadNotifications();
    });
    //initializeReadNotifications();
  }

  Future<List<String>> initializeReadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token is null');
    } else {
      setState(() {});
      return logicAPI().getReadNotifications(token);

    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: initializeReadNotifications(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          List<String> readNotificationIds = snapshot.data!;

           return Card(
            child: ListTile(
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('token');
                if (token != null) {
                  try {
                    await logicAPI().markNotificationAsRead(token, widget.notification.id);
                    print('Notification marked as read');
                    List<String> updatedReadNotifications = await logicAPI().getReadNotifications(token);
                    setState(() {
                      readNotificationIds = updatedReadNotifications;
                    });
                    // Update the list of read notifications and rebuild the widget
                    await initializeReadNotifications();
                  } catch (e) {
                    print('Failed to mark notification as read: $e');
                  }
                }
              },
              contentPadding: const EdgeInsets.all(8.0),
              tileColor: readNotificationIds.contains(widget.notification.id)
                  ? Colors.grey.shade300
                  : Colors.blue.shade50,
              leading: Image.asset("lib/assets/images/example.jpg"),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 8.0),
                      Text(
                        widget.notification.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        widget.notification.timestamp != null
                            ? '${timeago.format(widget.notification.timestamp)}'
                            : 'Unknown time',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 8),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.notification.message,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 9.0, bottom: 8.0),
                                  child: Text(
                                    "Manage Notifications",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Divider(color: Colors.grey, thickness: 0.5),
                              ListTile(
                                leading: Icon(Icons.visibility_off_outlined, color: Colors.grey.shade500,),
                                title: Text("Hide this notification", style: TextStyle(color: Colors.black, fontSize: 14)),
                              ),
                              ListTile(
                                leading: Icon(Icons.highlight_off_outlined, color: Colors.grey.shade500),
                                title: Text("Disable updates from this community", style: TextStyle(color: Colors.black, fontSize: 14)),
                              ),
                              ListTile(
                                leading: Icon(Icons.notifications_off_outlined, color: Colors.grey.shade500),
                                title: Text("Turn off this notification type", style: TextStyle(color: Colors.black, fontSize: 14)),
                              ),
                              Center(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    side: BorderSide(color: Colors.grey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 40),
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
    else {
          // return a CircularProgressIndicator if data is not yet available
          return Container();
        }
      },
    );
  }
}