import 'package:cash_admin_app/features/orders/data/models/ordered_product_image.dart';

class OrderedProducts {
  final String productId;
  final String? productName;
  final OrderedProductImage? mainImage;
  final num? price;
  final num? commission;

  OrderedProducts({required this.productId, this.productName, this.mainImage, this.price, this.commission});

  factory OrderedProducts.fromJson(Map<String, dynamic> json) => OrderedProducts(
      productId: json["productId"],
      productName: json["productName"],
      mainImage: json["mainImage"]. toString() == "null" ? OrderedProductImage(path: "null") : OrderedProductImage.fromJson(json["mainImage"]),
      price: json["price"],
      commission: json["commission"]
  );
}