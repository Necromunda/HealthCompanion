class AppUser {
  String? uid, username, email;
  int? age, height;
  double? weight;
  DateTime? joinDate;

  AppUser({
    this.uid,
    this.username,
    this.age,
    this.height,
    this.weight,
    this.email,
    this.joinDate,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    username = json["username"];
    age = json["age"];
    height = json["height"];
    weight = json["weight"];
    email = json["email"];
    joinDate = json["joinDate"].toDate();
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "age": username,
        "height": username,
        "weight": username,
        "email": email,
        "joinDate": joinDate
      };
}
