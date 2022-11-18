class AffiliateTransaction {
  final String userId;
  final String fullName;

  AffiliateTransaction({required this.userId, required this.fullName});

  factory AffiliateTransaction.fromJson(Map<String, dynamic> json) =>
      AffiliateTransaction(userId: json["userId"], fullName: json["fullName"]);
}
