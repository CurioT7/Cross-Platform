import 'package:flutter/material.dart';
import 'package:curio/Views/community/createCommunity.dart';
import 'package:curio/services/logicAPI.dart';
import 'package:curio/Views/insettingspage/accountSettings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

class sidebarAfterLogIn extends StatelessWidget {




  //String username = "Maximillian12";
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.09,
          bottom: MediaQuery.of(context).size.width * 0.09,
        ),
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset(
                    'lib/assets/images/avatar.jpeg',
                  ),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.035),
                ),

                // Text(
                //   'u/$username',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontFamily: 'IBM Plex Sans',
                //     fontSize:
                //     MediaQuery.of(context).size.width * 0.045,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                FutureBuilder<Map<String, dynamic>>(
                  future: _fetchUsername(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading spinner while waiting for _fetchUsername to complete
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Show an error message if _fetchUsername fails
                    } else {
                      String username = snapshot.data!['username']; // Get the username from the data returned by _fetchUsername
                      return Text(
                        'u/$username',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'IBM Plex Sans',
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                )
                ,

                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.08,
                      height: MediaQuery.of(context).size.width *
                          0.08,
                      child: Image.asset(
                        'lib/assets/images/karmaFlower.jpg',
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: _fetchUserDetails(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              bool isLoading =
                              (snapshot.connectionState == ConnectionState.waiting);

                              if (isLoading) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print(
                                    'Error fetching user details: ${snapshot.error}');
                                return Text(
                                    'Error fetching user details: ${snapshot.error}');

                              } else {
                                final userDetails = snapshot.data!;

                                return Text(
                                  '${userDetails['postKarma'] + userDetails['commentKarma']}',
                                  style: TextStyle(
                                    fontFamily: 'IBM Plex Sans Light',
                                    color: Colors.black,
                                    fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        Text(
                          'Karma',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Light',
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.095),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.12,
                      child: VerticalDivider(
                        thickness: 2,
                        width: MediaQuery.of(context).size.width * 0.09,
                        color: Colors.grey,
                      ),
                    ),

                    Icon(
                      Icons.cake, // Using the cake icon from Material Icons
                      size: MediaQuery.of(context).size.width *
                          0.08, // Adjust the size as needed
                      color: Colors.blue, // Adjust the color as needed
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Widgets inside the Column

                        Container(
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: _fetchUserDetails(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, dynamic>> snapshot) {
                              bool isLoading =
                              (snapshot.connectionState == ConnectionState.waiting);

                              if (isLoading) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                print(
                                    'Error fetching user details: ${snapshot.error}');
                                return Text(
                                    'Error fetching user details: ${snapshot.error}');

                              } else {
                                final userDetails = snapshot.data!;
                                return FutureBuilder<int>(
                                  future: apiLogic.daysSinceCakeDay(userDetails),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error calculating days since cake day: ${snapshot.error}');
                                    } else {
                                      final days = snapshot.data!;
                                      return Text(
                                          '${days}d',
                                          style: TextStyle(
                                            fontFamily: 'IBM Plex Sans Light',
                                            fontSize: MediaQuery.of(context).size.width * 0.035,
                                            fontWeight: FontWeight.bold,
                                          )
                                      );
                                    }
                                  },
                                );

                              }
                            },
                          ),
                        ),


                        Text(
                          'Reddit age',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Light',
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            leading: Icon(
              Icons.account_circle_outlined,
              color: Colors.grey[500],
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            title: Text(
              'My profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            leading: Icon(
              Icons.forum_outlined,
              color: Colors.grey[500],
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            title: Text(
              'Create a community',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => createCommunity()),
              )
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.width * 0.01,
            ),
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.grey[500],
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
