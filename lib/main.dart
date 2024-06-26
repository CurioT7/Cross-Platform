import 'package:curio/Views/signUp/signup_email.dart';
import 'package:curio/bloc_observer.dart';
import 'package:curio/controller/chat_cubit/chat_cubit.dart';
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
  Bloc.observer = MyBlocObserver();
  await storage.deleteAll();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
          ),
          colorScheme: const ColorScheme.light(
            primary: Colors.white,
            onPrimary: Colors.black,
            secondary: Colors.deepOrange,
            onSecondary: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.deepOrange,
          ),
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
      bottomNavigationBar: HomeNavigationBar(),
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
