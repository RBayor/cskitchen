import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<void> verifyPhoneNumber(String phoneNo);
  Future<String> currentUser();
  Future<void> signOut();
  /*Future<void> resetPassword(String email);
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);*/
}

class Auth implements BaseAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNo) async {}

  Future<String> currentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    var id;
    user == null ? id = user : id = user.uid;
    return id;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

/*
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return user.uid;
  }
  Future<void> resetPassword(String email) async {
    return await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }*/
}
