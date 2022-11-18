class ProductImage{
  final String path;
  ProductImage({required this.path});

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      ProductImage(path: json["path"]);

  Map<String, dynamic> toJson() => {
    "path" : path
  };
}