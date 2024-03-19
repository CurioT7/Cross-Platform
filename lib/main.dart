import 'package:flutter/material.dart';
import 'package:curio/Views/signIn/sign_in_page.dart';
import 'package:curio/Views/insettingspage/accountSettings.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Curio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountSettingsPage(),
    );
  }
}
