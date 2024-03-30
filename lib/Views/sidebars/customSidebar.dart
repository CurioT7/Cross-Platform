import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ExpansionTile(
            title: Text('Recently Visited'),
            children: <Widget>[
              ListTile(
                title: Text('Subreddit 1'),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // Implement your delete functionality here
                  },
                ),
              ),
              ListTile(
                title: Text('Subreddit 2'),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    // Implement your delete functionality here
                  },
                ),
              ),
              ListTile(
                title: Text('See All'),
                onTap: () {
                  // Implement your see all functionality here
                },
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: Text('Your Communities'),
            children: <Widget>[
              ListTile(
                title: Text('Community 1'),
                trailing: IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: () {
                    // Implement your favorite functionality here
                  },
                ),
              ),
              ListTile(
                title: Text('Community 2'),
                trailing: IconButton(
                  icon: Icon(Icons.star_border),
                  onPressed: () {
                    // Implement your favorite functionality here
                  },
                ),
              ),
            ],
          ),
          Divider(),
          ListTile(
            title: Text('All'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}