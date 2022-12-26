import 'dart:typed_data';

class LogoImage {
  final Uint8List logoImage;

  LogoImage({required this.logoImage});

  factory LogoImage.fromJson(Map<String, dynamic> json) =>
      LogoImage(logoImage: json["logoImage"]);

  Map<String, dynamic> toJson() => {
    "logoImage" : logoImage
  };
}
