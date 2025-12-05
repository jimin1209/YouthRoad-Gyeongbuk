class YouthCenterEntity {
  const YouthCenterEntity({
    required this.centerName,
    required this.address,
    this.phoneNumber,
    this.websiteUrl,
    this.openHour,
  });

  final String centerName;
  final String address;
  final String? phoneNumber;
  final String? websiteUrl;
  final String? openHour;
}
