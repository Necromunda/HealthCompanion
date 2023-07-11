class Component {
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
    name = json['name'];
    description = json['description'];
    if (json['subComponents'] != null) {
      subComponents = <Component>[];
      json['subComponents'].forEach((v) {
        subComponents!.add(Component.fromJson(v));
      });
    }
    salt = json['salt'].toDouble();
    energy = json['energy'].toDouble();
    energyKcal = json['energyKcal'].toDouble();
    protein = json['protein'].toDouble();
    carbohydrate = json['carbohydrate'].toDouble();
    alcohol = json['alcohol'].toDouble();
    organicAcids = json['organicAcids'].toDouble();
    sugarAlcohol = json['sugarAlcohol'].toDouble();
    saturatedFat = json['saturatedFat'].toDouble();
    fiber = json['fiber'].toDouble();
    sugar = json['sugar'].toDouble();
    fat = json['fat'].toDouble();
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
