class ParentAffiliate {
  final String userId;
  final String fullName;

  ParentAffiliate({required this.userId, required this.fullName});

  factory ParentAffiliate.fromJson(Map<String, dynamic> json) => ParentAffiliate(userId: json["userId"], fullName: json["fullName"]);
}