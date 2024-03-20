import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late Map<String, Map<String, bool>> settings;

  _NotificationSettingsPageState() {
    settings = {
      'MESSAGES': {
        'Private messages': false,
        'Chat messages': false,
        'Chat requests': false,
      },
      'ACTIVITY': {

        'Mentions of u/username': false,
        'Comments on your posts': false,
        'Upvotes on your posts': false,
        'Upvotes on your comments': false,
        'Replies to your comments': false,
        'Activity on your comments': false,
        'Activity on chat posts you\'re in': false,
        'New followers': false,
        'Awards you receive': false,
        'Posts you follow': false,
        'Comments you follow': false,
      },
      'RECOMMENDATIONS': {
        'Trending posts': false,
        'Community recommendations': false,
        'ReReddit': false,
        'Featured content': false,
      },
      'UPDATES': {
        'Reddit announcements': false,
        'Cake day': false,
        'Community alerts': false,
      },
      'MODERATION': {
        'Mod notifications': false,
        'r/softwaretest123': false,
      },
    };
  }

  IconData _getIconForKey(String key) {
    switch (key) {
      case 'Private messages':
        return FontAwesomeIcons.envelope;
      case 'Chat messages':
        return FontAwesomeIcons.comments;
      case 'Chat requests':
        return FontAwesomeIcons.plus;
      case 'Community alerts':
        return FontAwesomeIcons.users;
      case 'Mentions of u/username':
        return FontAwesomeIcons.at;
      case 'Comments on your posts':
        return FontAwesomeIcons.commentDots;
      case 'Upvotes on your posts':
        return FontAwesomeIcons.arrowUp;
      case 'Upvotes on your comments':
        return FontAwesomeIcons.arrowUp;
      case 'Replies to your comments':
        return FontAwesomeIcons.reply;
      case 'Activity on your comments':
        return FontAwesomeIcons.commentDots;
      case 'Activity on chat posts you\'re in':
        return FontAwesomeIcons.comments;
      case 'New followers':
        return FontAwesomeIcons.userPlus;
      case 'Awards you receive':
        return FontAwesomeIcons.award;
      case 'Posts you follow':
        return FontAwesomeIcons.squareRss;
      case 'Comments you follow':
        return FontAwesomeIcons.comments;
      case 'Trending posts':
        return FontAwesomeIcons.chartLine;
      case 'Community recommendations':
        return FontAwesomeIcons.users;
      case 'ReReddit':
        return FontAwesomeIcons.reddit;
      case 'Featured content':
        return FontAwesomeIcons.star;
      case 'Reddit announcements':
        return FontAwesomeIcons.bullhorn;
      case 'Cake day':
        return FontAwesomeIcons.cakeCandles;
      case 'Mod notifications':
        return FontAwesomeIcons.shieldHalved;
      case 'r/softwaretest123':
        return FontAwesomeIcons.reddit;
      default:
        return FontAwesomeIcons.bell;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) {
          String category = settings.keys.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ]..addAll(
                settings[category]!.keys.map((key) {
                  return ListTile(
                    title: Text(key),
                    trailing: key == 'Community alerts'
                        ? Icon(Icons.arrow_forward_ios, size: 20.0)
                        : Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: settings[category]![key] ?? false,
                        onChanged: (value) {
                          setState(() {
                            settings[category]![key] = value;
                          });
                        },
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.lightBlueAccent,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                    leading: FaIcon(_getIconForKey(key), size: 20.0),
                    onTap: key == 'Community alerts'
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommunitiesPage()),
                      );
                    }
                        : null,
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CommunitiesPage extends StatefulWidget {
  @override
  _CommunitiesPageState createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  List<String> selectedBell = List.filled(10, '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communities'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Community ${index + 1}'),
                Text(selectedBell[index]),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedBell[index] = 'Off';
                    });
                  },
                  child: Icon(
                    selectedBell[index] == 'Off' ? FontAwesomeIcons.bellSlash : FontAwesomeIcons.bell,
                    color: selectedBell[index] == 'Off' ? Colors.black : null,
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedBell[index] = 'Low';
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.bell,
                    color: selectedBell[index] == 'Low' ? Colors.black : null,
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedBell[index] = 'Frequent';
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.solidBell,
                    color: selectedBell[index] == 'Frequent' ? Colors.black : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}