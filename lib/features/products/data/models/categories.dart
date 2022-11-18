class Categories {
  final String? categoryId;
  final String categoryName;

  Categories({this.categoryId, required this.categoryName});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      Categories(
          categoryId: json["categoryId"],
          categoryName: json["categoryName"]);
}
