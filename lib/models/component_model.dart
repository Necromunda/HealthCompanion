class Component {
  String? name;
  String? description;
  List<Component>? subComponents;
  double? salt;
  double? energy;
  double? energyKcal;
  double? protein;
  double? carbohydrate;
  int? alcohol;
  double? organicAcids;
  int? sugarAlcohol;
  double? saturatedFat;
  double? fiber;
  double? sugar;
  double? fat;

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
    name = json['name'];
    description = json['description'];
    if (json['subComponents'] != null) {
      subComponents = <Component>[];
      json['subComponents'].forEach((v) {
        subComponents!.add(Component.fromJson(v));
      });
    }
    salt = json['salt'];
    energy = json['energy'];
    energyKcal = json['energyKcal'];
    protein = json['protein'];
    carbohydrate = json['carbohydrate'];
    alcohol = json['alcohol'];
    organicAcids = json['organicAcids'];
    sugarAlcohol = json['sugarAlcohol'];
    saturatedFat = json['saturatedFat'];
    fiber = json['fiber'];
    sugar = json['sugar'];
    fat = json['fat'];
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
}
