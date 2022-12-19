class LocalOrder {
  final String orderId;
  final String productName;
  final String phone;
  final String fullName;
  final String orderedAt;
  final String status;

  LocalOrder(
      {required this.orderId,
      required this.productName,
      required this.phone,
      required this.fullName,
      required this.orderedAt,
      required this.status
      });

  factory LocalOrder.fromJson(Map<String, dynamic> json) => LocalOrder(
      orderId: json["orderId"],
      productName: json["productName"],
      phone: json["phone"],
      fullName: json["fullName"],
      orderedAt: json["orderedAt"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "orderId" : orderId,
    "productName" : productName,
    "phone" : phone,
    "fullName" : fullName,
    "orderedAt" : orderedAt,
    "status" : status
  };
}
