class Policy {
  const Policy({
    required this.id,
    required this.policyNm,
    this.policyYr,
    this.rgnSeNm,
    this.policyTypeNm,
    this.sprvsnInstNm,
    this.operInstNm,
    this.policyBgngYmd,
    this.policyEndYmd,
    this.policyScl,
    this.policyCn,
    this.policyEnq,
    this.onlineApply,
    this.applyStart,
    this.applyEnd,
    this.isApplyNow,
    this.dtlLinkUrl,
    this.dsplyYn,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.dday,
    this.isOngoing,
  });

  final String id; // no
  final String policyNm;
  final String? policyYr;
  final String? rgnSeNm;
  final String? policyTypeNm;
  final String? sprvsnInstNm;
  final String? operInstNm;
  final DateTime? policyBgngYmd;
  final DateTime? policyEndYmd;
  final String? policyScl;
  final String? policyCn;
  final String? policyEnq;
  final bool? onlineApply;
  final DateTime? applyStart; // aplyBgngDt
  final DateTime? applyEnd; // aplyEndDt
  final bool? isApplyNow; // aplyPsbltyYn
  final String? dtlLinkUrl;
  final String? dsplyYn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<String> tags;
  final int? dday;
  final bool? isOngoing;
}
