import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final AuthServices authServices = AuthServices._();
  bool isNewUser = false;

  AuthServices._();

  // create account with email
  Future<User?> createAccountWithEmail(String email, String password) async {
    try {
      final userCredentials = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      isNewUser = (userCredentials.user != null)
          ? userCredentials.additionalUserInfo!.isNewUser
          : false;
      return userCredentials.user;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // sign in with email
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredentials = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    isNewUser = (userCredentials.user != null)
        ? userCredentials.additionalUserInfo!.isNewUser
        : false;
    log("login new user : $isNewUser");
    return userCredentials.user;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    print(firebaseAuth.currentUser);
  }

  Future<User?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      isNewUser = (userCredential.user != null)
          ? userCredential.additionalUserInfo!.isNewUser
          : false;
      return userCredential.user;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
