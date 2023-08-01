import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/models/bundle_model.dart';

import '../models/appuser_model.dart';

enum UserStats {
  addBundle,
  addComponent,
  addAchievement,
  deleteBundle,
  deleteComponent,
}

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
          .set({
        "energyKcal": 0,
        "energyKj": 0,
        "salt": 0,
        "protein": 0,
        "carbohydrate": 0,
        "alcohol": 0,
        "organicAcids": 0,
        "sugarAlcohol": 0,
        "saturatedFat": 0,
        "fiber": 0,
        "sugar": 0,
        "fat": 0
      });
      await FirebaseFirestore.instance
          .collection('user_stats')
          .doc(user.uid)
          .set({
        "joinDate": user.metadata.creationTime,
        "componentsAdded": 0,
        "componentsDeleted": 0,
        "bundlesAdded": 0,
        "bundlesDeleted": 0,
        "achievementsUnlocked": 0,
      });
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

  static Future<Map<String, dynamic>> getUserStats() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userStatsDocRef =
        db.collection("user_stats").doc(user.uid);

    final DocumentSnapshot data = await userStatsDocRef.get();
    Map<String, dynamic> json = data.data() as Map<String, dynamic>;
    return json;
  }

  static Future<void> addToStats(UserStats operation, int amount) async {
    final User user = FirebaseAuth.instance.currentUser!;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userStatsDocRef =
        db.collection("user_stats").doc(user.uid);
    final DocumentSnapshot data = await userStatsDocRef.get();
    Map<String, dynamic> json = data.data() as Map<String, dynamic>;
    print(json);
    // return;
    switch (operation) {
      case UserStats.addBundle:
        await userStatsDocRef
            .update({"bundlesAdded": (json["bundlesAdded"] ?? 0) + amount});
        break;
      case UserStats.addComponent:
        await userStatsDocRef.update(
            {"componentsAdded": (json["componentsAdded"] ?? 0) + amount});
        break;
      case UserStats.addAchievement:
        await userStatsDocRef.update({
          "achievementsUnlocked": (json["achievementsUnlocked"] ?? 0) + amount
        });
        break;
      case UserStats.deleteBundle:
        await userStatsDocRef
            .update({"bundlesDeleted": (json["bundlesDeleted"] ?? 0) + amount});
        break;
      case UserStats.deleteComponent:
        await userStatsDocRef.update(
            {"componentsDeleted": (json["componentsDeleted"] ?? 0) + amount});
        break;
    }
  }

  static Future<bool> saveUserComponents(
      String? uid, Component component) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(uid);

      List<Component>? userComponents = await getUserComponents(uid);
      if (userComponents != null) {
        List<Map<String, dynamic>> json =
            userComponents.map((item) => item.toJson()).toList();
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

  static Future<bool> updateUserComponents(Component component) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(user.uid);

      List<Component>? userComponents = await getUserComponents(user.uid);
      if (userComponents != null) {
        int index =
            userComponents.indexWhere((element) => element == component);
        List<Map<String, dynamic>> json =
            userComponents.map((item) => item.toJson()).toList();
        json[index] = component.toJson();
        await userComponentsDocRef.update({"components": json});
        return true;
      }
    } catch (e, stackTrace) {
      print("Error saving user components: $e, $stackTrace");
      return false;
    }
    return false;
  }

  static Future<bool> deleteUserComponent(
      String? uid, List<Component> components) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(uid);

      List<Map<String, dynamic>> json =
          components.map((item) => item.toJson()).toList();
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
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(uid);

      var userComponentsDocSnapshot = await userComponentsDocRef.get();
      var data = userComponentsDocSnapshot.data() as Map<String, dynamic>;
      List<Component> components = (data["components"] as List)
          .map((e) => Component.fromJson(e))
          .toList();

      return components;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserPreferences(String uid) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userPreferencesDocRef =
          db.collection("user_preferences").doc(uid);

      var userPreferencesDocSnapshot = await userPreferencesDocRef.get();
      var data = userPreferencesDocSnapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> updateUserPreferences(Map<String, int> data) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userPreferencesDocRef =
          db.collection("user_preferences").doc(user.uid);

      userPreferencesDocRef.update(data);
      // userPreferencesDocRef.update({
      //   "energyKcal": 0,
      //   "energyKj": 0,
      //   "salt": 0,
      //   "protein": 0,
      //   "carbohydrate": 0,
      //   "alcohol": 0,
      //   "organicAcids": 0,
      //   "sugarAlcohol": 0,
      //   "saturatedFat": 0,
      //   "fiber": 0,
      //   "sugar": 0,
      //   "fat": 0
      // });
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> reauthenticateWithCredential(
      AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
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
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(uid);
      final DocumentReference userPreferencesDocRef =
          db.collection("user_preferences").doc(uid);
      final DocumentReference userStatsDocRef =
          db.collection("user_stats").doc(uid);
      final DocumentReference userDailyDataDocRef =
          db.collection("user_daily_data").doc(uid);

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
      final DocumentReference userDailyDataDocRef =
          db.collection("user_daily_data").doc(uid);
      List<Map<String, dynamic>> updatedDataJson =
          bundles.map((e) => e.toJson()).toList();

      await userDailyDataDocRef.update({"data": updatedDataJson});
    } catch (e, stackTrace) {
      print("Error adding daily data: $e, $stackTrace");
    }
  }
}
