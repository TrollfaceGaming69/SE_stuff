import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static bool isRegistering = false;

  Future<String?> register({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required String gender,
  }) async{
    try{
      isRegistering = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("users").doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _auth.signOut();
      isRegistering = false;

      return null;
    }
    on FirebaseAuthException catch (e){
      isRegistering = false;
      return _handleAuthError(e.code);
    } catch (e) {
      isRegistering = false;
      return 'An error occurred during registration.';
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e.code);
    }
  }

  Future<void> logout() async{
    await _auth.signOut();
  }

  String _handleAuthError(String code) {
    switch (code) {
      case "user-not-found":
        return 'No account found with this email.';
      case "wrong-password":
        return 'Password not match.';
      case "invalid-credential": 
        return 'Email or password does not match.';
      case "invalid-email":
        return 'The email address is badly formatted.';
      case "user-disabled":
        return 'This user account has been deleted.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

}