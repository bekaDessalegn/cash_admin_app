import 'package:cash_admin_app/features/affiliate/data/models/affiliate_transaction.dart';

class Reason {
  final String kind;
  final AffiliateTransaction? affiliate;
  final String? productId;

  Reason(
      {required this.kind, this.affiliate, this.productId});

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
      kind: json["kind"],
      affiliate: json["affiliate"].toString() == "null" ? AffiliateTransaction(userId: "userId", fullName: "fullName") : AffiliateTransaction.fromJson(json["affiliate"]),
      productId: json["productId"]);
}
