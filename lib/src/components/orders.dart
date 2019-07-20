import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartDb {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> placeOrder(var order, var id) async {
    if (isLoggedIn()) {
      // DocumentReference orderRef =
      //    Firestore.instance.collection("orders").document(id);
      Firestore.instance.runTransaction((Transaction tx) async {});
    }
  }
}
