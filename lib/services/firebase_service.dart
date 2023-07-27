import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/models/bundle_model.dart';
import 'package:health_companion/util.dart';
import 'package:intl/intl.dart';

import '../models/appuser_model.dart';

class FirebaseService {
  static Future<AppUser?> createUserOnSignup({
    required User user,
    required String username,
    // required int age,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String email,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_components')
          .doc(user.uid)
          .set({"components": []});
      await FirebaseFirestore.instance
          .collection('user_daily_data')
          .doc(user.uid)
          .set({"data": []});
      await FirebaseFirestore.instance
          .collection('user_preferences')
          .doc(user.uid)
          .set({"kcalGoal": null, "darkMode": false});
      await FirebaseFirestore.instance
          .collection('user_stats')
          .doc(user.uid)
          .set({});
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "username": username,
        // "age": age,
        "dateOfBirth": dateOfBirth,
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
    } catch (e, stackTrace) {
      print("error creating user");
      print("$e, $stackTrace");
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
    } catch (e, stackTrace) {
      print("error creating user");
      print("$e, $stackTrace");
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
      print("Error saving user components: $e, $stackTrace");
      return false;
    }
    return false;
  }

  static Future<bool> deleteUserComponent(String? uid, List<Component> components) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef = db.collection("user_components").doc(uid);

      List<Map<String, dynamic>> json = components.map((item) => item.toJson()).toList();
      await userComponentsDocRef.update({"components": json});
      return true;
    } catch (e, stackTrace) {
      print("Error deleting user components: $e, $stackTrace");
      return false;
    }
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

  static Future<bool> reauthenticateWithCredential(AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
      return true;
    } catch (e, stackTrace) {
      if (e is FirebaseAuthException) return false;
      print("Error reauthenticating user: $e, $stackTrace");
      return false;
    }
  }

  static Future<void> deleteAccount(String uid) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userDocRef = db.collection("users").doc(uid);
      final DocumentReference userComponentsDocRef = db.collection("user_components").doc(uid);
      final DocumentReference userPreferencesDocRef = db.collection("user_preferences").doc(uid);
      final DocumentReference userStatsDocRef = db.collection("user_stats").doc(uid);
      final DocumentReference userDailyDataDocRef = db.collection("user_daily_data").doc(uid);

      await userDocRef.delete();
      await userComponentsDocRef.delete();
      await userPreferencesDocRef.delete();
      await userStatsDocRef.delete();
      await userDailyDataDocRef.delete();

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e, stackTrace) {
      print("Error deleting user: $e, $stackTrace");
    }
  }

  static Future<void> updateDailyData(List<Bundle> bundles) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentReference userDailyDataDocRef = db.collection("user_daily_data").doc(uid);
      List<Map<String, dynamic>> updatedDataJson = bundles.map((e) => e.toJson()).toList();

      await userDailyDataDocRef.update({"data": updatedDataJson});
    } catch (e, stackTrace) {
      print("Error adding daily data: $e, $stackTrace");
    }
  }
}
