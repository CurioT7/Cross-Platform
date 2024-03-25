import 'package:flutter/material.dart';
import 'package:curio/Views/user_profile.dart';
import 'package:curio/Views/sidebars/sideBarAfterLogIn.dart';
import 'package:curio/Views/homeNavbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: sidebarAfterLogIn(),
      bottomNavigationBar: homeNavigationBar(),
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  UserProfilePage()));
              },
              child: const Text('View Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}