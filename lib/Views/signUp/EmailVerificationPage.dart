import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curio/Views/Home_screen.dart';
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
      token = await userCredential.user!.getIdToken();

      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        print("Email Verification Screen: User: $user");
        if (user != null) {
          // Add a delay before reloading the user's data
          await Future.delayed(Duration(seconds: 5));
          // Reload the user's information
          await user.reload();
          user = FirebaseAuth.instance.currentUser;
          if (user!.emailVerified) {
            print('Email is verified');
            // final response = await ApiService().signInWithToken(token!);
            // if (response['success'] == true) {
            //   // save the token into secure storage
            //   final SharedPreferences prefs = await SharedPreferences.getInstance();
            //   await prefs.setString('token', response['accessToken']);
            //   // Navigate to the LoginScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            // }
            // else{
            //   if(response['message'].contains('email-already-in-use')) {
            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       content: Text('Email already in use'),
            //     ));
            //   }else{
            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       content: Text(response['message']),
            //     ));
            //   }
            // }
          }
        }
      });
    }).catchError((error) {
      print("Error: $error");
      String errorMessage = error.toString();
      if(errorMessage.contains('email-already-in-use')){
        errorMessage = 'Email already in use';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
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
                user = FirebaseAuth.instance.currentUser;
                if (user!.emailVerified) {
                  print('Email is verified');
                  print('Token: $token');
                  // TODO: Sign in with the token to the server
                  // final response = await ApiService().signInWithToken(token!);
                  // if (response['success'] == true) {
                  //   // save the token into secure storage
                  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                  //   await prefs.setString('token', response['accessToken']);
                    // Navigate to the LoginScreen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInPage()),
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