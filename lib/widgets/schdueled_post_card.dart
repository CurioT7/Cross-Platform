import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/community_model.dart';
import '../post/screen_post.dart';

class ScheduledPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final Function updatePost;
  final Function submitPost;
  final Community community;

  ScheduledPostCard(
      {required this.post, required this.community, required this.updatePost, required this.submitPost});
  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Add this line
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post['repeatOption'] != 'does_not_repeat'
                    ? 'Repeat Weekly: ${DateFormat('MM/dd').format(DateTime.parse(post['scheduledPublishDate']))}'
                    : 'Scheduled: ${DateFormat('MM/dd').format(DateTime.parse(post['scheduledPublishDate']))}',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'r/${community.name}',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post['title'],
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Wrap(
              alignment: WrapAlignment.start, // Add this line
              children: [
                if (post['isNSFW'])
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'NSFW',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (post['isSpoiler'])
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Spoiler',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (post['isOC'])
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'OC',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post['content'],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          if (post['media'] != null)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildMediaWidget(post['type'], post['media']),
              ),
            ),
          _buildEditBar(context),
        ],
      ),
    );
  }

  Widget _buildMediaWidget(String type, dynamic media) {
    print("Type: $type, Media: $media");
    switch (type) {
      case 'link':
        return InkWell(
          child: Row(
            children: [
              const Icon(Icons.link,
                  color: Colors.blue), // This is the link icon
              const SizedBox(
                  width:
                      5), // This adds some spacing between the icon and the text
              Text(
                media,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
          onTap: () async {
            String url = media;
            if (!url.startsWith("http://") && !url.startsWith("https://")) {
              url = "http://$url";
            }
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        );
      case 'media':
        return SizedBox(
          height: 200,
          child: Builder(
            builder: (context) {
              return Row(
                children: [
                  Expanded(child: media),
                ],
              );
            },
          ),
        );

      case 'poll':
        List<String> options = post['options'].split(',');
        return Column(
          children: options
              .map((option) => Row(
                    children: [
                      Radio(
                        value: option,
                        groupValue: post['selectedOption'],
                        onChanged: (value) {
                          // Add your action here
                        },
                      ),
                      Text(option),
                    ],
                  ))
              .toList(),
        );
      default:
        return const Text('Unknown media type');
    }
  }

  Widget _buildEditBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            icon: const Icon(
              Icons.send,
              color: Colors.green,
            ),
            label: const Text(
              'Post Now',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: () {
              // Add your action here
              submitPost(post, community.name);
            },
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            label: const Text(
              'Edit Post',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              print("Edit Post with ID: ${post['_id']}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPostScreen(
                    post: post,
                    type: 'text',
                    isScheduled: true,
                    schudlePostEdit: true,
                    canChooseCommunity: false,
                    subreddit: {'subreddit': community},
                  ),
                ),
              );
            },
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete Post',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              // Add your action here
              updatePost(post);
            },
          ),
        ],
      ),
    );
  }
}
