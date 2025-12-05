import '../../domain/youthcenter/paging_entity.dart';
import '../../domain/youthcenter/policy_entity.dart';
import '../../domain/youthcenter/policy_search_query.dart';
import '../dto/policy_youthcenter_dto.dart';

extension PolicyDtoMapper on PolicyYouthcenterItemDto {
  PolicyEntity toDomain() {
    return PolicyEntity(
      title: _required(plcyNm, '제목 없음'),
      period: _formatPeriod(bizPrdBgngYmd, bizPrdEndYmd),
      organization: _required(
        sprvsnInstCdNm ?? operInstCdNm,
        '기관 정보 없음',
      ),
      region: _required(rgtrInstCdNm ?? rgtrUpInstCdNm, '지역 정보 없음'),
      ageCondition: _formatAge(sprtTrgtMinAge, sprtTrgtMaxAge),
      jobCondition: jobCd,
      educationCondition: schoolCd,
      benefit: _optional(plcySprtCn ?? sprtSclCnt),
      applyMethod: _optional(plcyAplyMthdCn ?? srngMthdCn ?? aplyUrlAddr),
      detailsUrl: _optional(refUrlAddr1 ?? refUrlAddr2 ?? aplyUrlAddr),
    );
  }

  String _formatPeriod(String? start, String? end) {
    if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) {
      return '기간 정보 없음';
    }

    if (start != null && start.isNotEmpty && end != null && end.isNotEmpty) {
      return '$start ~ $end';
    }

    return start?.isNotEmpty == true
        ? start!
        : end?.isNotEmpty == true
            ? end!
            : '기간 정보 없음';
  }

  String? _formatAge(String? min, String? max) {
    if ((min == null || min.isEmpty) && (max == null || max.isEmpty)) {
      return null;
    }

    if (min != null && min.isNotEmpty && max != null && max.isNotEmpty) {
      return '$min ~ $max세';
    }

    return min?.isNotEmpty == true ? '$min세 이상' : '$max세 이하';
  }

  String _required(String? value, String defaultValue) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return defaultValue;
    }
    return trimmed;
  }

  String? _optional(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

extension PolicyPagingMapper on PolicyYouthcenterPaggingDto? {
  PagingEntity toDomain() {
    if (this == null) {
      return PagingEntity.empty();
    }

    return PagingEntity(
      totalCount: this!.totCount ?? 0,
      pageNumber: this!.pageNum ?? 1,
      pageSize: this!.pageSize ?? 0,
    );
  }
}

extension PolicyQueryPaging on PolicySearchQuery {
  Duration get ttl => cacheDuration ?? const Duration(hours: 1);
}
