import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/logicAPI.dart';

class CommunityType extends StatefulWidget {
  final String subreddit;

  CommunityType({required this.subreddit});

  @override
  _CommunityTypeState createState() => _CommunityTypeState();
}

class _CommunityTypeState extends State<CommunityType> {

  String? privacyMode;
  Future<bool>? _communityDataFuture;
  bool? isOver18;
  @override
  void initState() {
    super.initState();
    _communityDataFuture = _fetchCommunityData();
    print("widget subreddit");
    print(widget.subreddit);
  }

  Future<bool> _fetchCommunityData() async {
    print('Fetching community data');
    logicAPI api = logicAPI();
    Map<String, dynamic> communityData = await api.fetchCommunityData(widget.subreddit);
    print('Fetched community data: $communityData'); // Add this line
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
    return true;
  }
  double? _currentSliderValue ;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  _communityDataFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Color color;
          String title;
          String description;

          if (_currentSliderValue! < 1) {
            color = Colors.green;
            title = 'Public';
            description = 'Anyone can see and participate in this community';
          } else if (_currentSliderValue! < 2) {
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
                  onPressed: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');
                    if(token == null){
                      throw Exception('Token is null');
                    }
                    String over18;
                    if (isOver18==false){
                      over18="false";
                    }
                    else{
                      over18="true";
                    }
                    Future <bool> issuccessful =logicAPI().updateCommunitySettingsPrivacy(token, widget.subreddit, privacyMode!, over18);
                    if (issuccessful==true){
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error in updating privacy mode'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
                    value: _currentSliderValue ?? 0,
                    min: 0,
                    max: 2,
                    divisions: 2,
                    activeColor: color,
                    onChanged: (double value) {
                      setState(()  {
                        _currentSliderValue = value;

                        if (_currentSliderValue == 0){
                          privacyMode = 'public';
                        } else if (_currentSliderValue == 1){
                          privacyMode = 'restricted';
                        } else if (_currentSliderValue == 2) {
                          privacyMode = 'private';
                        }
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
                        ),
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
                        ),
                        child: Switch.adaptive(
                          activeTrackColor: Colors.blueAccent[400],
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[200],
                          value: isOver18 ?? false,
                          onChanged: (value) {
                            setState(() {
                              isOver18 = value;
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
      },
    );
  }

}