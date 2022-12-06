import 'package:cash_admin_app/features/customize/data/model/image.dart';

class HeroContent {
  final ImageContent heroImage;
  final String heroShortTitle;
  final String heroLongTitle;
  final String heroDescription;

  HeroContent(
      {required this.heroImage,
      required this.heroShortTitle,
      required this.heroLongTitle,
      required this.heroDescription});

  factory HeroContent.fromJson(Map<String, dynamic> json) => HeroContent(
      heroImage: ImageContent.fromJson(json["heroImage"]),
      heroShortTitle: json["heroShortTitle"],
      heroLongTitle: json["heroLongTitle"],
      heroDescription: json["heroDescription"]);
}
