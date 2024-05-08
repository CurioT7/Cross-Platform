import 'package:flutter/material.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:curio/Views/community/aboutComunityAppBar.dart';
import 'package:curio/services/ApiServiceMahmoud.dart';

class AboutComunityPage extends StatefulWidget {
  final String subredditName;

  const AboutComunityPage({Key? key, required this.subredditName}) : super(key: key);

  @override
  State<AboutComunityPage> createState() => _AboutComunityPageState();
}

class _AboutComunityPageState extends State<AboutComunityPage> {
  late Map<String, dynamic> subredditInfo = {};
  List<String> rules = [];

  @override
  void initState() {
    super.initState();
    // Fetch default subreddit information when the widget initializes
    fetchSubredditInfo(widget.subredditName);
  }

  Future<void> fetchSubredditInfo(String subredditName) async {
    try {
      // Fetch subreddit information using ApiServiceMahmoud
      final apiService = ApiServiceMahmoud();
      final data = await apiService.getSubredditInfo(subredditName);
      setState(() {
        subredditInfo = data['subreddit'];
        rules = List<String>.from(subredditInfo['rules']);
      });
    } catch (e) {
      print('Error fetching subreddit information: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AboutCommunityAppBar(subredditName: widget.subredditName),
      body: subredditInfo.isNotEmpty
          ? Container(
        color: Color(0xffFfFfFf),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20, child: Container(color: Color(0xffF2F3F5))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    subredditInfo['description'] ?? 'Description not available',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20, child: Container(color: Color(0xffF2F3F5))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Rules',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(),
              ],
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: rules.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(rules[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
            SizedBox(height: 20, child: Container(color: Color(0xffF2F3F5))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Moderators',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(),
              ],
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: subredditInfo['moderators'].length,
              itemBuilder: (BuildContext context, int index) {
                final moderator = subredditInfo['moderators'][index];
                return ListTile(
                  title: Row(
                    children: [

                      Text(moderator['username']),
                      SizedBox(width: 15),
                      Text(moderator['role']),

                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: HomeNavigationBar(),
    );
  }
}
