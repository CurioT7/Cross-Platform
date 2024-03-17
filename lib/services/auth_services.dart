import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  //sign in with Google
  static const String _baseUrl = 'http://localhost:3000/api/auth';
  Future signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the GoogleSignInAuthentication object
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      // Create a new credential
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(googleCredential);
    } catch (e) {
      print(e.toString());
    }
  }
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to signup');
    }
  }

  Future<Map<String, dynamic>> isUsernameAvailable(String username) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/username_available'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 409) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check username availability');
    }
  }
}
