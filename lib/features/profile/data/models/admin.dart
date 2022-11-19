class Admin {
  final String? id;
  final String? username;
  final String? email;
  final num? commissionRate;

  Admin({required this.id, required this.username, required this.email, required this.commissionRate});

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
      id: json["userId"] ?? json["id"],
      username: json["username"],
      email: json["email"] ?? "Null",
      commissionRate: json["commissionRate"]);

  Map<String, dynamic> toJson() => {
    "id" : id,
    "username" : username,
    "email" : email,
    "commissionRate" : commissionRate,
  };
}
