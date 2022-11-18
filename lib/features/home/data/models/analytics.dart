class Analytics {
  final num totalProducts;
  final num totalOrders;
  final num acceptedOrders;
  final num totalAffiliates;
  final num totalEarned;
  final num totalUnpaid;

  Analytics(
      {required this.totalProducts,
      required this.totalOrders,
      required this.acceptedOrders,
      required this.totalAffiliates,
      required this.totalEarned,
      required this.totalUnpaid});

  factory Analytics.fromJson(Map<String, dynamic> json) => Analytics(
      totalProducts: json["totalProducts"],
      totalOrders: json["totalOrders"],
      acceptedOrders: json["acceptedOrders"],
      totalAffiliates: json["totalAffiliates"],
      totalEarned: json["totalEarned"],
      totalUnpaid: json["totalUnpaid"]);
}
