import 'dart:typed_data';

class LocalProducts {
  final String productId;
  final String productName;
  final num price;
  final bool published;
  final bool featured;
  final bool topSeller;
  final num viewCount;

  LocalProducts(
      { required this.productId,
        required this.productName,
        required this.price,
        required this.published,
        required this.featured,
        required this.topSeller,
        required this.viewCount,
        });

  factory LocalProducts.fromJson(Map<String, dynamic> json) => LocalProducts(
      productId: json["productId"],
      productName: json["productName"],
      price: json["price"],
      published: json["published"] == 1 ? true : false,
      featured: json["featured"] == 1 ? true : false,
      topSeller: json["topSeller"] == 1 ? true : false,
      viewCount: json["viewCount"]);

  Map<String, dynamic> toJson() => {
    "productId" : productId,
    "productName" : productName,
    "price" : price,
    "published" : published ? 1 : 0,
    "featured" : featured ? 1 : 0,
    "topSeller" : topSeller ? 1 : 0,
    "viewCount" : viewCount,
  };
}
