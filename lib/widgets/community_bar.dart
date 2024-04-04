import 'package:flutter/material.dart';
import 'rules_page.dart';


class CommunityBar extends StatelessWidget {
  final String? community;
  final IconData? image;
  final VoidCallback onTap;
  final String communityId;

  const CommunityBar({
    super.key,
    required this.community,
    required this.onTap,
    required this.communityId,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(image),
                const SizedBox(width: 8),
                Text(community ?? 'Select a community'),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RulesPage(communityId: communityId)),
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
