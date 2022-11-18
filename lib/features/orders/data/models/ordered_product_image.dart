class OrderedProductImage{
  final String? path;
  OrderedProductImage({this.path});

  factory OrderedProductImage.fromJson(Map<String, dynamic> json) =>
      OrderedProductImage(path: json["path"]);
}