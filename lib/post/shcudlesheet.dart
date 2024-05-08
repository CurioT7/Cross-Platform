import 'package:flutter/material.dart';
import 'package:curio/post/schudleConfig.dart';

class PostSettingsBottomSheet extends StatelessWidget {
   Map<String,dynamic> post;
   Map<String,dynamic> community;

   PostSettingsBottomSheet({super.key, required this.post,  this.community = const {}});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Post Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Row(
                children: <Widget>[
                  Icon(Icons.schedule, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Schedule Post',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return  SchedulePostBottomSheet(post: post,community: community);
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
