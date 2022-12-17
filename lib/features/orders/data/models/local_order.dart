class LocalOrder {
  final String orderId;
  final String productName;
  final String phone;
  final String fullName;
  final String orderedAt;

  LocalOrder(
      {required this.orderId,
      required this.productName,
      required this.phone,
      required this.fullName,
      required this.orderedAt});

  factory LocalOrder.fromJson(Map<String, dynamic> json) => LocalOrder(
      orderId: json["orderId"],
      productName: json["productName"],
      phone: json["phone"],
      fullName: json["fullName"],
      orderedAt: json["orderedAt"]);

  Map<String, dynamic> toJson() => {
    "orderId" : orderId,
    "productName" : productName,
    "phone" : phone,
    "fullName" : fullName,
    "orderedAt" : orderedAt,
  };
}
