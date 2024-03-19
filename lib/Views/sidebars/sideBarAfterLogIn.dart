import 'package:flutter/material.dart';
import 'package:curio/Views/community/createCommunity.dart';
import 'package:curio/services/logicAPI.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class sidebarAfterLogIn extends StatelessWidget {
  final logicAPI apiLogic = logicAPI();

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
                Center(
                  child: FutureBuilder<String>(
                      future: apiLogic.fetchUsername(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error fetching username: ${snapshot.error}');
                        } else {
                          return Text(
                            'u/$apiLogic.fetchUsername();',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'IBM Plex Sans',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      }),
                ),
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
                        Text(
                          'Karma #',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Light',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
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
                        Text(
                          '21d',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans Light',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
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
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
