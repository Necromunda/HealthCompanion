class UserPreferences {
  int alcohol = 0,
      carbohydrate = 0,
      energyKcal = 0,
      energyKj = 0,
      fat = 0,
      fiber = 0,
      organicAcids = 0,
      protein = 0,
      salt = 0,
      saturatedFat = 0,
      sugar = 0,
      sugarAlcohol = 0;

  UserPreferences();

  UserPreferences.fromJson(Map<String, dynamic> json) {
    alcohol = json['alcohol'];
    carbohydrate = json['carbohydrate'];
    energyKcal = json['energyKcal'];
    energyKj = json['energyKj'];
    fat = json['fat'];
    fiber = json['fiber'];
    organicAcids = json['organicAcids'];
    protein = json['protein'];
    salt = json['salt'];
    saturatedFat = json['saturatedFat'];
    sugar = json['sugar'];
    sugarAlcohol = json['sugarAlcohol'];
  }
}
