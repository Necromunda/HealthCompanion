import 'package:health_companion/models/component_model.dart';

class FineliModel {
  int? id;
  Type? type;
  Name? name;
  List<PreparationMethod>? preparationMethod;
  int? ediblePortion;
  List<String>? specialDiets, themes;
  List<Units>? units;
  Type? ingredientClass, functionClass;
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

  FineliModel(
      {this.id,
      this.type,
      this.name,
      this.preparationMethod,
      this.ediblePortion,
      this.specialDiets,
      this.themes,
      this.units,
      this.ingredientClass,
      this.functionClass,
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
      this.fat});

  FineliModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    if (json['preparationMethod'] != null) {
      preparationMethod = <PreparationMethod>[];
      json['preparationMethod'].forEach((v) {
        preparationMethod!.add(PreparationMethod.fromJson(v));
      });
    }
    // if (json['specialDiets'] != null) {
    //   specialDiets = <String>[];
    //   json['preparationMethod'].forEach((v) {
    //     specialDiets!.add(v.toString());
    //   });
    // }
    // if (json['themes'] != null) {
    //   themes = <String>[];
    //   json['preparationMethod'].forEach((v) {
    //     themes!.add(v.toString());
    //   });
    // }
    ediblePortion = json['ediblePortion'];
    specialDiets = json['specialDiets'].cast<String>();
    themes = json['themes'].cast<String>();
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(Units.fromJson(v));
      });
    }
    ingredientClass = json['ingredientClass'] != null
        ? Type.fromJson(json['ingredientClass'])
        : null;
    functionClass = json['functionClass'] != null
        ? Type.fromJson(json['functionClass'])
        : null;
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
    data['id'] = id;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (preparationMethod != null) {
      data['preparationMethod'] =
          preparationMethod!.map((v) => v.toJson()).toList();
    }
    data['ediblePortion'] = ediblePortion;
    data['specialDiets'] = specialDiets;
    data['themes'] = themes;
    if (units != null) {
      data['units'] = units!.map((v) => v.toJson()).toList();
    }
    if (ingredientClass != null) {
      data['ingredientClass'] = ingredientClass!.toJson();
    }
    if (functionClass != null) {
      data['functionClass'] = functionClass!.toJson();
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

  Component toComponent() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name?.fi;
    data['description'] = type?.description?.fi;
    data['subComponents'] = null;
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
    return Component.fromJson(data);
  }
}

class PreparationMethod {
  String? code;
  Description? description;
  Description? abbreviation;

  PreparationMethod({this.code, this.description, this.abbreviation});

  PreparationMethod.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    abbreviation = json['abbreviation'] != null
        ? Description.fromJson(json['abbreviation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (abbreviation != null) {
      data['abbreviation'] = abbreviation!.toJson();
    }
    return data;
  }
}

class Type {
  String? code;
  Description? description;
  Description? abbreviation;

  Type({this.code, this.description, this.abbreviation});

  Type.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    abbreviation = json['abbreviation'] != null
        ? Description.fromJson(json['abbreviation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (abbreviation != null) {
      data['abbreviation'] = abbreviation!.toJson();
    }
    return data;
  }
}

class Description {
  String? fi;
  String? sv;
  String? en;

  Description({this.fi, this.sv, this.en});

  Description.fromJson(Map<String, dynamic> json) {
    fi = json['fi'];
    sv = json['sv'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fi'] = fi;
    data['sv'] = sv;
    data['en'] = en;
    return data;
  }
}

class Name {
  String? fi;
  String? sv;
  String? en;
  String? la;

  Name({this.fi, this.sv, this.en, this.la});

  Name.fromJson(Map<String, dynamic> json) {
    fi = json['fi'];
    sv = json['sv'];
    en = json['en'];
    la = json['la'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fi'] = fi;
    data['sv'] = sv;
    data['en'] = en;
    data['la'] = la;
    return data;
  }
}

class Units {
  String? code;
  Description? description, abbreviation;
  double? mass;

  Units({this.code, this.description, this.abbreviation, this.mass});

  Units.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    abbreviation = json['abbreviation'] != null
        ? Description.fromJson(json['abbreviation'])
        : null;
    mass = json['mass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (abbreviation != null) {
      data['abbreviation'] = abbreviation!.toJson();
    }
    data['mass'] = mass;
    return data;
  }
}
