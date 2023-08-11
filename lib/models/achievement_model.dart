class Achievement {
  String name = "", description = "", url = "";
  int requirement = 0;

  Achievement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    url = json['url'];
    requirement = json['requirement'];
  }
}