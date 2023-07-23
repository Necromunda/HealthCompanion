class AppUser {
  String? uid, username, email;
  int? age;
  double? height, weight;
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
    age = (json["age"] as num).toInt();
    height = (json["height"] as num).toDouble();
    weight = (json["weight"] as num).toDouble();
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
