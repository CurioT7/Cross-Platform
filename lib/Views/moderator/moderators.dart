
import 'package:flutter/material.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeratorsPage extends StatefulWidget {
  final String subredditName;
  const ModeratorsPage({Key? key, required this.subredditName}) : super(key: key);
  @override
  _ModeratorsPageState createState() => _ModeratorsPageState();
}

class _ModeratorsPageState extends State<ModeratorsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ApiServiceMahmoud _apiService = ApiServiceMahmoud();
  late Future<Map<String, dynamic>> _moderatorsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _moderatorsFuture = _fetchModerators();
    print('Subreddit name: ${widget.subredditName}');
    print(_moderatorsFuture);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchModerators() async {
    try {
      return await _apiService.getModerators(widget.subredditName);
    } catch (e) {
      print('Failed to fetch moderators: $e');
      throw e;
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  void _handleRemoveTap(String? token, String subredditName, String role, String moderationName) async {
    Navigator.pop(context);
    if (token != null) {
      print('calling the api from the location page');
      var responseData = await _apiService.removeModerator(token,subredditName, role, moderationName);
      if (responseData['success'] == 'true') {
        print(responseData['message']);
        _showSnackBar( responseData['message']);
        // Optionally, you can handle further actions here if needed
      } else {
        _showSnackBar(responseData['message']);
        // Optionally, you can handle further actions here if needed
      }
    } else {
      _showSnackBar( 'Token is null. Please log in again.');
      // Optionally, you can handle further actions here if needed
    }
  }

  void showGenderBottomSheet(bool isCreator, String username,String role) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            List<Widget> children = []; // Initialize an empty list of widgets
            print('Is creator: $isCreator');
            if (isCreator == false)
            {
              children.add(
                GestureDetector(
                  onTap: () {
                    print('Row tapped');
                  },
                  child: Container(
                    height: 60, // specify the height of the container
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20, // specify width
                        ),
                        Icon(Icons.edit, size: 30), // specify the size of the icon
                        SizedBox(
                          width: 20, // specify width
                        ),
                        Text('Edit Permissions', style: TextStyle(fontSize: 20)), // specify the size of the text
                      ],
                    ),
                  ),
                ),
              );
            }

            children.addAll([
              GestureDetector(
                onTap: () {
                  print('Row tapped');
                },
                child: Container(
                  height: 60, // specify the height of the container
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20, // specify width
                      ),
                      Icon(Icons.person, size: 30), // specify the size of the icon
                      SizedBox(
                        width: 20, // specify width
                      ),
                      Text('View Profile', style: TextStyle(fontSize: 20)), // specify the size of the text
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Row tapped');
                  showLeaveCommunityDialog(context, username, widget.subredditName,role);
                },
                child: Container(
                  height: 60, // specify the height of the container
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20, // specify width
                      ),
                      Icon(Icons.block, size: 30), // specify the size of the icon
                      SizedBox(
                        width: 20, // specify width
                      ),
                      Text('Remove', style: TextStyle(fontSize: 20)), // specify the size of the text
                    ],
                  ),
                ),
              ),
            ]);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: children, // Use the list of widgets
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moderators Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {


            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          isScrollable: false,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Editable'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Display the list of moderators in the "All" tab
          _buildAllTab(),
          // Add your widgets for the second tab (Editable)
          _buildEditableTab(),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return FutureBuilder(
      future: _moderatorsFuture,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> moderators = snapshot.data?['moderators'] ?? [];
          return ListView.builder(
            itemCount: moderators.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> moderator = moderators[index];
              String username = moderator['username'];
              String role = moderator['role'];
              return ListTile(
                leading: Image.asset('lib/assets/images/Curio.png', height: 40, width: 40),
                title: Text(username),
                subtitle: Text('Role: $role'),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildEditableTab() {
    return FutureBuilder(
      future: _moderatorsFuture,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<dynamic> moderators = snapshot.data?['moderators'] ?? [];
          return ListView.builder(
            itemCount: moderators.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> moderator = moderators[index];
              String username = moderator['username'];
              String role = moderator['role'];
              bool isCreator = moderator['role'] == 'creator' ? true : false;
              print('Is creator: $isCreator');
              return ListTile(
                leading: Image.asset('lib/assets/images/Curio.png', height: 40, width: 40),
                title: Text(username),
                subtitle: Text('Role: $role'),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showGenderBottomSheet(isCreator, username,role);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void showLeaveCommunityDialog(BuildContext context, String UserName,String communityName,String role) {
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

                Text('Remove U/$UserName', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),


                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Are you sure you want to remove this moderator',
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
                            onPressed: () {
                              Navigator.of(context).pop();

                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
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
                            onPressed: () async {
                              Navigator.of(context).pop();

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var token = prefs.getString('token');

                              _handleRemoveTap(token, communityName, role, UserName);
                              print('fetching moderators');
                              setState(() {
                                _moderatorsFuture = _fetchModerators();
                              });
                              print('fetching moderators');
                              print(_moderatorsFuture);
                            },

                            child: Text('Remove', style: TextStyle(color: Colors.white)),
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