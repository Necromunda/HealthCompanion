class AppUser {
  String? uid, username, email;
  DateTime? joinDate;

  AppUser({
    this.uid,
    this.username,
    this.email,
    this.joinDate,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    email = json['email'];
    joinDate = json['joinDate'].toDate();
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "joinDate": joinDate
  };
}