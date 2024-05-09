import 'package:flutter/material.dart';
import 'dart:math';

import '../Views/my_profile_screen.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String profilePic;
  final int karma;

  UserCard({required this.userName, required this.profilePic, required this.karma});

  @override
  Widget build(BuildContext context) {
    NetworkImage? image;
    try {
      image= NetworkImage(profilePic);
    } catch (e) {
      print('Error loading image: $e');
      image = Null as NetworkImage?;
    }
    var defaultImage =  Image.asset('lib/assets/images/Curio.png');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfileScreen(
              isUser: false,
              userName: userName,
              days: Random().nextInt(365), // random days
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:  defaultImage.image,
            radius: 20,
          ),
          title: Text(userName),
          subtitle: Text('Karma: $karma'),
        ),
      ),
    );
  }
}