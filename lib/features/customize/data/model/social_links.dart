import 'package:cash_admin_app/features/customize/data/model/image.dart';

class SocialLinks{
  final String? id;
  final ImageContent logoImage;
  final String link;
  final num rank;

  SocialLinks({this.id, required this.logoImage, required this.link, required this.rank});

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
      id: json["id"],
      logoImage: ImageContent.fromJson(json["logoImage"]),
      link: json["link"],
      rank: json["rank"]);
}