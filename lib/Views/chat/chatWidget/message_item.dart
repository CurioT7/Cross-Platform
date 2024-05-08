import 'package:curio/Models/chatmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItemWidget extends StatelessWidget {
  Message message;
  ImageProvider<Object> image;
  String myUsername;
  int index;
  bool isSame;
  MessageItemWidget({
    super.key,
    required this.message,
    required this.isSame,
    required this.index,
    required this.image,
    required this.myUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: isSame
          ? Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Text(
                message.message ?? '',
              ),
            )
          : Row(children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: image,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(message.sender.username ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(formatDateTime(message.timestamp.toString()) ?? ''),
                    ],
                  ),
                  Text(
                    message.message ?? '',
                  )
                ],
              )
            ]),
    );
  }
}

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString).toUtc();
  DateFormat formatter = DateFormat('hh:mm a');
  return formatter.format(dateTime.toLocal());
}
