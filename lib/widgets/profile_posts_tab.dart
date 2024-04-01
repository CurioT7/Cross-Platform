import 'package:flutter/material.dart';

class ProfilePostsTab extends StatelessWidget {
  const ProfilePostsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: InkWell(
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome),
                  SizedBox(width: 5.0),
                  Text('New Posts'),
                  SizedBox(width: 5.0),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
