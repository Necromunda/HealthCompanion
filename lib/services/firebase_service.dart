import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appuser_model.dart';

class FirebaseService {
  static Future<AppUser?> createUserOnSignup({
    required User user,
    required String username,
    required int age,
    required int height,
    required double weight,
    required String email,
  }) async {
    try {
      // await FirebaseFirestore.instance.collection('user_items').doc(user.uid).set({"items": []});
      // await FirebaseFirestore.instance.collection('user_settings').doc(user.uid).set({"darkMode": false});
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "username": username,
        "age": age,
        "height": height,
        "weight": weight,
        "email": email,
        "joinDate": user.metadata.creationTime,
      });
      return AppUser(
        email: email,
        uid: user.uid,
        username: username,
        joinDate: user.metadata.creationTime,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<AppUser?> createUser(String uid) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userDocument = db.collection("users").doc(uid);

      var userDocumentSnapshot = await userDocument.get();
      var firestoreUser = userDocumentSnapshot.data() as Map<String, dynamic>;
      firestoreUser["uid"] = userDocumentSnapshot.id;

      return AppUser.fromJson(firestoreUser);
      // return AppUser(
      //   username: firestoreUser['username'],
      //   email: firestoreUser['email'],
      //   joinDate: firestoreUser['joinDate'].toDate(),
      //   uid: userDocumentSnapshot.id,
      // );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
