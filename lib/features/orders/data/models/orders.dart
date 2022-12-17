import 'package:cash_admin_app/features/orders/data/models/ordered_affiliate.dart';
import 'package:cash_admin_app/features/orders/data/models/ordered_by.dart';
import 'package:cash_admin_app/features/orders/data/models/ordered_products.dart';

class Orders {
  final String? orderId;
  final OrderedProducts product;
  final OrderedBy orderedBy;
  final OrderedAffiliate? affiliate;
  final String? orderedAt;
  final String? status;

  Orders(
      {this.orderId,
      required this.product,
      required this.orderedBy,
      this.affiliate,
      this.orderedAt,
      this.status});

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
      orderId: json["orderId"],
      product: OrderedProducts.fromJson(json["product"]),
      orderedBy: OrderedBy.fromJson(json["orderedBy"]),
      affiliate: json["affiliate"].toString() == "null" ? OrderedAffiliate(userId: "123", fullName: "None") : OrderedAffiliate.fromJson(json["affiliate"]),
      orderedAt: json["orderedAt"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
    "orderId" : orderId,
    "productName" : product.productName,
    "phone" : orderedBy.phone,
    "fullName" : affiliate!.fullName,
    "orderedAt" : orderedAt,
  };
}
