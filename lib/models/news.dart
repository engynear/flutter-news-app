class News {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  News({
    required this.title,
    this.description = "",
    required this.url,
    this.urlToImage = "",
    required this.publishedAt,
    this.content = "",
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'],
      urlToImage: json['urlToImage'] ?? "",
      publishedAt: json['publishedAt'],
      content: json['content'] ?? "",
    );
  }
}
