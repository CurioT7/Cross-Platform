import 'package:flutter/material.dart';
import 'package:curio/post/screen_post.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homeNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home', ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.supervisor_account_outlined,
            ), label: 'Communities'),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ), label: 'Create'),

        BottomNavigationBarItem(icon: Icon(Icons.textsms_outlined), label: 'Chat', ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,

            ), label: 'Inbox'),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,

      showSelectedLabels: true,
      showUnselectedLabels: true,

      iconSize: MediaQuery.of(context).size.width * 0.07,

      selectedLabelStyle: TextStyle(
        fontFamily: 'IBM Plex Sans Light',
        fontSize: MediaQuery.of(context).size.width * 0.03,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'IBM Plex Sans Light',
        fontSize: MediaQuery.of(context).size.width * 0.03,
      ),
      onTap: (index) async {
        switch (index) {
          case 0:
            // Handle tap on 'Home'
            break;
          case 1:
            try {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString('token');
              if (token == null) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>communityProfile()),
              );
            }
            catch (e) {
              throw Exception('Error fetching user details: $e');
            }


            break;
          case 2:
            // Handle tap on 'Create'
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('token');
            if (token == null) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPostScreen(type:'text')),
            );
            break;
          case 3:
            // Handle tap on 'Chat'
            break;
          case 4:
            // Handle tap on 'Inbox'
            break;
        }
      },
    );
  }
}