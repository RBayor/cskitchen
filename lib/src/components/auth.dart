import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<void> verifyPhoneNumber(String phoneNo);
  Future<String> currentUser();
  Future<String> currentPhone();
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

  Future<String> currentPhone() async {
    User user = firebaseAuth.currentUser;
    var phoneNumber;
    user == null ? phoneNumber = user : phoneNumber = user.phoneNumber;
    return phoneNumber;
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }
}
