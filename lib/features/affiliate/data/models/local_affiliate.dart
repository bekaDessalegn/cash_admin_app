class LocalAffiliate {
  final String userId;
  final String fullName;
  final String phone;
  final num totalMade;

  LocalAffiliate(
      {required this.userId,
      required this.fullName,
      required this.phone,
      required this.totalMade});

  factory LocalAffiliate.fromJson(Map<String, dynamic> json) => LocalAffiliate(
      userId: json["userId"],
      fullName: json["fullName"],
      phone: json["phone"],
      totalMade: json["totalMade"]);

  Map<String, dynamic> toJson() => {
    "userId" : userId,
    "fullName" : fullName,
    "phone" : phone,
    "totalMade" : totalMade
  };
}
