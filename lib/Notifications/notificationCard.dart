import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curio/Notifications/notificationModel.dart';
import 'package:curio/services/logicAPI.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;

  NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 8.0),
                        Text(widget.notification.title, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),),
                        SizedBox(width: 8.0),
                        Text(widget.notification.timestamp != null ?  '${timeago.format(widget.notification.timestamp)}' : 'Unknown time',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(widget.notification.message),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }
}