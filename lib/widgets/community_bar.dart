import 'package:flutter/material.dart';
import 'dart:math';
import 'rules_page.dart';

final icons = [
  Icons.home,
  Icons.star,
  Icons.school,
  Icons.work
]; // Add more icons as needed

class CommunityBar extends StatelessWidget {
  final String? community;
  final IconData? icon;
  final VoidCallback onTap;
  final String communityId;

  const CommunityBar({
    Key? key,
    required this.community,
    required this.onTap,
    required this.communityId,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconData = icon ?? icons[Random().nextInt(icons.length)];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(iconData),
                const SizedBox(width: 8),
                Text(community ?? 'Select a community'),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RulesPage(communityId: communityId)),
                );
              },
              child: const Text('Rules'),
            ),
          ],
        ),
      ),
    );
  }
}
