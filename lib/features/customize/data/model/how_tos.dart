class HowTos {
  final String howToBuyFromUsDescription;
  final String howToAffiliateWithUsDescription;
  final String howToAffiliateWithUsVideoLink;

  HowTos(
      {required this.howToBuyFromUsDescription,
      required this.howToAffiliateWithUsDescription,
      required this.howToAffiliateWithUsVideoLink});

  factory HowTos.fromJson(Map<String, dynamic> json) => HowTos(
      howToBuyFromUsDescription: json["howToBuyFromUsDescription"],
      howToAffiliateWithUsDescription: json["howToAffiliateWithUsDescription"],
      howToAffiliateWithUsVideoLink: json["howToAffiliateWithUsVideoLink"]);
}
