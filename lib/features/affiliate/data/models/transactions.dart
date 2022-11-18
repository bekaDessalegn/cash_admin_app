import 'package:cash_admin_app/features/affiliate/data/models/affiliate_transaction.dart';
import 'package:cash_admin_app/features/affiliate/data/models/transaction_reason.dart';

class Transactions {
  final String transactionId;
  final AffiliateTransaction affiliate;
  final num amount;
  final Reason reason;
  final String transactedAt;

  Transactions(
      {required this.transactionId,
      required this.affiliate,
      required this.amount,
      required this.reason,
      required this.transactedAt});

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
      transactionId: json["transactionId"],
      affiliate: AffiliateTransaction.fromJson(json["affiliate"]),
      amount: json["amount"],
      reason: Reason.fromJson(json["reason"]),
      transactedAt: json["transactedAt"]);
}
