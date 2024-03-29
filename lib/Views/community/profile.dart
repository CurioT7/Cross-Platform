import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:curio/Views/community/topAppBar.dart';
//import logicAPI.dart
import 'package:curio/services/logicAPI.dart';
//import postcard
import 'package:curio/post/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class communityProfile extends StatefulWidget {
  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<communityProfile> {
  final ValueNotifier<double> blurValue = ValueNotifier<double>(0.0);
  String communityName = "Movies dignissimos";
  bool hasJoined = false;

  List<Map<String, dynamic>> posts = [];
  String? privacyMode;
  String? name;
  String? description;
  int? membersCount;
  String? banner;
  String? icon;

  void fetchCommunityData() async {
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData = await api.fetchCommunityData(communityName);
    setState(() {
      privacyMode = communityData['privacyMode'];
      name = communityData['name'];
      description = communityData['description'];
      membersCount = communityData['membersCount'];
      banner = communityData['banner'];
      icon = communityData['icon'];
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchPosts();
  }

  // void fetchPosts() async {
  //   logicAPI api = logicAPI();
  //   List<Map<String, dynamic>> fetchedPosts = await api.fetchCommunityProfilePosts(communityName);
  //   setState(() {
  //     posts = fetchedPosts;
  //   });
  // }
  void fetchPosts() async {
    logicAPI api = logicAPI();
    List<Map<String, dynamic>> fetchedPosts = await api.fetchCommunityProfilePosts(communityName);
    Map<String, dynamic> fetchedUserDetails = await _fetchUserDetails();
    String profilePicture = fetchedUserDetails['profilePicture'];
    setState(() {
      posts = fetchedPosts.map((post) => {
        ...post,
        'userImage': profilePicture,
      }).toList();
    });
  }


  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    double scrollPosition = _scrollController.position.pixels;
    double limit = MediaQuery.of(context).size.width * 0.3; // Set your limit here

    if (scrollPosition > limit) {
      blurValue.value = 3.0; // Set a high blur value
    } else {
      blurValue.value = 0.0; // Calculate the blur value as before
    }
  }

  final logicAPI apiLogic = logicAPI();
  Map<String, dynamic>? userDetails;

  Future<Map<String, dynamic>> _fetchUsername() async {

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token is null');
      }
      final username = await apiLogic.fetchUsername(token);
      final data= await apiLogic.extractUsername(username);
      print('DATA HERE');
      print(data);
      return data;
      await prefs.remove('token');
    }
    catch (e) {
      throw Exception('Error fetching user details: $e');
    }

  }

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print(token);
      if (token == null) {
        throw Exception('Token is null');
      }

      final usernameData = await _fetchUsername();
      String username = usernameData['username'];

      final userData = await apiLogic.fetchUserData(username);
      final data = await apiLogic.extractUserDetails(userData);

      print('DATA HERE');
      print(data);
      return data;
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

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
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.05,

                backgroundImage: NetworkImage(icon ?? 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vectorstock.com%2Froyalty-free-vector%2Fno-connection-icon-wifi-vector-46940244&psig=AOvVaw1HGJnDaDIO_US78iYBz5FH&ust=1711800821175000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJC61pO5mYUDFQAAAAAdAAAAABAE') , // check is correct

                //backgroundImage: AssetImage('lib/assets/images/example.jpg'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('r/$name',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('$membersCount members',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM_Plex_Sans_Light')),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      //draw green filled icon circle
                      Container(
                        width: MediaQuery.of(context).size.width * 0.02,
                        height: MediaQuery.of(context).size.width * 0.02,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(' 2,654 online',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IBM_Plex_Sans_Light')),
                    ],
                  ),
                ],
              ),

              //choose height and width of button

              SizedBox(width: MediaQuery.of(context).size.width * 0.23),
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.11, // Set the width of the button
                height: MediaQuery.of(context).size.width *
                    0.07, // Set the height of the button

                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (hasJoined) {
                          return Colors.white; // Set the button color to white if the user has joined
                        } else {
                          return Colors.blue.shade900; // Otherwise, set it to dark blue
                        }
                      },
                    ),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                        if (hasJoined) {
                          return BorderSide(color: Colors.grey); // Set the border color to dark grey if the user has joined
                        } else {
                          return BorderSide.none; // Otherwise, no border
                        }
                      },
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString('token');
                      if (token == null) {
                        throw Exception('Token is null');
                      }
                      await apiLogic.joinCommunity(token, communityName);
                      setState(() {
                        hasJoined = true; // Set hasJoined to true after the user has joined the community
                      });
                      // TODO:  update the UI after the user has joined the community
                      //Update text of button to "Joined" in white button, text font and border in darkgrey

                    } catch (e) {
                      print('Error joining community: $e');
                      //TODO:  handle the error, show a message to the user
                    }
                  },
                  child: Text(
                    hasJoined ? 'Joined' : 'Join', // Change the text based on whether the user has joined or not
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.025,
                      color: hasJoined ? Colors.grey : Colors.white, // Change the text color based on whether the user has joined or not
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.02),
          Padding(
            padding: EdgeInsets.only(
                left: 20.0), // Adjust the padding value as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$description',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontFamily: "IBM_Plex_Sans_Light",

                  color: Colors.black),

                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => communityProfile()), // Replace SecondPage() with the actual page you want to navigate to
                    );
                  },
                  child: Text(
                    "See more",
                    style: TextStyle(
                      color: Colors.blue[900],
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold// Set the color to dark blue
                    ),
                  ),
                )
              ],
            ),
          ),
           Divider(thickness: 1.0),
      Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(
              title: posts[index]['title'],
              content: posts[index]['content'],
              username: posts[index]['authorName'],
              postTime: posts[index]['createdAt'],
              userImage: posts[index]['profilePicture'],

              // Add other fields as required
            );
          },
        ),
      ),
        ],
      ),
    );
  }


}
