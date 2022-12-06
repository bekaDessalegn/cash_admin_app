import 'package:cash_admin_app/features/customize/data/model/image.dart';

class WhoAreWeContent {
  final ImageContent whoAreWeImage;
  final String whoAreWeDescription;
  final String whoAreWeVideoLink;

  WhoAreWeContent(
      {required this.whoAreWeImage,
        required this.whoAreWeDescription,
        required this.whoAreWeVideoLink});

  factory WhoAreWeContent.fromJson(Map<String, dynamic> json) => WhoAreWeContent(
      whoAreWeImage: ImageContent.fromJson(json["whoAreWeImage"]),
      whoAreWeDescription: json["whoAreWeDescription"],
      whoAreWeVideoLink: json["whoAreWeVideoLink"]);
}
