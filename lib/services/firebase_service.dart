import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appuser_model.dart';

class FirebaseService {

  static Future<AppUser?> createUserOnSignup(
      User user, String email, String password) async {
    try {
      // await FirebaseFirestore.instance.collection('user_items').doc(user.uid).set({"items": []});
      // await FirebaseFirestore.instance.collection('user_settings').doc(user.uid).set({"darkMode": false});
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(responseData.user?.uid)
      //     .set({
      //   'username': responseData.user?.displayName,
      //   'email': email,
      //   'joinDate': responseData.user?.metadata.creationTime,
      // });
      return AppUser.fromJson({});
    } catch (e) {
      print(e);
      return null;
    }
  }

}
