import 'package:curio/Views/Home_screen.dart';
import 'package:curio/Views/community/profile.dart';
import 'package:flutter/material.dart';
import 'package:curio/Views/signIn/signin.dart';
import 'package:curio/Views/insettingspage/accountSettings.dart';

import 'package:curio/Views/sidebars/sideBarBeforeLogIn.dart';
import 'package:curio/Views/homeNavbar.dart'; // Import the custom widget file
import 'package:curio/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     // home: homePageBeforeSignin(),
      home: communityProfile(),
    );
  }
}


class homePageBeforeSignin extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
      endDrawer: sideBarBeforeLogin(),
      bottomNavigationBar: homeNavigationBar(),
      appBar: AppBar(
        title: Text('Side menu'),

        actions: [ IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();

          },
        ),
        ],

      ),
    );
  }
}


