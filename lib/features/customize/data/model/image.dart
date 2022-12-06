class ImageContent{
  final String path;

  ImageContent({required this.path});

  factory ImageContent.fromJson(Map<String, dynamic> json) => ImageContent(path: json["path"]);
}