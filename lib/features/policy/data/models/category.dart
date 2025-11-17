class Category {
  final String code;
  final String name;

  Category({required this.code, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      code: json['code'] as String,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}
