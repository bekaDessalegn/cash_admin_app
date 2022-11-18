class OrderedAffiliate{
  final String userId;
  final String? fullName;

  OrderedAffiliate({required this.userId, this.fullName});

  factory OrderedAffiliate.fromJson(Map<String, dynamic> json) => OrderedAffiliate(
      userId: json["userId"],
      fullName: json["fullName"]
  );
}