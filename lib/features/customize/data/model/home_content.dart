import 'package:cash_admin_app/features/customize/data/model/brands.dart';
import 'package:cash_admin_app/features/customize/data/model/image.dart';
import 'package:cash_admin_app/features/customize/data/model/social_links.dart';

class HomeContent {
  final ImageContent heroImage;
  final String heroShortTitle;
  final String heroLongTitle;
  final String heroDescription;
  final ImageContent whyUsImage;
  final String whyUsTitle;
  final String whyUsDescription;
  final List whatMakesUsUnique;
  final ImageContent whatMakesUsUniqueImage;
  final List<dynamic> brands;
  final List<dynamic> socialLinks;

  HomeContent(
      {required this.heroImage,
      required this.heroShortTitle,
      required this.heroLongTitle,
      required this.heroDescription,
      required this.whyUsImage,
      required this.whyUsTitle,
      required this.whyUsDescription,
      required this.whatMakesUsUnique,
      required this.whatMakesUsUniqueImage,
      required this.brands,
      required this.socialLinks});

  factory HomeContent.fromJson(Map<String, dynamic> json) => HomeContent(
      heroImage: ImageContent.fromJson(json["heroImage"]),
      heroShortTitle: json["heroShortTitle"],
      heroLongTitle: json["heroLongTitle"],
      heroDescription: json["heroDescription"],
      whyUsImage: ImageContent.fromJson(json["whyUsImage"]),
      whyUsTitle: json["whyUsTitle"],
      whyUsDescription: json["whyUsDescription"],
      whatMakesUsUnique: json["whatMakesUsUnique"],
      whatMakesUsUniqueImage: ImageContent.fromJson(json["whatMakesUsUniqueImage"]),
      brands: json["brands"],
      socialLinks: json["socialLinks"]);
}
