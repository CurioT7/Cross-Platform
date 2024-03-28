import 'package:curio/Views/Home_screen.dart';
import 'package:curio/Views/sidebars/sideBarAfterLogIn.dart';
import 'package:flutter/material.dart';
import 'package:curio/Views/signIn/signin.dart';
import 'package:curio/Views/insettingspage/accountSettings.dart';
import 'package:curio/Views/community/aboutComunity.dart';
import 'package:curio/Views/sidebars/sideBarBeforeLogIn.dart';
import 'package:curio/Views/homeNavbar.dart'; // Import the custom widget file
import 'package:curio/services/api_service.dart';
import 'package:curio/Views/sidebars/inLeftSideBarAll.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GoogleAuthSignInService googleAuthSignInService = GoogleAuthSignInService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
      if (settings.name!.startsWith('/auth/google/callback')) {
        final uri = Uri.parse(settings.name!);
        final code = uri.queryParameters['code'];
        if (code != null) {
          googleAuthSignInService.handleGoogleAuthCallback(code);
        }
      }
      return null;
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:AllPage(),
    );
  }
}


class homePageBeforeSignin extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
      endDrawer:sidebarAfterLogIn(),
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


