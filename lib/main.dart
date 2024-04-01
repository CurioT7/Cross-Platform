import 'package:curio/Views/Home_screen.dart';
import 'package:curio/Views/signIn/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:curio/Views/signIn/signin.dart';
import 'package:curio/Views/insettingspage/accountSettings.dart';
import 'package:routemaster/routemaster.dart';
import 'package:curio/Views/sidebars/sideBarBeforeLogIn.dart';
import 'package:curio/Views/homeNavbar.dart'; // Import the custom widget file
import 'package:curio/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curio/post/community_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// void main() async{
//   List<Community> communities = Community.getCommunities();
//   // create community cards
//   List<Widget> communityCards = [];
//   for (Community community in communities) {
//     communityCards.add(CommunityCard(
//       community: community,
//       onTap: () {
//         print('Tapped on ${community.name}');
//       },
//     ));
//   }
//   // display the cards
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Communities'),
//       ),
//       body: ListView(
//         children: communityCards,
//       ),
//     ),
//   ));
// }
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
    return MaterialApp.router(
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
      routeInformationParser: const RoutemasterParser(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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


final routes = RouteMap(
  routes: {
    '/': (_) => MaterialPage(child: homePageBeforeSignin()),
    '/home': (_) => MaterialPage(child: HomeScreen()),
    '/reset-password/:token': (routeData) {
      final token = routeData.pathParameters['token'];
      return MaterialPage(child: ResetPasswordPage(token: token));
    },
  },
);