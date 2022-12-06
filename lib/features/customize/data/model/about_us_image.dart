import 'package:cash_admin_app/features/customize/data/model/image.dart';

class AboutUsImage {
  final ImageContent aboutUsImage;

  AboutUsImage({required this.aboutUsImage});

  factory AboutUsImage.fromJson(Map<String, dynamic> json) =>
      AboutUsImage(aboutUsImage: ImageContent.fromJson(json["aboutUsImage"]));
}
