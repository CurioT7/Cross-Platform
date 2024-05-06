import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/Notifications/notificationModel.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onHidden;
  NotificationCard({Key? key, required this.notification, required this.onHidden}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isVisible = true;
  bool isUnhidden = false;
  Future<List<String>> readNotificationIds = Future.value([]);
  Color tileColor = Colors.blue.shade50;
  @override
  void initState() {
    super.initState();
    initializeReadNotifications().then((readNotificationIds) {
      setState(() {
        tileColor = readNotificationIds.contains(widget.notification.id)
            ? Colors.grey.shade300
            : Colors.blue.shade50;
      });
    });

    //initializeReadNotifications();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeReadNotifications().then((readNotificationIds) {
      setState(() {

        tileColor = readNotificationIds.contains(widget.notification.id)
            ? Colors.grey.shade300
            : Colors.blue.shade50;
      });
    });
  }

  Future<List<String>> initializeReadNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token is null');
    } else {
      setState(() {
        this.readNotificationIds = readNotificationIds;

      });
      return logicAPI().getReadNotifications(token);

    }
  }
  Future<void> markNotificationAsReadAndUpdateList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      try {
        await logicAPI().markNotificationAsRead(token, widget.notification.id);
        print('Notification marked as read');
        Future<List<String>> updatedReadNotifications =  logicAPI().getReadNotifications(token);
        setState(() {
          readNotificationIds = updatedReadNotifications;

          tileColor=Colors.grey.shade300;
        });
      } catch (e) {
        print('Failed to mark notification as read: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          await markNotificationAsReadAndUpdateList();
          setState(() {
            tileColor = Colors.grey.shade300;
          });
        },
        contentPadding: const EdgeInsets.all(8.0),
        tileColor: tileColor,
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
                            padding: const EdgeInsets.only(
                                top: 9.0, bottom: 8.0),
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
                          leading: Icon(Icons.visibility_off_outlined,
                            color: Colors.grey.shade500,),
                          title: Text("Hide this notification",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14)),
                          onTap: () async {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            String? token = prefs.getString('token');
                            if(token==null){
                              throw Exception('Token is null');
                            }
                            else {
                              Map<String, dynamic> response = await logicAPI().hideNotification(token, widget.notification.id);
                              if (response['success']) {
                               // readNotificationIds = logicAPI().getReadNotifications(token);
                               //  ScaffoldMessenger.of(context).showSnackBar(
                               //    SnackBar(
                               //      content: Text('Notification successfully hidden'),
                               //    ),
                               //  );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Notification is hidden'),
                                    // action: SnackBarAction(
                                    //   label: 'UNDO',
                                    //   textColor: Colors.blue, onPressed: () {  },
                                      // onPressed: () async {
                                      //   final SharedPreferences prefs = await SharedPreferences
                                      //       .getInstance();
                                      //   String? token = prefs.getString(
                                      //       'token');
                                      //   if (token == null) {
                                      //     throw Exception('Token is null');
                                      //   }
                                      //   else {
                                      //     Map<String,
                                      //         dynamic> response = await logicAPI()
                                      //         .
                                      //     unhideNotification(
                                      //         token, (widget.notification.id));
                                      //     if (response['success']) {
                                      //
                                      //       print('Notification unhidden successfully');
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(
                                      //         SnackBar(
                                      //           content: Text(
                                      //               'Notification is unhidden'),
                                      //         ),
                                      //       );
                                      //       setState(() {
                                      //         isVisible = true;
                                      //         isUnhidden=true;
                                      //       });
                                      //     } else {
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(
                                      //         SnackBar(
                                      //           content: Text(
                                      //               'Failed to unhide notification'),
                                      //         ),
                                      //       );
                                      //     };
                                      //   };
                                      // }
                                    ),

                                );
                                if(isUnhidden==false){
                                setState(() {
                                  isVisible = false; // Hide the card again
                                });
                                widget.onHidden(); // Call the callback function
                              }} else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to hide notification'),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.highlight_off_outlined,
                              color: Colors.grey.shade500),
                          title: Text("Disable updates from this community",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14)),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications_off_outlined,
                              color: Colors.grey.shade500),
                          title: Text("Turn off this notification type",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14)),
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
                              minimumSize: Size(MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.95, 40),
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
