class Wallet {
  final num totalMade;
  final num currentBalance;
  final num canWithdrawAfter;

  Wallet(
      {required this.totalMade,
      required this.currentBalance,
      required this.canWithdrawAfter});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
      totalMade: json["totalMade"],
      currentBalance: json["currentBalance"],
      canWithdrawAfter: json["canWithdrawAfter"]);
}
