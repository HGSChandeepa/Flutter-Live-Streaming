import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_streaming/utils/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //sign in with gamail

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      // Obtain the GoogleSignInAuthentication object
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google Auth credential
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(
          'Error signing in with Google: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  // Sign out

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get the current user

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
