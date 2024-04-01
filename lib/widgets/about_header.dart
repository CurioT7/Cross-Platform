import 'package:flutter/material.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '230',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Post Karma',
              ),
            ],
          ),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.3),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1,007',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Comment Karma',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
