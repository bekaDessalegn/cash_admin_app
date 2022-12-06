import 'package:cash_admin_app/features/customize/data/model/image.dart';

class AboutUsContent {
  final ImageContent aboutUsImage;
  final ImageContent whoAreWeImage;
  final String whoAreWeDescription;
  final String whoAreWeVideoLink;
  final String howToBuyFromUsDescription;
  final String howToAffiliateWithUsDescription;
  final String howToAffiliateWithUsVideoLink;

  AboutUsContent({required this.aboutUsImage,
    required this.whoAreWeImage,
    required this.whoAreWeDescription,
    required this.whoAreWeVideoLink,
    required this.howToBuyFromUsDescription,
    required this.howToAffiliateWithUsDescription,
    required this.howToAffiliateWithUsVideoLink});

  factory AboutUsContent.fromJson(Map<String, dynamic> json) =>
      AboutUsContent(
          aboutUsImage: ImageContent.fromJson(json["aboutUsImage"]),
          whoAreWeImage: ImageContent.fromJson(json["whoAreWeImage"]),
          whoAreWeDescription: json["whoAreWeDescription"],
          whoAreWeVideoLink: json["whoAreWeVideoLink"],
          howToBuyFromUsDescription: json["howToBuyFromUsDescription"],
          howToAffiliateWithUsDescription: json["howToAffiliateWithUsDescription"],
          howToAffiliateWithUsVideoLink: json["howToAffiliateWithUsVideoLink"]);
}
