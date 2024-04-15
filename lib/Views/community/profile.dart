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

import 'aboutComunity.dart';
class communityProfile extends StatefulWidget {
  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<communityProfile> {
  Future<double?> timeSelection = Future.value(0.0);
  final ValueNotifier<double> blurValue = ValueNotifier<double>(0.0);
  String communityName = 'Music aut';
  bool hasJoined = false;


  List<Post> posts = [];
  String? privacyMode;
  String? name;
  String? description;
  int? membersCount;
  String? banner;
  String? icon;

  void _updateSortAndIcon(String newSort, IconData newIcon) {
    setState(() {
      newSort= _selectedSort;
      newIcon= _selectedIcon ;
    });
  }

  void _fetchCommunityData() async {
    print('Fetching community data');
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData = await api.fetchCommunityData(
        communityName);
    setState(() {
      privacyMode = communityData['privacyMode'];
      name = communityData['name'];
      description = communityData['description'];
      membersCount = communityData['membersCount'];
      banner = communityData['banner'];
      icon = communityData['icon'];

      print('Community Data: $communityData');
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
        List<Post> fetchedPosts = await api.fetchCommunityProfilePosts(communityName, 'hot');
        setState(() {
          posts = fetchedPosts; print("fetchedposts");

          print("fetchedposts");
          print(posts);
        });
        break;
      case 'new':
        List<Post> fetchedPosts = await api.fetchCommunityProfilePosts(communityName, 'new');
        setState(() {
          posts = fetchedPosts; print("fetchedposts");
          print("fetchedposts");
          print(posts);
        });
        break;
      default:
        print("im here");
        var timeInterval = await timeSelection;

        print("Time interval");
        print(timeInterval);
if (timeInterval!<1){
  List<Post>? fetchedPosts = await api.fetchTopPosts(communityName, "now");
  setState(() {
    if(fetchedPosts!=null) {
      posts = fetchedPosts;
      print(posts);
    }
  else{posts=[];
  }})
  ;
  return;
}
        List<Post>? fetchedPosts = await api.fetchTopPosts(communityName, (timeInterval! ).toString());
        setState(() {
          if(fetchedPosts!=null) {
            posts = fetchedPosts;
            print(posts);
          }
          else{posts=[];
          }});
        break;
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchCommunityData();
    fetchPosts('hot');
    //fetchPosts();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   showSortPostsBottomSheet(context, _selectedSort, fetchPosts, true);
    // });
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
    double limit = MediaQuery
        .of(context)
        .size
        .width * 0.3; // Set your limit here

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
      appBar: topAppBar(context, blurValue),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.04),
              CircleAvatar(
                radius: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,

                //backgroundImage: NetworkImage(icon ?? 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vectorstock.com%2Froyalty-free-vector%2Fno-connection-icon-wifi-vector-46940244&psig=AOvVaw1HGJnDaDIO_US78iYBz5FH&ust=1711800821175000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJC61pO5mYUDFQAAAAAdAAAAABAE') , // check is correct

                backgroundImage: AssetImage('assets/images/example.jpg'),),
              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('r/$name',
                      style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.045,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('$membersCount members',
                          style: TextStyle(
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.03,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM_Plex_Sans_Light')),
                      SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.02),
                      //draw green filled icon circle
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(' 2,654 online',
                          style: TextStyle(
                              fontSize:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.03,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM_Plex_Sans_Light')),
                    ],
                  ),
                ],
              ),

              //choose height and width of button

              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.23),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width *
                    0.13, // Set the width of the button
                height: MediaQuery
                    .of(context)
                    .size
                    .width *
                    0.07, // Set the height of the button

                child: TextButton(

                  style: ButtonStyle(
padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(right: 5.0)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (hasJoined) {
                          return Colors
                              .white; // Set the button color to white if the user has joined
                        } else {
                          return Colors.blue
                              .shade900; // Otherwise, set it to dark blue
                        }
                      },
                    ),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                        if (hasJoined) {
                          return BorderSide(color: Colors
                              .grey); // Set the border color to dark grey if the user has joined
                        } else {
                          return BorderSide.none; // Otherwise, no border
                        }
                      },
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      String? token = prefs.getString('token');
                      if (token == null) {
                        throw Exception('Token is null');
                        // token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWZhZmViMGU0MDRjZjVkM2YwYmU5ODUiLCJpYXQiOjE3MTA5NDgwMTgsImV4cCI6MTcxMTAzNDQxOH0.8UTASn0Z3dUiCPGl92ITqwN8GOQm_VIQX6ZW2fOYl2Y";
                      }
                      if (hasJoined) {
                        try {
                          _fetchCommunityData();
                          await apiLogic.leaveCommunity(token, communityName);
                          setState(() {
                            showLeaveCommunityDialog(context, communityName);
                          });
                        } catch (e) {
                          print('Error leaving community: $e');
                          //TODO:  handle the error, show a message to the user
                          // show popup showLeaveCommunityDialog

                        }
                      } else {
                        try {
                          await apiLogic.joinCommunity(token, communityName);
                          setState(() {
                            hasJoined = true;
                            _fetchCommunityData();
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
                                      'You have succesfully joined the community: $communityName',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),

                            );
                          });
                        } catch (e) {
                          print('Error joining community: $e');
                          //TODO:  handle the error, show a message to the user
                        }
                      }
                    } catch (e) {
                      print('Error in SharedPreferences: $e');
                      //TODO:  handle the error, show a message to the user
                    }

                  },
                  child: Text(

                    hasJoined ? 'Joined' : 'Join',
                    // Change the text based on whether the user has joined or not
                    style: TextStyle(

                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.022,
                      color: hasJoined ? Colors.grey : Colors.white,
                      // Change the text color based on whether the user has joined or not
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .width * 0.02),
          Padding(
            padding: EdgeInsets.only(
                left: 20.0), // Adjust the padding value as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$description',
                  style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.03,
                      fontFamily: "IBM_Plex_Sans_Light",

                      color: Colors.black),

                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          AboutComunityPage(
                              subredditName: communityName)), // Replace SecondPage() with the actual page you want to navigate to
                    );
                  },
                  child: Text(
                    "See more",
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.03,
                        fontWeight: FontWeight
                            .bold // Set the color to dark blue
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
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero)),

            ),
            onPressed: () {
              timeSelection = showSortPostsBottomSheet(
                  context, _selectedSort, Icons.whatshot, _updateSortAndIcon,
                  fetchPosts, true);
              print('Time Selection');
              print(timeSelection);
            },

            child: Row(
              children: [



                Icon(_selectedIcon,  color: Colors.grey,),
                Text('${_selectedSort.toUpperCase()} POSTS', style: TextStyle(color: Colors.grey),),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
              ],
            ),

          ),
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
            width: MediaQuery
                .of(context)
                .size
                .width *1.6,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.14,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Are you sure you want to leave the r/$communityName community?',
                    textAlign: TextAlign.left,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.07,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              side: BorderSide(color: Colors.grey),
                            ),
                            child: Text(
                                'Cancel', style: TextStyle(color: Colors.grey)),
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .width * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                                'Leave', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              hasJoined = false;
                              _fetchCommunityData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                            30.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Text(
                                          'You have left the community: $communityName',
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  )
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
