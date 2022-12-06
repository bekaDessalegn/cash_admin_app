import 'package:cash_admin_app/features/customize/data/model/image.dart';

class Brands {
  final String? id;
  final ImageContent logoImage;
  final String link;
  final num rank;

  Brands(
      {this.id,
      required this.logoImage,
      required this.link,
      required this.rank});

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
      id: json["id"],
      logoImage: ImageContent.fromJson(json["logoImage"]),
      link: json["link"] ?? "",
      rank: json["rank"]);
}
