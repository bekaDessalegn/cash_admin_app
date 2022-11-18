class AffiliationSummary {
  final num totalRequests;
  final num acceptedRequests;
  final num rejectedRequests;

  AffiliationSummary(
      {required this.totalRequests,
      required this.acceptedRequests,
      required this.rejectedRequests});

  factory AffiliationSummary.fromJson(Map<String, dynamic> json) =>
      AffiliationSummary(
          totalRequests: json["totalRequests"],
          acceptedRequests: json["acceptedRequests"],
          rejectedRequests: json["rejectedRequests"]);
}
