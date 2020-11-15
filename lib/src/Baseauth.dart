import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<User> googlesignIn();
  Future<User> applesignIn();
  Future<void> signOut();
}
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Future<User> signUp(String email, String password) async {
    UserCredential usercred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    try {
      await usercred.user.sendEmailVerification();
      return usercred.user;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }

  @override
  Future<User> signIn(String email, String password) async{
    // TODO: implement signIn
    UserCredential usercred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return usercred.user;
  }


  @override
  Future<void> signOut() {
    _firebaseAuth.signOut();
    googleSignIn.signOut();
  }

  @override
  Future<User> googlesignIn() async{
    // TODO: implement googlsignIn
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    return authResult.user;
  }

  @override
  Future<User> applesignIn() {
    // TODO: implement applesignIn
    throw UnimplementedError();
  }



}