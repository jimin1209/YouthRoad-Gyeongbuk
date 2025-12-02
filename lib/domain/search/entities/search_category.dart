// FILE: lib/domain/search/entities/search_category.dart

enum SearchCategory {
  all(label: '전체'),
  policy(label: '정책'),
  institution(label: '기관'),
  region(label: '지역');

  const SearchCategory({required this.label});

  final String label;

  static SearchCategory fromLabel(String value) {
    return SearchCategory.values.firstWhere(
      (item) => item.label == value,
      orElse: () => SearchCategory.all,
    );
  }
}
