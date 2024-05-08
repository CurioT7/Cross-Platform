import 'package:flutter/material.dart';

import '../../services/logicAPI.dart';

class CommunityType extends StatefulWidget {
  final String subreddit;

  CommunityType({required this.subreddit});

  @override
  _CommunityTypeState createState() => _CommunityTypeState();
}

class _CommunityTypeState extends State<CommunityType> {

  String? privacyMode;

  bool? isOver18;
  @override
  void initState() {
    super.initState();
    _fetchCommunityData();
  }
  void _fetchCommunityData() async {
    print('Fetching community data');
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData =
    await api.fetchCommunityData(widget.subreddit);
    setState(() {
       privacyMode = communityData['privacyMode'];
isOver18 = communityData['isOver18'];

       if (privacyMode == 'public') {
         _currentSliderValue = 0;
       } else if (privacyMode == 'restricted') {
         _currentSliderValue = 1;
       } else if (privacyMode == 'private') {
         _currentSliderValue = 2;
       }
    });
  }
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    Color color;
    String title;
    String description;

    if (_currentSliderValue < 1) {
      color = Colors.green;
      title = 'Public';
      description = 'Anyone can see and participate in this community';
    } else if (_currentSliderValue < 2) {
      color = Colors.yellow[700]!;
      title = 'Restricted';
      description = 'Anyone can see, join or vote in this community, but you control who posts and comments';
    } else {
      color = Colors.red;
      title = 'Private';
      description = 'Only people you approve can see and participate in this community';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Community type'),
        actions: [
          TextButton(
            onPressed: () {
              // Save the community type here
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Text(
              title,
              style: TextStyle(color: color, fontSize: 24),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                    top: MediaQuery.of(context).size.width * 0.07,
                  ), // Adjust padding as needed
                  child: Text(
                    '18+ community',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.width * 0.07,

                  ), // Adjust padding as needed
                  child: Switch.adaptive(
                    activeTrackColor: Colors.blueAccent[400],
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey[200],
                    value: isOver18 ?? false, // Set the initial value based on isOver18
                    onChanged: (value) {
                      setState(() {
                        isOver18 = value; // Update isOver18 when the switch is toggled
                      });
                    },
                  ),
                ),
              ],
            ),
          ],

        ),
      ),

    );
  }
}