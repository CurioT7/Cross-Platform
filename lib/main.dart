import 'package:flutter/material.dart';

import 'package:curio/widgets/sideBarBeforeLogIn.dart';
import 'package:curio/widgets/home.dart'; // Import the custom widget file


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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






