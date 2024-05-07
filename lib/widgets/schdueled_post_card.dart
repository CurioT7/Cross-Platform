import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package to format the date and time
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ScheduledPostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  ScheduledPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    print(post);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Add this line
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Scheduled: ${DateFormat('MM/dd').format(post['date'])} @ ${post['time'].format(context)}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'r/' + post['subreddit'],
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
              url = "http://" + url;
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
        return Text('Poll: $media'); // Display the poll data as text
      default:
        return const Text('Unknown media type');
    }
  }
}
