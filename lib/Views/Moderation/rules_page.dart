import 'package:curio/Views/Moderation/create_rule.dart';
import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  final String subredditName;

  RulesPage({required this.subredditName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rules',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '0/15 rules',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              color: Colors.orange,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'Create rules for r/$subredditName',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Rules help set expectations for how people should take part in your community and help shape the community\'s culture. Not sure where to start? Get advice from other mods.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRulePage()),
                );
              },
              child: Text('Create rules'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
              ),
            ),
          ],
        ),
      ),
    );
  }
}