import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'signup.dart';
// import 'package:firebase_core/firebase_core.dart';
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: 'AIzaSyBqiGQOy7b5ialwfc7PVDiX8OtEZ0TRGVk',
  //     appId: '1:824083216537:android:5c002a498811b1f7da6008',
  //     messagingSenderId: '824083216537',
  //     projectId: "cruio-3d9a5",
  //   ),
  // );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Widget _buildFadeInUpWidget({required int duration, required Widget child}) {
    return FadeInUp(duration: Duration(milliseconds: duration), child: child);
  }

  Widget _buildMaterialButton({required String text, required VoidCallback onPressed}) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.black
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Text(text, style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18
      ),),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: <Widget>[
        _buildFadeInUpWidget(duration: 1000, child: Text("Welcome", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30
        ),)),
        SizedBox(height: 20,),
        _buildFadeInUpWidget(duration: 1200, child: Text("Automatic identity verification which enables you to verify your identity",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15
          ),)),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20,),
        _buildFadeInUpWidget(duration: 1600, child: Container(
          padding: EdgeInsets.only(top: 3, left: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border(
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
              )
          ),
          child: _buildMaterialButton(text: "Sign up", onPressed: () {
            Navigator.push(context, _createRoute());
          }),
        ))
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildWelcomeText(),
            SizedBox(height: 50,),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }
}