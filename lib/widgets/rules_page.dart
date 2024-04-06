import 'package:flutter/material.dart';
import 'package:curio/services/api_service.dart';

class RulesPage extends StatelessWidget {
  final String communityId;

  const RulesPage({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: ApiService().communityRules(communityId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Rules are different for each community. Reviewing the rules can help you be more successful when posting or commenting in this community.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                ...snapshot.data!.map((rule) {
                  return ExpansionTile(
                    title: Text(rule['header']!),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(rule['body']!),
                      )
                    ],
                  );
                }),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
                0xFF0079D3), // Set the background color to Reddit's blue color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'I Understand',
            style:
            TextStyle(color: Colors.white), // Set the text color to white
          ),
        ),
      ),
    );
  }
}