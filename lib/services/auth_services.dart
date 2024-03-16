import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //sign in with Google
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

}