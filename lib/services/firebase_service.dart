import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_companion/models/achievement_model.dart';
import 'package:health_companion/models/component_model.dart';
import 'package:health_companion/models/bundle_model.dart';
import 'package:health_companion/models/user_achievements_model.dart';

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
      await FirebaseFirestore.instance
          .collection('user_achievements')
          .doc(user.uid)
          .set({
        'components': {
          'data': [],
        },
        'member': {
          'data': [],
        },
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

  static Future<void> setAchievments() async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userAchievements =
          db.collection('user_achievements').doc(user.uid);

      // await userAchievements.set({
      //   'achievements': {
      //     'components': [],
      //     'member': [],
      //   },
      // });
      await userAchievements.update({
        'achievements': {
          'components': [
            {
              'name': 'achievement-10-components',
              'unlockDate': DateTime.now(),
            },
          ],
          'member': [],
        },
      });
    } catch (e, stackTrace) {
      // print("error creating user");
      print("$e, $stackTrace");
    }
  }

  //
  // static Future<void> setUserInfo() async {
  //   try {
  //     final User user = FirebaseAuth.instance.currentUser!;
  //     final FirebaseFirestore db = FirebaseFirestore.instance;
  //     final DocumentReference userAchievements =
  //     db.collection('users').doc(user.uid);
  //
  //     await userAchievements.set({
  //       "username": 'jrantapaa',
  //       // "age": age,
  //       "dateOfBirth": DateTime(2000, 3, 6),
  //       "height": 180,
  //       "weight": 104.9,
  //       "email": 'johannes.rantapaa@gmail.com',
  //       "joinDate": user.metadata.creationTime,
  //     });
  //   } catch (e, stackTrace) {
  //     // print("error creating user");
  //     print("$e, $stackTrace");
  //   }
  // }

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

  static Future<Map<String, dynamic>> getUserAchievements() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userAchievementsDocRef =
        db.collection("user_achievements").doc(user.uid);

    var userAchievementsDocSnapshot = await userAchievementsDocRef.get();
    var data = userAchievementsDocSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  static Future<void> addToStats(UserStats operation, int amount) async {
    final User user = FirebaseAuth.instance.currentUser!;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DocumentReference userStatsDocRef =
        db.collection("user_stats").doc(user.uid);
    final DocumentSnapshot data = await userStatsDocRef.get();
    Map<String, dynamic> json = data.data() as Map<String, dynamic>;

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

  // static Future<bool> saveUserComponents(Component component) async {
  static Future<int> saveUserComponents(Component component) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userComponentsDocRef =
          db.collection("user_components").doc(user.uid);

      List<Component>? userComponents = await getUserComponents(user.uid);
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

  static Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userPreferencesDocRef =
          db.collection("user_preferences").doc(user.uid);

      var userPreferencesDocSnapshot = await userPreferencesDocRef.get();
      var data = userPreferencesDocSnapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Achievement>?> getAchievements(String doc) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference achievementsDocRef =
          db.collection('achievements').doc(doc);

      var achievementsDocSnapshot = await achievementsDocRef.get();
      var data = achievementsDocSnapshot.data() as Map<String, dynamic>;
      List<Achievement> achievements =
          (data['data'] as List).map((e) => Achievement.fromJson(e)).toList();

      return achievements;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> addAchievement(context, UserAchievementType type) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userAchievementsDocRef =
          db.collection('user_achievements').doc(user.uid);

      final Map<String, dynamic> json = await getUserAchievements();
      final UserAchievements userAchievements = UserAchievements.fromJson(json);

      switch (type) {
        case UserAchievementType.components10:
          if (!Util.userHasAchievement(
            userAchievements.componentAchievements!,
            'achievement-10-components',
          )) {
            userAchievements.componentAchievements
                ?.add(UserAchievement.fromJson({
              'name': 'achievement-10-components',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, 10 components added!");
          }
          break;
        case UserAchievementType.components50:
          if (!Util.userHasAchievement(
            userAchievements.componentAchievements!,
            'achievement-50-components',
          )) {
            userAchievements.componentAchievements
                ?.add(UserAchievement.fromJson({
              'name': 'achievement-50-components',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, 50 components added!");
          }
          break;
        case UserAchievementType.components100:
          if (!Util.userHasAchievement(
            userAchievements.componentAchievements!,
            'achievement-100-components',
          )) {
            userAchievements.componentAchievements
                ?.add(UserAchievement.fromJson({
              'name': 'achievement-100-components',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, 100 components added!");
          }
          break;
        case UserAchievementType.components250:
          if (!Util.userHasAchievement(
            userAchievements.componentAchievements!,
            'achievement-250-components',
          )) {
            userAchievements.componentAchievements
                ?.add(UserAchievement.fromJson({
              'name': 'achievement-250-components',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, 250 components added!");
          }
          break;
        case UserAchievementType.member7:
          if (!Util.userHasAchievement(
            userAchievements.memberAchievements!,
            'achievement-7-days',
          )) {
            userAchievements.memberAchievements?.add(UserAchievement.fromJson({
              'name': 'achievement-7-days',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, member for 7 days!");
          }
          break;
        case UserAchievementType.member28:
          if (!Util.userHasAchievement(
            userAchievements.memberAchievements!,
            'achievement-1-month',
          )) {
            userAchievements.memberAchievements?.add(UserAchievement.fromJson({
              'name': 'achievement-1-month',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, member for 1 month!");
          }
          break;
        case UserAchievementType.member165:
          if (!Util.userHasAchievement(
            userAchievements.memberAchievements!,
            'achievement-6-months',
          )) {
            userAchievements.memberAchievements?.add(UserAchievement.fromJson({
              'name': 'achievement-6-months',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, member for 6 months!");
          }
          break;
        case UserAchievementType.member365:
          if (!Util.userHasAchievement(
            userAchievements.memberAchievements!,
            'achievement-1-year',
          )) {
            userAchievements.memberAchievements?.add(UserAchievement.fromJson({
              'name': 'achievement-1-year',
              'unlockDate': DateTime.now(),
            }));
            addToStats(UserStats.addAchievement, 1);
            Util.showSnackBar(
                context, "Achievement unlocked, member for 1 year!");
          }
          break;
      }

      Map<String, dynamic> data = userAchievements.toJson();
      await userAchievementsDocRef.update({'achievements': data});
    } catch (e, stackTrace) {
      print("Error adding achievements: $e, $stackTrace");
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
      final DocumentReference userAchievementsDocRef =
          db.collection("user_achievements").doc(uid);

      await userComponentsDocRef.delete();
      await userPreferencesDocRef.delete();
      await userStatsDocRef.delete();
      await userDailyDataDocRef.delete();
      await userAchievementsDocRef.delete();
      await userDocRef.delete();

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

  static Future<bool> changeUsername(String username) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final DocumentReference userDocRef = db.collection("users").doc(user.uid);
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
      final User user = FirebaseAuth.instance.currentUser!;
      await user.updateEmail(email);
      return true;
    } catch (e, stackTrace) {
      print("Error updating email: $e, $stackTrace");
      return false;
    }
  }

  static Future<bool> changePassword(String password) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      await user.updatePassword(password);
      return true;
    } catch (e, stackTrace) {
      print("Error updating email: $e, $stackTrace");
      return false;
    }
  }
}
