import 'package:curio/Views/signUp/signup_email.dart';
import 'package:flutter/material.dart';

import 'package:curio/Views/sidebars/sideBarBeforeLogIn.dart';
import 'package:curio/Views/homeNavbar.dart'; // Import the custom widget file
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'controller/history_cubit/history_cubit.dart';

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
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const SignUpWithEmail(),
      ),
    );
  }
}

class HomePageBeforeSignIn extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePageBeforeSignIn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const sideBarBeforeLogin(),
      bottomNavigationBar: homeNavigationBar(),
      appBar: AppBar(
        title: const Text('Side menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
