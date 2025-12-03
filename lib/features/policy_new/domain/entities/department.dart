class Department {
  const Department({
    required this.id,
    required this.instNo,
    required this.name,
    this.tel,
  });

  final String id;
  final String instNo;
  final String name;
  final String? tel;
}
