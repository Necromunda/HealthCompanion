import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAchievement {
  String? name;
  String? category;
  DateTime? unlockDate;

  UserAchievement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    unlockDate = (json['unlockDate'] is DateTime)
        ? unlockDate = json['unlockDate']
        : unlockDate = json['unlockDate'].toDate();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'unlockDate': unlockDate,
      };
}
