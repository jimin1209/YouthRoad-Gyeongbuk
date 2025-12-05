class YouthContentEntity {
  const YouthContentEntity({
    required this.title,
    this.thumbnailUrl,
    this.datePublished,
    this.linkUrl,
  });

  final String title;
  final String? thumbnailUrl;
  final String? datePublished;
  final String? linkUrl;
}
