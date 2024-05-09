
import 'package:curio/Views/Moderation/approved_users_page.dart';
import 'package:curio/Views/Moderation/banned_users_page.dart';
import 'package:curio/Views/Moderation/rules_page.dart';
import 'package:curio/Views/insettingspage/notificationSettings.dart';
import 'package:curio/post/schudledPostPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curio/utils/constants.dart';
import 'package:curio/utils/componentAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/views/insettingspage/connectedAccounts.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:curio/Views/moderator/moderators.dart';

import '../../Models/community_model.dart';
import '../../post/post_types.dart';
import '../../services/ModerationService.dart';
import 'communityDescription.dart';
import 'communityPrivacyMode.dart';
import 'package:curio/services/api_service.dart' as APISHAMS;
class ModeratorToolsPage extends StatefulWidget {
  String? subredditName;
  Community? communityDetails;
   ModeratorToolsPage({super.key,  this.subredditName, this.communityDetails});
  @override
  State<ModeratorToolsPage> createState() => _ModeratorToolsPageState();
}

class _ModeratorToolsPageState extends State<ModeratorToolsPage> {

  bool validEmail = false;
  bool validPassword = false;
  final storage = FlutterSecureStorage();



  @override
  void initState() {
    print('Subreddit name: ${widget.subredditName}');
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: ComponentAppBar(title: 'Moderator Tools Page'), // Change the title here
      body: ListView(
        children: <Widget>[
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('GENERAL', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit , color: KIconColor),
            title: Text('Description', style: kTitleHeader),

            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              print('subreddit name: ${widget.subredditName}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityDescription(subreddit: widget.subredditName??''),
                ),
              );


            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: KIconColor),
            title: Text('Community type', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {

//open page CommunityType
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityType(subreddit: widget.subredditName??''),
                ),
              );

            },
          ),
          ListTile(
            leading: Icon(Icons.library_books , color: KIconColor),
            title: Text('Post types', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {

              //Navigate to the PostTypesPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostTypesPage(),
                ),
              );

            },
          ),

          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('CONTENT & REGULATIONS', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.description, color: KIconColor),
            title: Text('Rules', style: kTitleHeader),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RulesPage(subredditName: widget.subredditName??''),
                ),
              );

            },
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: KIconColor),
            title: Text('Scheduled posts', style: kTitleHeader),
            onTap: () {
              // navagate to scheduled post page ScheduledPostsPage
              print('Community Details: ${widget.communityDetails}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduledPostsPage(post:const {},community: {'subreddit':widget.communityDetails}),
                ),
              );
            },
          ),
          Container(
            color: KDeviderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('USER MANAGEMENT', style: kSubtitleTextStyle),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shield_outlined, color: KIconColor),
            title: Text('Moderators', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              String subredditName = 'dynamicSubredditName'; // Set your dynamic subreddit name here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModeratorsPage(subredditName: widget.subredditName??''),
                ),
              );
            },
          ), // Removed the extra closing parenthesis here

          ListTile(
            leading: Icon(Icons.person_outline, color: KIconColor),
            title: Text('Approved users', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApprovedUsersPage(),
                ),
              );

            },
          ),
          ListTile(
            leading: Icon(Icons.gavel_outlined, color: KIconColor),
            title: Text('Banned users', style: kTitleHeader),
            trailing: Icon(Icons.arrow_forward, color: KIconColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BannedUsersPage(subredditName: widget.subredditName??''),
                ),
              );


            },
          ),

        ],
      ),
    );
  }
}