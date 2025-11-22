import '../../domain/entities/policy.dart';

class PolicyModel {
  const PolicyModel({
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

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      summary: json['summary'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
    );
  }

  Policy toEntity() => Policy(
        id: id,
        title: title,
        category: category,
        summary: summary,
        tags: tags,
      );
}
