class Avatar{
  final String? path;
  Avatar({this.path});

  factory Avatar.fromJson(Map<String, dynamic> json) =>
      Avatar(path: json["path"]);
}