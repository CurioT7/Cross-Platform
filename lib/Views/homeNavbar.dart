import 'package:flutter/material.dart';
import 'package:curio/post/screen_post.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Views/community/topCommunity.dart';

class HomeNavigationBar extends StatefulWidget {
  @override
  _HomeNavigationBarState createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int _selectedIndex = 0;
  String notificationCount = '3'; // Notification count

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account_outlined),
          label: 'Communities',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.textsms_outlined), label: 'Chat'),
        BottomNavigationBarItem(
          icon: NotificationIcon(
            notificationCount: notificationCount,
          ),
          label: 'Inbox',
        ),
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
      currentIndex: _selectedIndex,
      onTap: (index) async {
        setState(() {
          _selectedIndex = index;
        });
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
                MaterialPageRoute(builder: (context) => TopCommunitiesPage()),
              );
            } catch (e) {
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
              MaterialPageRoute(builder: (context) => AddPostScreen(type: 'text')),
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

class NotificationIcon extends StatelessWidget {
  final String notificationCount;

  const NotificationIcon({
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Icon(
          Icons.notifications_outlined,
          size: 36.0,
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(9),
          ),
          constraints: BoxConstraints(
            minWidth: 18,
            minHeight: 18,
          ),
          child: Text(
            notificationCount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
