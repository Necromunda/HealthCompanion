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
    uid = null;
    username = null;
    email = null;
    joinDate = null;
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "joinDate": joinDate
  };
}