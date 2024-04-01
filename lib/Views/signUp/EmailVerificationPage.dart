import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curio/Views/Home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curio/services/api_service.dart';
import 'package:curio/Views/signIn/signin.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  EmailVerificationScreen({required this.email, required this.password, required this.username});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isCheckingVerification = false;
  String? token;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: widget.email,
      password: widget.password,
    ).then((UserCredential userCredential) async {
      // After creating the user, send an email verification
      await userCredential.user!.sendEmailVerification();
    }).catchError((e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while creating the user'),
      ));
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please verify your email'),
            ElevatedButton(
              onPressed: isCheckingVerification ? null : () async {
                setState(() {
                  isCheckingVerification = true;
                });
                try{
                User? user = FirebaseAuth.instance.currentUser;
                await user!.reload();
                String? token = await user.getIdToken();
                user = FirebaseAuth.instance.currentUser;
                if (user!.emailVerified) {

                  // TODO: Sign in with the token to the server
                  // final response = await ApiService().signInWithToken(token!);
                  // if (response['success'] == true) {
                  //   // save the token into secure storage
                  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                  //   await prefs.setString('token', response['accessToken']);
                    // Navigate to the LoginScreen
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  // }
                }
                setState(() {
                  isCheckingVerification = false;
                });
                }catch(e){
                  print(e);
                  setState(() {
                    isCheckingVerification = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('An error occurred while checking the verification'),
                  ));
                }
              },
              child: Text(isCheckingVerification ? 'Checking...' : 'Check Verification'),
            ),
          ],
        ),
      ),
    );
  }
}