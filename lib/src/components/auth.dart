import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<void> verifyPhoneNumber(String phoneNo);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNo) async {}

  Future<String> currentUser() async {
    User user = firebaseAuth.currentUser;
    var id;
    user == null ? id = user : id = user.uid;
    return id;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }
}
