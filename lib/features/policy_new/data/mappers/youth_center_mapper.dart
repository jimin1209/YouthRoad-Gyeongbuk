import '../../domain/youthcenter/youth_center_entity.dart';
import '../dto/center_youthcenter_dto.dart';

extension YouthCenterDtoMapper on CenterYouthcenterItemDto {
  YouthCenterEntity toDomain() {
    final addressParts = [cntrAddr, cntrDaddr]
        .where((value) => value != null && value!.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();

    return YouthCenterEntity(
      centerName: cntrNm?.trim().isNotEmpty == true ? cntrNm!.trim() : '센터 이름 정보 없음',
      address: addressParts.isNotEmpty ? addressParts.join(' ') : '주소 정보 없음',
      phoneNumber: cntrTelno,
      websiteUrl: cntrUrlAddr,
      openHour: null,
    );
  }
}
