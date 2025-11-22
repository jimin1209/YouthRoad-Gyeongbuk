class Policy {
  const Policy({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.tags,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final List<String> tags;
}
