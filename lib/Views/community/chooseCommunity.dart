import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Views/community/chooseCommunity.dart';
import 'package:curio/Views/share/shareToSubreddit.dart';

class ChooseCommunityPage extends StatefulWidget {
  final String oldPostId;

  ChooseCommunityPage({required this.oldPostId});
  @override
  _ChooseCommunityPageState createState() => _ChooseCommunityPageState();
}

class _ChooseCommunityPageState extends State<ChooseCommunityPage> {
  String _username = '';
  String _email = '';
  final ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  List<dynamic> communities = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, dynamic> userProfile =
          await _apiService.getUserProfile(token);
      setState(() {
        _username = userProfile['username'];
        _email = userProfile['email'];
      });
      _fetchUserCommunities(token);
    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }

  void _fetchUserCommunities(token) async {
    try {
      if (token == null) {
        throw Exception('Token not found');
      }

      Map<String, dynamic> userCommunities =
          await _apiService.getUserCommunities(token, _username);
      setState(() {
        communities = userCommunities['communities'];
      });
    } catch (e) {
      print('Failed to fetch user communities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Community'),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('lib/assets/images/Curio.png'),
                  radius: 30,
                ),
                SizedBox(width: 10),
                Text('My profile'),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Joined',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset('lib/assets/images/Curio.png'),
                    radius: 30,
                  ),
                  title: Text(community['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShareToSubredditPage(
                            selectedNewSubreddit: community['name'],
                            oldPostId: widget.oldPostId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
