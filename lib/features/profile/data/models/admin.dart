import 'package:cash_admin_app/features/profile/data/models/settings.dart';

class Admin {
  final String id;
  final String username;
  final String email;
  final Settings settings;

  Admin({required this.id, required this.username, required this.email, required this.settings});

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
      id: json["userId"],
      username: json["username"],
      email: json["email"],
      settings: json["settings"]);
}
