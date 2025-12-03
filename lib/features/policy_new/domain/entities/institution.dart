class Institution {
  const Institution({
    required this.id,
    required this.name,
    this.tel,
    this.address,
  });

  final String id;
  final String name;
  final String? tel;
  final String? address;
}
