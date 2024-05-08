import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/logicAPI.dart';

class CommunityDescription extends StatefulWidget {

  final String subreddit;

  CommunityDescription({required this.subreddit});

  @override
  _CommunityDescriptionState createState() => _CommunityDescriptionState();
}

class _CommunityDescriptionState extends State<CommunityDescription> {
  final TextEditingController _controller = TextEditingController();
  final int _maxCharacters = 500;
  final logicAPI logic = logicAPI(); // Initialize your LogicAPI class

  void initState() {
    super.initState();
    _fetchCommunityData();
  }
  String? description;
  void _fetchCommunityData() async {
    print('Fetching community data');
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData =
    await api.fetchCommunityData(widget.subreddit);
    setState(() {
      description = communityData['description'];

      _controller.text = description ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
        actions: [
          TextButton(
            onPressed: () async {
              // Call your function from logicapi here
              //get token from saved preferences
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString('token');
              if(token == null){
                throw Exception('Token is null');
              }

              bool result = await logic.updateCommunitySettingsDescription(token, widget.subreddit, _controller.text);
              if (result) {
                // pop up page
                Navigator.pop(context);
              } else {
                // Handle failure
                //show snackbar that says there is an error in updating description
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error in updating description'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text(
              'Save Text',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Describe your community',
              style: TextStyle(color: Colors.blue),
            ),
            TextField(
              controller: _controller,
              maxLength: _maxCharacters,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            Text(
              '${_maxCharacters - _controller.text.length} characters left',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
