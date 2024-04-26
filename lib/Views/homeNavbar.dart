import 'package:flutter/material.dart';
import 'package:curio/post/screen_post.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/Views/community/topCommunity.dart';
import 'package:curio/services/apiServiceMahmoud.dart';

import 'Notifications/viewNotifications.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  _HomeNavigationBarState createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  String? notficationsMessage;
  int _selectedIndex = 0;
  String notificationCount = '0'; // Notification count
  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getUnreadNotifications() async {
    final apiService = ApiServiceMahmoud();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }
      final notifications = await apiService.getUnreadNotifications(token);
      setState(() {
        if (notifications['message'] == null) {
          notificationCount = notifications['unreadCount'];
        } else {
          notficationsMessage = notifications['message'];
          notificationCount = '0';
        }
      });
      print(notifications);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUnreadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account_outlined),
          label: 'Communities',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.textsms_outlined), label: 'Chat'),
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
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
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
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String? token = prefs.getString('token');
            if (token == null) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddPostScreen(type: 'text')),
            );
            break;
          case 3:
            // Handle tap on 'Chat'
            break;
          // case 4:

          //   break;
          case 4:
            getUnreadNotifications();
            if (notficationsMessage == null) {
              showSnackbar(context, 'There are no unread notifications');
            }
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String? token = prefs.getString('token');
            if (token == null) {
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewNotifications(),
              ),
            );
            break;
        }
      },
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final String notificationCount;

  const NotificationIcon({
    super.key,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    if (notificationCount == '0') {
      return const Icon(Icons.notifications_none_outlined);
    } else {
      return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          const Icon(
            Icons.notifications_outlined,
            size: 36.0,
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(9),
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Text(
              notificationCount,
              style: const TextStyle(
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
}
