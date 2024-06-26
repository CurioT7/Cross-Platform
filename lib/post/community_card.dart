import 'package:flutter/material.dart';
import 'dart:math';
import 'package:curio/Models/community_model.dart';

final icons = [Icons.home, Icons.star, Icons.school, Icons.work, Icons.alarm, Icons.account_balance];

class CommunityCard extends StatelessWidget {
  final Community community;
  final Function onTap;

  CommunityCard(
      {Key? key, required this.community, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = icons[Random().nextInt(icons.length)];

    return GestureDetector(
      onTap: () => onTap(

      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.05,
            backgroundImage: NetworkImage(community.icon??'https://example.com/default_image.png'), // Replace with your default image URL
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${community.members.length} members',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}