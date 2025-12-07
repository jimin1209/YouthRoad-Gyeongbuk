class YouthCenterEntity {
  const YouthCenterEntity({
    required this.centerName,
    required this.address,
    this.lat,
    this.lng,
    this.detailAddress,
    this.sidoName,
    this.sigunguName,
    this.phoneNumber,
    this.websiteUrl,
    this.openHour,
  });

  final String centerName;
  final String address;
  final double? lat;
  final double? lng;
  final String? detailAddress;
  final String? sidoName;
  final String? sigunguName;
  final String? phoneNumber;
  final String? websiteUrl;
  final String? openHour;
}
