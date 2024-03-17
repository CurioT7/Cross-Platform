import 'package:flutter/material.dart';

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
    );
  }
}
