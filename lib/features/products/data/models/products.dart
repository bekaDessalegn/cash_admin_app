import 'package:cash_admin_app/features/products/data/models/product_image.dart';

class Products {
  final String? productId;
  final String productName;
  final String? description;
  final ProductImage? mainImage;
  final List<dynamic>? moreImages;
  final num price;
  final List? categories;
  final num commission;
  final bool? published;
  final bool? featured;
  final bool? topSeller;
  final num? viewCount;
  final String? createdAt;
  final String? updatedAt;

  Products(
      {this.productId,
      required this.productName,
      this.description,
      this.mainImage,
      this.moreImages,
      required this.price,
      this.categories,
      required this.commission,
      this.published,
      this.featured,
      this.topSeller,
      this.viewCount,
      this.createdAt,
      this.updatedAt});

  factory Products.fromJson(Map<String, dynamic> json) => Products(
      productId: json["productId"],
      productName: json["productName"],
      description: json["description"],
      mainImage: json["mainImage"].toString() == "null" ? ProductImage.fromJson(
          {"path" : "null"}) : ProductImage.fromJson(json["mainImage"]),
      moreImages: json["moreImages"],
      price: json["price"],
      categories: json["categories"],
      commission: json["commission"],
      published: json["published"],
      featured: json["featured"],
      topSeller: json["topSeller"],
      viewCount: json["viewCount"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"]);

  Map<String, dynamic> toJson() => {
    "productId" : productId,
    "productName" : productName,
    "description" : description,
    "mainImage" : mainImage!.toJson(),
    "moreImages" : moreImages,
    "price" : price,
    "categories" : categories,
    "commission" : commission,
    "published" : published,
    "featured" : featured,
    "topSeller" : topSeller,
    "viewCount" : viewCount,
    "createdAt" : createdAt,
    "updatedAt" : updatedAt
  };
}
