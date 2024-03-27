import 'package:flutter/material.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:curio/Views/community/aboutComunityAppBar.dart';

class AboutComunityPage extends StatefulWidget {
  const AboutComunityPage({Key? key});

  @override
  State<AboutComunityPage> createState() => _AboutComunityPageState();
}

class _AboutComunityPageState extends State<AboutComunityPage> {
  final List<String> rules = [
    'No doxxing',
    'No brigading or inciting harassment',
    'Be civil',
    'No bigotry',
    'Suicide prevention',
    'Moderator discretion',
    'Content regulation',
    'No sex work-related content',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AboutCommunityAppBar(), // Use the AboutComunityAppBar here
      body: Container(
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
                    'r/AlexandriaEgy is a subreddit for the city of Alexandria, Egypt and its residents, visitors and admirers. Whether you want to share your photos, stories, news, events, questions or tips about this ancient and beautiful city, You are welcome to join our community and celebrate its rich history and culture.',
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
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('u/Moderator $index'),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: homeNavigationBar(),
    );
  }
}

