
import 'package:flutter/material.dart';
import 'package:curio/Views/user_profile.dart';
import 'package:curio/Views/sidebars/sideBarAfterLogIn.dart';
import 'package:curio/Views/homeNavbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:curio/Views/signIn/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatelessWidget {

  final FlutterSecureStorage storage = FlutterSecureStorage();
  HomeScreen({Key? key}) : super(key: key);

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('token');
    return action;
  }
  // print the token

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
              onPressed: () async{
                try {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  var value = prefs.getString('token');
                  print(value);
                await prefs.remove('token');
                }
                catch(e){
                  print(e);
                }
                // go to the signin page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );

              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}