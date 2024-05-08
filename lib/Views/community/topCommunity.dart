import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:curio/services/logicAPI.dart'; // Import the necessary file for apiLogic
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/utils/componentSelectionPopUPPage.dart';
import 'package:curio/Models/post.dart';
import 'package:curio/Views/community/topAppBar.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:curio/Views/community/SelectionCommunityPopUp.dart';

class TopCommunitiesPage extends StatefulWidget {
  @override
  _TopCommunitiesPageState createState() => _TopCommunitiesPageState();
}

class _TopCommunitiesPageState extends State<TopCommunitiesPage> {
  final ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  final logicAPI apiLogic = logicAPI();
  Map<String, dynamic>? _topCommunities;
  Map<String, bool> communityStates =
      {}; // Store the state of each community button
  String _username = '';
  String _email = '';
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
        print('User communities: $communities');
      });
      _fetchTopCommunities();
    } catch (e) {
      print('Failed to fetch user communities: $e');
    }
  }

  Future<void> _fetchTopCommunities() async {
    try {
      final response = await _apiService.getTopCommunities();
      setState(() {
        _topCommunities = response;
        // Initialize communityStates with false for each community
        _topCommunities!['communities'].forEach((community) {
          final bool isJoined = communities.any((userCommunity) {
            return userCommunity['_id'].toString() == community['_id'];
          });
          communityStates[community['name']] = isJoined;
        });
      });

      print(communityStates);
      print('Top communities response: $_topCommunities');
    } catch (e) {
      print('Failed to fetch top communities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communities'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CommunitySearchPage(
                  onCommunitySelected: (community) {
                    // Handle selected community here
                    print('Selected community: $community');
                    // Add your logic to handle the selected community
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _topCommunities == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _topCommunities!['communities'].length,
                itemBuilder: (context, index) {
                  final community = _topCommunities!['communities'][index];
                  final communityMembers = community['members'];
                  final communityMembersCount = communityMembers.toString();
                  final communityName = community['name'];

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => communityProfile(
                            communityName: communityName,
                          ),
                        ),
                      ).then((_) => _fetchUserProfile());
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset('lib/assets/images/Curio.png'),
                      radius: 30,
                    ),
                    title: Text('$communityName '),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Members: $communityMembersCount'),
                        Text('Category: ${community['category']}'),
                      ],
                    ),
                    trailing: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.only(right: 5.0)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return communityStates[communityName] ?? false
                                ? Colors.white
                                : Colors.blue.shade900;
                          },
                        ),
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            return communityStates[communityName] ?? false
                                ? BorderSide(color: Colors.grey)
                                : BorderSide.none;
                          },
                        ),
                      ),
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? token = prefs.getString('token');
                        if (token == null) {
                          throw Exception('Token is null');
                        }

                        if (communityStates[communityName] ?? false) {
                          try {
                            await apiLogic.leaveCommunity(token, communityName);
                            setState(() {
                              showLeaveCommunityDialog(context, communityName);
                            });
                          } catch (e) {
                            print('Error leaving community: $e');
                          }
                        } else {
                          try {
                            await apiLogic.joinCommunity(token, communityName);

                            setState(() {
                              communityStates[communityName] = true;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      'You have successfully joined the community: $communityName',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            });
                          } catch (e) {
                            print('Error joining community: $e');
                          }
                        }
                      },
                      child: Text(
                        communityStates[communityName] ?? false
                            ? 'Joined'
                            : 'Join',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.022,
                          color: communityStates[communityName] ?? false
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void showLeaveCommunityDialog(BuildContext context, String communityName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 1.6,
            height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Are you sure you want to leave the r/$communityName community?',
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text('Leave',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                communityStates[communityName] = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      'You have left the community: $communityName',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
