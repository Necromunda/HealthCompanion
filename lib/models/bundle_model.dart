import 'package:cloud_firestore/cloud_firestore.dart';

import 'component_model.dart';

class Bundle {
  int? creationDate, lastEdited;
  List<Component>? components;
  // double? salt,
  //     energy,
  //     energyKcal,
  //     protein,
  //     carbohydrate,
  //     alcohol,
  //     organicAcids,
  //     sugarAlcohol,
  //     saturatedFat,
  //     fiber,
  //     sugar,
  //     fat;

  // DailyData({
  //   this.components,
  //   this.salt,
  //   this.energy,
  //   this.energyKcal,
  //   this.protein,
  //   this.carbohydrate,
  //   this.alcohol,
  //   this.organicAcids,
  //   this.sugarAlcohol,
  //   this.saturatedFat,
  //   this.fiber,
  //   this.sugar,
  //   this.fat,
  // });

  Bundle.fromJson(Map<String, dynamic> json) {
    creationDate = json["creationDate"];
    lastEdited = json["lastEdited"];
    components = (json["components"] as List).map((e) => Component.fromJson(e)).toList();
    // components = json["components"];
    // sumComponents();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["creationDate"] = creationDate;
    data["lastEdited"] = lastEdited;
    if (components != null) {
      data['components'] = components!.map((v) => v.toJson()).toList();
    }
    // _sumComponents();
    data['energy'] = totalEnergy ?? 0.0;
    data['energyKcal'] = totalEnergyKcal ?? 0.0;
    data['salt'] = totalSalt ?? 0.0;
    data['protein'] = totalProtein ?? 0.0;
    data['carbohydrate'] = totalCarbohydrate ?? 0.0;
    data['alcohol'] = totalAlcohol ?? 0.0;
    data['organicAcids'] = totalOrganicAcids ?? 0.0;
    data['sugarAlcohol'] = totalSugarAlcohol ?? 0.0;
    data['saturatedFat'] = totalSaturatedFat ?? 0.0;
    data['fiber'] = totalFiber ?? 0.0;
    data['sugar'] = totalSugar ?? 0.0;
    data['fat'] = totalFat ?? 0.0;
    return data;
  }

  // void _sumComponents() {
  //   energy = totalEnergy ?? 0.0;
  //   energyKcal = totalEnergyKcal ?? 0.0;
  //   salt = totalSalt ?? 0.0;
  //   protein = totalProtein ?? 0.0;
  //   carbohydrate = totalCarbohydrate ?? 0.0;
  //   alcohol = totalAlcohol ?? 0.0;
  //   organicAcids = totalOrganicAcids ?? 0.0;
  //   sugarAlcohol = totalSugarAlcohol ?? 0.0;
  //   saturatedFat = totalSaturatedFat ?? 0.0;
  //   fiber = totalFiber ?? 0.0;
  //   sugar = totalSugar ?? 0.0;
  //   fat = totalFat ?? 0.0;
  // }

  double? get totalEnergy =>
      components?.map((e) => (e.energy ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalEnergyKcal =>
      components?.map((e) => (e.energyKcal ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSalt =>
      components?.map((e) => (e.salt ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalProtein =>
      components?.map((e) => (e.protein ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalCarbohydrate =>
      components?.map((e) => (e.carbohydrate ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalAlcohol =>
      components?.map((e) => (e.alcohol ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalOrganicAcids =>
      components?.map((e) => (e.organicAcids ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSugarAlcohol =>
      components?.map((e) => (e.sugarAlcohol ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSaturatedFat =>
      components?.map((e) => (e.saturatedFat ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalFiber =>
      components?.map((e) => (e.fiber ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSugar =>
      components?.map((e) => (e.sugar ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalFat =>
      components?.map((e) => (e.fat ?? 0.0)).fold(0.0, (a, b) => (a ?? 0.0) + b);
}
