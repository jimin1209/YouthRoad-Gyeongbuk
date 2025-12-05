import '../../domain/youthcenter/youth_content_entity.dart';
import '../dto/content_youthcenter_dto.dart';

extension YouthContentDtoMapper on ContentYouthcenterItemDto {
  YouthContentEntity toDomain() {
    return YouthContentEntity(
      title: pstTtl?.trim().isNotEmpty == true ? pstTtl!.trim() : '제목 없음',
      thumbnailUrl: atchFile?.trim().isNotEmpty == true ? atchFile!.trim() : null,
      datePublished: frstRegDt ?? lastMdfcnDt,
      linkUrl: pstUrlAddr,
    );
  }
}
