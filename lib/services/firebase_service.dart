import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion/models/achievement_model.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/models/bundle_model.dart';
import 'package:health_companion/models/user_achievement_model.dart';
import 'package:health_companion/models/user_preferences_model.dart';
import 'package:health_companion/screens/loading_screen.dart';

import '../models/appuser_model.dart';
import '../util.dart';

enum UserStats {
  addBundle,
  addComponent,
  addAchievement,
  deleteBundle,
  deleteComponent,
}

enum UserAchievementType {
  components10,
  components50,
  components100,
  components250,
  member7,
  member28,
  member165,
  member365,
}

class FirebaseService {
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static User get user => FirebaseAuth.instance.currentUser!;

  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  static DocumentReference get userDocRef => db.collection('users').doc(uid);

  static DocumentReference get userBundlesDocRef =>
      db.collection('user_daily_data').doc(uid);

  static DocumentReference get userStatsDocRef =>
      db.collection('user_stats').doc(uid);

  static DocumentReference get userComponentsDocRef =>
      db.collection('user_components').doc(uid);

  static DocumentReference get userPreferencesDocRef =>
      db.collection('user_preferences').doc(uid);

  static DocumentReference get userAchievementsDocRef =>
      db.collection('user_achievements').doc(uid);

  static Future<bool> createUserOnSignup({
    context,
    required User user,
    required String username,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String email,
  }) async {
    try {
      await userStatsDocRef.set({
        "joinDate": user.metadata.creationTime,
        "componentsAdded": 0,
        "componentsDeleted": 0,
        "bundlesAdded": 0,
        "bundlesDeleted": 0,
        "achievementsUnlocked": 0,
      });
      await userComponentsDocRef.set({"components": []});
      await userPreferencesDocRef.set({
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
      await userDocRef.set({
        "username": username,
        "dateOfBirth": dateOfBirth,
        "height": height,
        "weight": weight,
        "email": email,
        "joinDate": user.metadata.creationTime,
      });
      await userAchievementsDocRef.set({'achievements': []});
      await userBundlesDocRef.set({"data": []});
      print("creating data");
      return true;
    } catch (e, stackTrace) {
      print("error creating user");
      print("$e, $stackTrace");
      return false;
    }
  }

  // static Future<AppUser?> createUser(String uid) async {
  //   try {
  //     final FirebaseFirestore db = FirebaseFirestore.instance;
  //     final DocumentReference userDocument = db.collection("users").doc(uid);
  //
  //     var userDocumentSnapshot = await userDocument.get();
  //     var firestoreUser = userDocumentSnapshot.data() as Map<String, dynamic>;
  //     firestoreUser["uid"] = userDocumentSnapshot.id;
  //
  //     return AppUser.fromJson(firestoreUser);
  //   } catch (e, stackTrace) {
  //     print("error creating user");
  //     print("$e, $stackTrace");
  //     return null;
  //   }
  // }

  static Future<Map<String, dynamic>> getUserStats() async {
    final DocumentSnapshot userStatsDocSnapshot = await userStatsDocRef.get();
    Map<String, dynamic> json =
        userStatsDocSnapshot.data() as Map<String, dynamic>;
    return json;
  }

  static Future<Map<String, dynamic>> getUserAchievements() async {
    final DocumentSnapshot userAchievementsDocSnapshot =
        await userAchievementsDocRef.get();
    final Map<String, dynamic> data =
        userAchievementsDocSnapshot.data() as Map<String, dynamic>;

    return data;
  }

  static Future<void> addToStats(UserStats operation, int amount) async {
    final DocumentSnapshot userStatsDocSnapshot = await userStatsDocRef.get();
    Map<String, dynamic> json =
        userStatsDocSnapshot.data() as Map<String, dynamic>;

    switch (operation) {
      case UserStats.addBundle:
        await userStatsDocRef.update({
          "bundlesAdded": (json["bundlesAdded"] ?? 0) + amount,
        });
        break;
      case UserStats.addComponent:
        await userStatsDocRef.update({
          "componentsAdded": (json["componentsAdded"] ?? 0) + amount,
        });
        break;
      case UserStats.addAchievement:
        await userStatsDocRef.update({
          "achievementsUnlocked": (json["achievementsUnlocked"] ?? 0) + amount,
        });
        break;
      case UserStats.deleteBundle:
        await userStatsDocRef.update({
          "bundlesDeleted": (json["bundlesDeleted"] ?? 0) + amount,
        });
        break;
      case UserStats.deleteComponent:
        await userStatsDocRef.update({
          "componentsDeleted": (json["componentsDeleted"] ?? 0) + amount,
        });
        break;
    }
  }

  static Future<int> saveUserComponents(Component component) async {
    try {
      List<Component>? userComponents = await getUserComponents();
      if (userComponents != null) {
        List<Map<String, dynamic>> json =
            userComponents.map((item) => item.toJson()).toList();
        json.add(component.toJson());
        await userComponentsDocRef.update({"components": json});
        return json.length;
      }
    } catch (e, stackTrace) {
      print("Error saving user components: $e, $stackTrace");
      return 0;
    }
    return 0;
  }

  static Future<bool> updateUserComponents(Component component) async {
    try {
      List<Component>? userComponents = await getUserComponents();
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

  static Future<bool> deleteUserComponent(List<Component> components) async {
    try {
      List<Map<String, dynamic>> json =
          components.map((item) => item.toJson()).toList();
      await userComponentsDocRef.update({"components": json});
      return true;
    } catch (e, stackTrace) {
      print("Error deleting user components: $e, $stackTrace");
      return false;
    }
  }

  static Future<List<Component>?> getUserComponents() async {
    try {
      final DocumentSnapshot userComponentsDocSnapshot =
          await userComponentsDocRef.get();
      final data = userComponentsDocSnapshot.data() as Map<String, dynamic>;
      List<Component> components = (data["components"] as List)
          .map((e) => Component.fromJson(e))
          .toList();

      return components;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<UserPreferences> getUserPreferences() async {
    try {
      final DocumentSnapshot userPreferencesDocSnapshot =
          await userPreferencesDocRef.get();
      final data = userPreferencesDocSnapshot.data();
      if (data == null) {
        return UserPreferences();
      } else {
        return UserPreferences.fromJson(data as Map<String, dynamic>);
      }
    } catch (e, stackTrace) {
      print("Error getting preferences: $e, $stackTrace");
      return UserPreferences();
    }
  }

  static Future<void> addAchievement(context, UserAchievementType type) async {
    try {
      final Map<String, dynamic> json = await getUserAchievements();

      String name = '', category = '', title = '';
      bool isEligible = false;
      List<UserAchievement> userAchievements = (json['achievements'] as List)
          .map((e) => UserAchievement.fromJson(e))
          .toList();

      switch (type) {
        case UserAchievementType.components10:
          title = 'Add 10 components';
          name = 'achievement-10-components';
          category = 'component';
          break;
        case UserAchievementType.components50:
          title = 'Add 50 components';
          name = 'achievement-50-components';
          category = 'component';
          break;
        case UserAchievementType.components100:
          title = 'Add 100 components';
          name = 'achievement-100-components';
          category = 'component';
          break;
        case UserAchievementType.components250:
          title = 'Add 250 components';
          name = 'achievement-250-components';
          category = 'component';
          break;
        case UserAchievementType.member7:
          title = 'Member for 7 days';
          name = 'achievement-7-days';
          category = 'member';
          break;
        case UserAchievementType.member28:
          title = 'Member for 1 month';
          name = 'achievement-1-month';
          category = 'member';
          break;
        case UserAchievementType.member165:
          title = 'Member for 6 months';
          name = 'achievement-6-months';
          category = 'member';
          break;
        case UserAchievementType.member365:
          title = 'Member for 1 year';
          name = 'achievement-1-year';
          category = 'member';
          break;
      }

      isEligible = !Util.userHasAchievement(
        userAchievements,
        name,
      );

      if (isEligible) {
        userAchievements.add(UserAchievement.fromJson({
          'name': name,
          'category': category,
          'unlockDate': DateTime.now(),
        }));
        addToStats(UserStats.addAchievement, 1);
        Util.showAchievementNotification(context, title, 'assets/images/$name.png');
      }

      List<Map<String, dynamic>> data =
          userAchievements.map((e) => e.toJson()).toList();
      await userAchievementsDocRef.update({'achievements': data});
    } catch (e, stackTrace) {
      print("Error adding achievements: $e, $stackTrace");
    }
  }

  static Future<void> updateUserPreferences(Map<String, int> data) async {
    try {
      userPreferencesDocRef.update(data);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e, stackTrace) {
      if (e is FirebaseAuthException) return false;
      print("Error authenticating user: $e, $stackTrace");
      return false;
    }
  }

  static Future<void> deleteAccount(String uid) async {
    try {
      await userComponentsDocRef.delete();
      await userPreferencesDocRef.delete();
      await userStatsDocRef.delete();
      await userBundlesDocRef.delete();
      await userAchievementsDocRef.delete();
      await userDocRef.delete();
      await user.delete();
    } catch (e, stackTrace) {
      print("Error deleting user: $e, $stackTrace");
    }
  }

  static Future<void> updateDailyData(List<Bundle> bundles) async {
    try {
      List<Map<String, dynamic>> updatedDataJson =
          bundles.map((e) => e.toJson()).toList();

      await userBundlesDocRef.update({"data": updatedDataJson});
    } catch (e, stackTrace) {
      print("Error adding daily data: $e, $stackTrace");
    }
  }

  static Future<bool> changeUsername(String username) async {
    try {
      final DocumentSnapshot userDocSnapshot = await userDocRef.get();
      Map<String, dynamic> json =
          userDocSnapshot.data() as Map<String, dynamic>;
      json['username'] = username;
      print(json);
      await userDocRef.update(json);
      return true;
    } catch (e, stackTrace) {
      print("Error updating username: $e, $stackTrace");
      return false;
    }
  }

  static Future<bool> changeEmail(String email) async {
    try {
      await user.updateEmail(email);
      return true;
    } catch (e, stackTrace) {
      print("Error updating email: $e, $stackTrace");
      return false;
    }
  }

  static Future<bool> changePassword(String password) async {
    try {
      await user.updatePassword(password);
      return true;
    } catch (e, stackTrace) {
      print("Error updating email: $e, $stackTrace");
      return false;
    }
  }
}
