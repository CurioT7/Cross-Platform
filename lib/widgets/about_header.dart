import 'package:flutter/material.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({
    super.key,
    required this.postKarmaNumber,
    required this.commentKarmaNumber,
  });

  final String postKarmaNumber;
  final String commentKarmaNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postKarmaNumber,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Post Karma',
              ),
            ],
          ),
          SizedBox(width: MediaQuery.sizeOf(context).width * 0.3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commentKarmaNumber,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Comment Karma',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
