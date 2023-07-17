import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_companion/models/component_model.dart';

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
      await FirebaseFirestore.instance
          .collection('user_components')
          .doc(user.uid)
          .set({"components": []});
      await FirebaseFirestore.instance
          .collection('user_preferences')
          .doc(user.uid)
          .set({"kcalGoal": null, "darkMode": false});
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> saveUserComponents(String? uid, Component component) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef = db.collection("user_components").doc(uid);
      List<Component>? userComponents = await getUserComponents(uid);
      if (userComponents != null) {
        List<Map<String, dynamic>> json = userComponents.map((item) => item.toJson()).toList();
        json.add(component.toJson());
        await userComponentsDocRef.update({"components": json});
        return true;
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return false;
    }
    return false;
  }

  static Future<List<Component>?> getUserComponents(String? uid) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef = db.collection("user_components").doc(uid);

      var userComponentsDocSnapshot = await userComponentsDocRef.get();
      var data = userComponentsDocSnapshot.data() as Map<String, dynamic>;
      List<Component> components =
          (data["components"] as List).map((e) => Component.fromJson(e)).toList();

      return components;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserPreferences(String uid) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userPreferencesDocRef = db.collection("user_preferences").doc(uid);

      var userPreferencesDocSnapshot = await userPreferencesDocRef.get();
      var data = userPreferencesDocSnapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
