import '../../domain/youthcenter/youth_center_detail_viewmodel.dart';
import '../../domain/youthcenter/youth_center_entity.dart';
import '../dto/center_youthcenter_dto.dart';

extension YouthCenterDtoMapper on CenterYouthcenterItemDto {
  YouthCenterEntity toDomain() {
    final lat = (geocodedLat == null || geocodedLat == 0) ? null : geocodedLat;
    final lng = (geocodedLng == null || geocodedLng == 0) ? null : geocodedLng;

    return YouthCenterEntity(
      centerName:
          cntrNm?.trim().isNotEmpty == true ? cntrNm!.trim() : 'Unknown Center',
      address: cntrAddr?.trim().isNotEmpty == true
          ? cntrAddr!.trim()
          : 'Unknown Address',
      lat: lat,
      lng: lng,
      detailAddress: cntrDaddr?.trim(),
      sidoName: stdgCtpvCdNm?.trim(),
      sigunguName: stdgSggCdNm?.trim(),
      phoneNumber: cntrTelno?.trim(),
      websiteUrl: cntrUrlAddr?.trim(),
      openHour: null,
    );
  }
}

extension YouthCenterDetailMapper on YouthCenterEntity {
  YouthCenterDetailVM toDetailVM() {
    final detail =
        (detailAddress?.trim().isNotEmpty == true) ? ' $detailAddress' : '';
    final fullAddress = '${address.trim()}$detail'.trim();
    final regionLabel = '${sidoName ?? ''} ${sigunguName ?? ''}'.trim();

    return YouthCenterDetailVM(
      name: centerName,
      fullAddress: fullAddress,
      phone: phoneNumber,
      url: websiteUrl,
      regionLabel: regionLabel,
    );
  }
}

class CenterMarkerPoint {
  final String id;
  final String name;
  final String rawAddress;
  final double lat;
  final double lng;
  final String fullAddress;
  final String? phone;
  final String? url;
  final String regionLabel;

  const CenterMarkerPoint({
    required this.id,
    required this.name,
    required this.rawAddress,
    required this.lat,
    required this.lng,
    required this.fullAddress,
    required this.phone,
    required this.url,
    required this.regionLabel,
  });
}

extension YouthCenterMarkerMapper on YouthCenterEntity {
  CenterMarkerPoint toMarkerPoint({
    required double lat,
    required double lng,
  }) {
    final detail = detailAddress?.trim().isNotEmpty == true
        ? ' ${detailAddress!.trim()}'
        : '';
    final fullAddress = '${address.trim()}$detail'.trim();
    final normalizedName = centerName.trim().replaceAll(' ', '_');
    final normalizedAddr = fullAddress.replaceAll(' ', '_');
    final id =
        '${normalizedName}_${normalizedAddr}_${lat.toStringAsFixed(5)}_${lng.toStringAsFixed(5)}';

    return CenterMarkerPoint(
      id: id,
      name: centerName,
      rawAddress: address.trim(),
      lat: lat,
      lng: lng,
      fullAddress: fullAddress,
      phone: phoneNumber,
      url: websiteUrl,
      regionLabel: '${sidoName ?? ''} ${sigunguName ?? ''}'.trim(),
    );
  }
}
