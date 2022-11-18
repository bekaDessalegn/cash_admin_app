class Settings {
  final num commisionRate;

  Settings({required this.commisionRate});

  factory Settings.fromJson(Map<String, dynamic> json) =>
      Settings(commisionRate: json["commissionRate"]);
}
