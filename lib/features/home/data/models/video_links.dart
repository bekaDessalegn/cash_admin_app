class VideoLinks {
  final String? whoAreWe;
  final String? howToAffiliateWithUs;

  VideoLinks({this.whoAreWe, this.howToAffiliateWithUs});

  factory VideoLinks.fromJson(Map<String, dynamic> json) => VideoLinks(
      whoAreWe: json["whoAreWe"],
      howToAffiliateWithUs: json["howToAffiliateWithUs"]);
}
