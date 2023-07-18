import 'package:equatable/equatable.dart';

class Component extends Equatable {
  String? name, description;
  List<Component>? subComponents;
  double? salt,
      energy,
      energyKcal,
      protein,
      carbohydrate,
      alcohol,
      organicAcids,
      sugarAlcohol,
      saturatedFat,
      fiber,
      sugar,
      fat;

  Component({
    this.name,
    this.description,
    this.subComponents,
    this.salt,
    this.energy,
    this.energyKcal,
    this.protein,
    this.carbohydrate,
    this.alcohol,
    this.organicAcids,
    this.sugarAlcohol,
    this.saturatedFat,
    this.fiber,
    this.sugar,
    this.fat,
  });

  Component.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    // subComponents = json['subComponents'];
    subComponents = <Component>[];
    if (json['subComponents'] != null) {
      json['subComponents'].forEach((v) {
        subComponents?.add(Component.fromJson(v));
      });
    }
    salt = (json['salt'] ?? 0).toDouble();
    energy = (json['energy'] ?? 0).toDouble();
    energyKcal = (json['energyKcal'] ?? 0).toDouble();
    protein = (json['protein'] ?? 0).toDouble();
    carbohydrate = (json['carbohydrate'] ?? 0).toDouble();
    alcohol = (json['alcohol'] ?? 0).toDouble();
    organicAcids = (json['organicAcids'] ?? 0).toDouble();
    sugarAlcohol = (json['sugarAlcohol'] ?? 0).toDouble();
    saturatedFat = (json['saturatedFat'] ?? 0).toDouble();
    fiber = (json['fiber'] ?? 0).toDouble();
    sugar = (json['sugar'] ?? 0).toDouble();
    fat = (json['fat'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    if (subComponents != null) {
      data['subComponents'] = subComponents!.map((v) => v.toJson()).toList();
    }
    data['salt'] = salt;
    data['energy'] = energy;
    data['energyKcal'] = energyKcal;
    data['protein'] = protein;
    data['carbohydrate'] = carbohydrate;
    data['alcohol'] = alcohol;
    data['organicAcids'] = organicAcids;
    data['sugarAlcohol'] = sugarAlcohol;
    data['saturatedFat'] = saturatedFat;
    data['fiber'] = fiber;
    data['sugar'] = sugar;
    data['fat'] = fat;
    return data;
  }

  @override
  List<Object?> get props => [name, description, energyKcal];
}
