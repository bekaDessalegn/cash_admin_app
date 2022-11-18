class Children {
  final String userId;
  final String fullName;
  final int childrenCount;

  Children(
      {required this.userId,
      required this.fullName,
      required this.childrenCount});

  factory Children.fromJson(Map<String, dynamic> json) => Children(
      userId: json["userId"],
      fullName: json["fullName"],
      childrenCount: json["childrenCount"]);
}
