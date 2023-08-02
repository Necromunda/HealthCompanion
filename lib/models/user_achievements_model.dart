import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAchievements {
  List<UserAchievement>? componentAchievements, memberAchievements;

  UserAchievements.fromJson(Map<String, dynamic> json) {
    componentAchievements = (json['achievements']['components'] as List)
        .map((e) => UserAchievement.fromJson(e))
        .toList();
    memberAchievements = (json['achievements']['member'] as List)
        .map((e) => UserAchievement.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'components': componentAchievements?.map((e) => e.toJson()).toList(),
        'member': memberAchievements?.map((e) => e.toJson()).toList(),
      };
}

class UserAchievement {
  String? name;
  DateTime? unlockDate;

  UserAchievement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // unlockDate = json['unlockDate'].toDate();
    unlockDate = (json['unlockDate'] is DateTime)
        ? unlockDate = json['unlockDate']
        : unlockDate = json['unlockDate'].toDate();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'unlockDate': unlockDate,
      };
}
