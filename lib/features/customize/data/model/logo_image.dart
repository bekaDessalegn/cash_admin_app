import 'package:cash_admin_app/features/customize/data/model/image.dart';

class LogoImage {
  final ImageContent logoImage;

  LogoImage({required this.logoImage});

  factory LogoImage.fromJson(Map<String, dynamic> json) =>
      LogoImage(logoImage: ImageContent.fromJson(json["logoImage"]));
}
