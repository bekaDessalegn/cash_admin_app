import 'package:cash_admin_app/features/customize/data/model/image.dart';

class WhyUsContent {
  final ImageContent whyUsImage;
  final String whyUsTitle;
  final String whyUsDescription;

  WhyUsContent(
      {required this.whyUsImage,
        required this.whyUsTitle,
        required this.whyUsDescription});

  factory WhyUsContent.fromJson(Map<String, dynamic> json) => WhyUsContent(
      whyUsImage: ImageContent.fromJson(json["whyUsImage"]),
      whyUsTitle: json["whyUsTitle"],
      whyUsDescription: json["whyUsDescription"]);
}
