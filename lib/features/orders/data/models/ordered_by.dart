class OrderedBy {
  final String fullName;
  final String phone;
  final String? companyName;

  OrderedBy({required this.fullName, required this.phone, this.companyName});

  factory OrderedBy.fromJson(Map<String, dynamic> json) =>
      OrderedBy(
          fullName: json["fullName"],
          phone: json["phone"],
          companyName: json["companyName"]
      );
}
