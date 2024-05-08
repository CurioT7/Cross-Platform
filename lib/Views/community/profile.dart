import 'package:flutter/material.dart';
//import 'dart:ui' as ui;
import 'package:curio/Views/community/topAppBar.dart';
//import logicAPI.dart
import 'package:curio/services/logicAPI.dart';
//import postcard
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/widgets/postCard.dart';
import 'package:curio/utils/componentSelectionPopUPPage.dart';
import 'package:curio/Models/post.dart';

//import postcard.dart
//import 'package:curio/widgets/postCard.dart';

import '../moderator/moderator_tools.dart';
import 'aboutComunity.dart';

class communityProfile extends StatefulWidget {
  final String communityName;

  const communityProfile({Key? key, required this.communityName})
      : super(key: key);

  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<communityProfile> {
  // bool hasJoined = false;

  Future<double?> timeSelection = Future.value(0.0);
  final ValueNotifier<double> blurValue = ValueNotifier<double>(0.0);
  //String communityName = 'Art eum';
  bool? isJoined;
  late List<String> moderators;
  bool isModerator =false;
  bool isJoinedChanged = false;
  Future<void> fetchPreferencesIsJoined() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //_fetchJoinState();
    isJoined = prefs.getBool('isJoinedSubreddit');
    // You can now use isJoined
  }

  void _fetchJoinState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final username = await apiLogic.fetchUsername(token);
      final data = apiLogic.extractUsername(username);

      String extractedUsername = data['username'];
      if (moderators.contains(extractedUsername)) {
        isModerator = true;
      }
      logicAPI().fetchJoinedCommunityNames(
          extractedUsername, token, widget.communityName);
      //  return joinedCommunities.contains(communityName);
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  List<Post> posts = [];
  String? privacyMode;
  String? name;
  String? description;
  int? membersCount;
  String? banner;
  String? icon;

  void _updateSortAndIcon(String newSort, IconData newIcon) {
    setState(() {
      newSort = _selectedSort;
      newIcon = _selectedIcon;
    });
  }

  void _fetchCommunityData() async {
    print('Fetching community data');
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData =
        await api.fetchCommunityData(widget.communityName);
    setState(() {
      privacyMode = communityData['privacyMode'];
      name = communityData['name'];
      description = communityData['description'];
      membersCount = communityData['membersCount'];
      banner = communityData['banner'];
      icon = communityData['icon'];
      moderators = List<String>.from(communityData['moderators'] ?? []);
      print('Community Data: $communityData');
      print('privacyMode');
      print(privacyMode);
    });
  }

  String _selectedSort = 'Hot';
  IconData _selectedIcon = Icons.whatshot; // Default icon

  void fetchPosts(String newSort) async {
    setState(() {
      _selectedSort = newSort;
    });

    logicAPI api = logicAPI();
    switch (_selectedSort) {
      case 'hot':
        List<Post> fetchedPosts =
            await api.fetchCommunityProfilePosts(widget.communityName, 'hot');
        setState(() {
          posts = fetchedPosts;
          print("fetchedposts");

          print("fetchedposts");
          print(posts);
        });
        break;
      case 'new':
        List<Post> fetchedPosts =
            await api.fetchCommunityProfilePosts(widget.communityName, 'new');
        setState(() {
          posts = fetchedPosts;
          print("fetchedposts");
          print("fetchedposts");
          print(posts);
        });
        break;
      default:
        print("im here");
        var timeInterval = await timeSelection;

        print("Time interval");
        print(timeInterval);
        if (timeInterval! < 1) {
          List<Post>? fetchedPosts =
              await api.fetchTopPosts(widget.communityName, "now");
          setState(() {
            if (fetchedPosts != null) {
              posts = fetchedPosts;
              print(posts);
            } else {
              posts = [];
            }
          });
          return;
        }
        List<Post>? fetchedPosts = await api.fetchTopPosts(
            widget.communityName, (timeInterval!).toString());
        setState(() {
          if (fetchedPosts != null) {
            posts = fetchedPosts;
            print(posts);
          } else {
            posts = [];
          }
        });
        break;
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    _fetchCommunityData();

    //isJoined = null;
    _initializeState();

    //TODO FETCH COMMUNITY JOIN STATE
    //hasJoined = _fetchJoinState() ;

    fetchPosts('hot');
    //fetchPosts();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   showSortPostsBottomSheet(context, _selectedSort, fetchPosts, true);
    // });
  }

  void _initializeState() async {
    _fetchJoinState();
    await fetchPreferencesIsJoined();
    print('Is Joined: $isJoined');

    setState(() {});
  }
  // void fetchPosts() async {
  //   logicAPI api = logicAPI();
  //   List<Map<String, dynamic>> fetchedPosts = await api.fetchCommunityProfilePosts(communityName);
  //   Map<String, dynamic> fetchedUserDetails = await _fetchUserDetails();
  //   String profilePicture = fetchedUserDetails['profilePicture'];
  //   setState(() {
  //     posts = fetchedPosts.map((post) => {
  //       ...post,
  //       'userImage': profilePicture,
  //     }).toList();
  //   });
  // }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    double scrollPosition = _scrollController.position.pixels;
    double limit =
        MediaQuery.of(context).size.width * 0.3; // Set your limit here

    if (scrollPosition > limit) {
      blurValue.value = 3.0; // Set a high blur value
    } else {
      blurValue.value = 0.0; // Calculate the blur value as before
    }
  }

  final logicAPI apiLogic = logicAPI();
  Map<String, dynamic>? userDetails;

  // Future<Map<String, dynamic>> _fetchUsername() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');
  //     if (token == null) {
  //       throw Exception('Token is null');
  //       // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
  //     }
  //     final username = await apiLogic.fetchUsername(token);
  //     final data = await apiLogic.extractUsername(username);
  //     print('DATA HERE');
  //     print(data);
  //     return data;
  //     //await prefs.remove('token');
  //   }
  //   catch (e) {
  //     throw Exception('Error fetching user details: $e');
  //   }
  // }
  //
  // Future<Map<String, dynamic>> _fetchUserDetails() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('token');
  //     print(token);
  //     if (token == null) {
  //       throw Exception('Token is null');
  //       // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
  //
  //     }
  //
  //     final usernameData = await _fetchUsername();
  //     String username = usernameData['username'];
  //
  //     final userData = await apiLogic.fetchUserData(username);
  //     final data = await apiLogic.extractUserDetails(userData);
  //
  //     print('DATA HERE');
  //     print(data);
  //     return data;
  //   } catch (e) {
  //     throw Exception('Error fetching user details: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topAppBar(context, blurValue, banner ?? ''),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.05,

              //backgroundImage: NetworkImage(icon ?? 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vectorstock.com%2Froyalty-free-vector%2Fno-connection-icon-wifi-vector-46940244&psig=AOvVaw1HGJnDaDIO_US78iYBz5FH&ust=1711800821175000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJC61pO5mYUDFQAAAAAdAAAAABAE') , // check is correct

              backgroundImage: icon != null ? NetworkImage(icon!) : null,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('r/$name',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.034,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('$membersCount members',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBM_Plex_Sans_Light')),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    //draw green filled icon circle
                  ],
                ),
              ],
            ),

            //choose height and width of button

            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.17, // Set the width of the button
              height: MediaQuery.of(context).size.width *
                  0.07, // Set the height of the button

              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.only(right: 8.0, left: 8.0)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      _initializeState();
                      _fetchJoinState();
                      fetchPreferencesIsJoined();

                      if (isJoined == true && isModerator==false) {
                        return Colors
                            .white; // Set the button color to white if the user has joined
                      }
                      else if (privacyMode == 'private' && isJoined == false) { return Colors
                          .grey;}
                      else {
                        return Colors
                            .blue.shade900; // Otherwise, set it to dark blue
                      }
                    },
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                      if (isJoined == true && isModerator==false){
                        return BorderSide(
                            color: Colors
                                .grey); // Set the border color to dark grey if the user has joined
                      } else {
                        return BorderSide.none; // Otherwise, no border
                      }
                    },
                  ),
                ),
                onPressed: (privacyMode == 'private' && isJoined == false) ? null : () async {
                  try {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');
                    if (token == null) {
                      throw Exception('Token is null');
                    }
                    _initializeState();
                    _fetchJoinState();
                    fetchPreferencesIsJoined();
                    if (isModerator==false) {
                      if (isJoined!) {
                        try {
                          //await apiLogic.leaveCommunity(token, communityName);
                          // isJoined = false;
                          setState(() {
                            showLeaveCommunityDialog(
                                context, widget.communityName);
//                             _initializeState();
//                             _fetchCommunityData();
// fetchPreferencesIsJoined();
                          });
                        } catch (e) {
                          print('Error leaving community: $e');
                        }
                      } else {
                        try {
                          await apiLogic.joinCommunity(
                              token, widget.communityName);
                          isJoinedChanged = true;
                          //might change test
                          setState(() {
                            isJoined = true;
                            prefs.setBool('isJoinedSubreddit', true);
                          });

                          //isJoined = true;
// if (isJoinedChanged==true) {
//   _initializeState();
//   _fetchCommunityData();
//   _fetchJoinState();
//   fetchPreferencesIsJoined();
//   isJoinedChanged=false;
// }
                          setState(() {
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
                                      'You have succesfully joined the community: $widget.communityName',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            );
                          });
                        } catch (e) {
                          print('Error joining community: $e');
                        }
                      }
                    }
                    else(){
//open ModeratorToolsPage class and send to it this subreddit name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModeratorToolsPage(subredditName: widget.communityName),
                        ),
                      );
                      //todo open modtools settings page
                    };
                  } catch (e) {
                    print('Error in SharedPreferences: $e');
                  }
                },
                child: Text(
                  isModerator ? 'Mod Tools' : (isJoined == true ? 'Joined' : 'Join'),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.022,
                    color: isModerator ? Colors.white : (isJoined == true ? Colors.grey : Colors.white),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.02),
        Padding(
          padding:
              EdgeInsets.only(left: 20.0), // Adjust the padding value as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(right: 7.0), // Adjust the value as needed
                child: Text(
                  '$description',
                  maxLines:
                      null, // Allows the text to wrap onto unlimited lines
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontFamily: "IBM_Plex_Sans_Light",
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutComunityPage(
                            subredditName: widget
                                .communityName)), // Replace SecondPage() with the actual page you want to navigate to
                  );
                },
                child: Text(
                  "See more",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold // Set the color to dark blue
                      ),
                ),
              )
            ],
          ),
        ),
        // Divider(thickness: 1.0),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade200),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
          onPressed: () {
            timeSelection = showSortPostsBottomSheet(context, _selectedSort,
                Icons.whatshot, _updateSortAndIcon, fetchPosts, true);
            print('Time Selection');
            print(timeSelection);
          },
          child: Row(
            children: [
              Icon(
                _selectedIcon,
                color: Colors.grey,
              ),
              Text(
                '${_selectedSort.toUpperCase()} POSTS',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        if (privacyMode == 'private' && isModerator==false) ...[
          SizedBox(
            height: 50,
            width: 50,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'This community is private',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          // Disable the join button
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.13,
          //   height: MediaQuery.of(context).size.width * 0.07,
          //   child: TextButton(
          //     style: ButtonStyle(
          //       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //           EdgeInsets.only(right: 8.0, left: 8.0)),
          //       backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //           (Set<MaterialState> states) {
          //         return Colors
          //             .grey.shade200; // Use any color that suits your design
          //       }),
          //       side: MaterialStateProperty.resolveWith<BorderSide>(
          //           (Set<MaterialState> states) {
          //         return BorderSide(color: Colors.grey);
          //       }),
          //     ),
          //     onPressed:
          //         null, // Disable the button by setting onPressed to null
          //     child: Text(
          //       'Join',
          //       style: TextStyle(
          //         fontSize: MediaQuery.of(context).size.width * 0.022,
          //         color: Colors.grey,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ] else ...[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Post post = posts[index];
                return PostCard(post: post);
              },
            ),
          ),
        ],
      ]),
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
            height: MediaQuery.of(context).size.height * 0.14,
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
                            onPressed: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? token = prefs.getString('token');
                              if (token == null) {
                                throw Exception('Token is null');
                              }
                              await apiLogic.leaveCommunity(
                                  token, communityName);

                              //might change test
                              setState(() {
                                isJoined = false;
                                prefs.setBool('isJoinedSubreddit', false);
                              });

                              isJoinedChanged = true;
                              // if (isJoinedChanged==true) {
                              //   _initializeState();
                              //   _fetchCommunityData();
                              //   _fetchJoinState();
                              //   fetchPreferencesIsJoined();
                              //   isJoinedChanged=false;
                              // }
                              Navigator.of(context).pop();
                              // isJoined = false;
                              _fetchCommunityData();
                              fetchPreferencesIsJoined();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ));
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
