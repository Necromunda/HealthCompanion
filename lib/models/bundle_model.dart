import 'package:health_companion/models/component_model.dart';

class Bundle {
  DateTime? creationDate, lastEdited;
  List<Component>? components;

  Bundle.fromJson(Map<String, dynamic> json) {
    creationDate = (json["creationDate"] is DateTime)
        ? json["creationDate"]
        : json["creationDate"].toDate();
    lastEdited = (json["lastEdited"] is DateTime)
        ? json["lastEdited"]
        : json["lastEdited"].toDate();
    components =
        (json["components"] as List).map((e) => Component.fromJson(e)).toList();
    // if (json["creationDate"] is int) {
    //   creationDate = DateTime.fromMillisecondsSinceEpoch(json["creationDate"]);
    // } else {
    //   creationDate = (json["creationDate"] is DateTime)
    //       ? json["creationDate"]
    //       : json["creationDate"].toDate();
    // }
    // if (json["lastEdited"] is int) {
    //   lastEdited = DateTime.fromMillisecondsSinceEpoch(json["lastEdited"]);
    // } else {
    //   lastEdited = (json["lastEdited"] is DateTime)
    //       ? json["lastEdited"]
    //       : json["lastEdited"].toDate();
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["creationDate"] = creationDate;
    data["lastEdited"] = lastEdited;
    if (components != null) {
      data['components'] = components!.map((v) => v.toJson()).toList();
    }
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

  double? get totalEnergy => components
      ?.map((e) => (e.energy ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalEnergyKcal => components
      ?.map((e) => (e.energyKcal ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSalt => components
      ?.map((e) => (e.salt ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalProtein => components
      ?.map((e) => (e.protein ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalCarbohydrate => components
      ?.map((e) => (e.carbohydrate ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalAlcohol => components
      ?.map((e) => (e.alcohol ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalOrganicAcids => components
      ?.map((e) => (e.organicAcids ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSugarAlcohol => components
      ?.map((e) => (e.sugarAlcohol ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSaturatedFat => components
      ?.map((e) => (e.saturatedFat ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalFiber => components
      ?.map((e) => (e.fiber ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalSugar => components
      ?.map((e) => (e.sugar ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);

  double? get totalFat => components
      ?.map((e) => (e.fat ?? 0.0))
      .fold(0.0, (a, b) => (a ?? 0.0) + b);
}
