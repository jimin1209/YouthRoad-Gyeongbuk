import 'package:flutter/material.dart';
import 'package:youth_road_app/ui/components/policy_cta_button.dart';
import 'package:youth_road_app/ui/components/policy_info_row.dart';
import 'package:youth_road_app/ui/components/policy_tag.dart';
import 'package:youth_road_app/ui/components/section_title.dart';

/// 정책 상세 화면
///
/// - DESIGN:
///   - 상단: 제목 + 태그 + 즐겨찾기/공유/알림 아이콘
///   - CTA: "신청 페이지 열기" Primary 버튼
///   - 알림: 2×2 Grid 버튼
///   - 섹션: 지원내용 / 접수기간 / 기관·부서·문의처
///
/// - NOTE:
///   여기서는 UI에만 집중하고, 실제 데이터/로직은
///   상위에서 주입하거나 callback 으로 연결하는 구조로 설계함.
class PolicyDetailScreen extends StatelessWidget {
  /// 화면 타이틀 (정책 이름)
  final String title;

  /// 정책 태그 목록 (예: ["청년", "주거", "경북"])
  final List<String> tags;

  /// 신청/접수 기간 텍스트
  final String periodText;

  /// 지원 내용(본문)
  final String supportContent;

  /// 기관명
  final String organizationName;

  /// 담당 부서
  final String departmentName;

  /// 문의처 (전화번호/이메일 등)
  final String contactInfo;

  /// (선택) 정책 요약 설명
  final String? summary;

  /// (선택) 신청 페이지 URL 표시용
  final String? applyUrlForDisplay;

  /// 액션 콜백들
  final VoidCallback? onTapOpenApplyPage;
  final VoidCallback? onTapFavorite;
  final VoidCallback? onTapShare;

  /// 알림 옵션 콜백들
  final VoidCallback? onTapReminder1DayBefore;
  final VoidCallback? onTapReminder3DaysBefore;
  final VoidCallback? onTapReminder7DaysBefore;
  final VoidCallback? onTapReminderOnDue;

  /// 현재 선택된 알림 옵션 상태 (UI 하이라이트용)
  final ReminderOption? selectedReminder;

  const PolicyDetailScreen({
    super.key,
    required this.title,
    required this.tags,
    required this.periodText,
    required this.supportContent,
    required this.organizationName,
    required this.departmentName,
    required this.contactInfo,
    this.summary,
    this.applyUrlForDisplay,
    this.onTapOpenApplyPage,
    this.onTapFavorite,
    this.onTapShare,
    this.onTapReminder1DayBefore,
    this.onTapReminder3DaysBefore,
    this.onTapReminder7DaysBefore,
    this.onTapReminderOnDue,
    this.selectedReminder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('정책 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: onTapFavorite,
            tooltip: '관심 정책',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: onTapShare,
            tooltip: '공유하기',
          ),
        ],
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목 + 태그
                _buildHeader(context),

                const SizedBox(height: 16),

                // 요약
                if (summary != null && summary!.trim().isNotEmpty) ...[
                  Text(
                    summary!,
                    style: textTheme.bodyMedium!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 접수기간 간단 강조
                _buildPeriodHighlight(context),

                const SizedBox(height: 20),

                // 신청 페이지 열기 CTA
                PolicyCtaButton(
                  text: '신청 페이지 열기',
                  onTap: onTapOpenApplyPage,
                ),

                if (applyUrlForDisplay != null &&
                    applyUrlForDisplay!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    applyUrlForDisplay!,
                    style: textTheme.bodySmall!.copyWith(
                      color: scheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 알림 설정 영역
                SectionTitle(title: '알림 설정'),
                const SizedBox(height: 8),
                Text(
                  '마감 전에 알림을 받아보고 싶다면 원하는 시점을 선택하세요.',
                  style: textTheme.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _buildReminderGrid(context),

                const SizedBox(height: 24),

                // 지원 내용
                SectionTitle(title: '지원 내용'),
                const SizedBox(height: 8),
                Text(
                  supportContent,
                  style: textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                // 접수 기간 상세 섹션
                SectionTitle(title: '접수 기간'),
                const SizedBox(height: 4),
                Text(
                  periodText,
                  style: textTheme.bodyMedium!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // 기관 / 부서 / 문의처
                SectionTitle(title: '기관 및 문의'),
                const SizedBox(height: 4),
                PolicyInfoRow(
                  label: '주관 기관',
                  value: organizationName,
                ),
                PolicyInfoRow(
                  label: '담당 부서',
                  value: departmentName,
                ),
                PolicyInfoRow(
                  label: '문의처',
                  value: contactInfo,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 상단 헤더 (정책 제목 + 태그)
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge!.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: tags.map((label) => PolicyTag(label: label)).toList(),
        ),
      ],
    );
  }

  /// 상단 기간 강조 박스
  Widget _buildPeriodHighlight(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: scheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              periodText,
              style: textTheme.bodyMedium!.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2×2 알림 옵션 Grid
  Widget _buildReminderGrid(BuildContext context) {
    final options = [
      _ReminderTileConfig(
        label: '마감 하루 전',
        description: 'D-1',
        option: ReminderOption.oneDayBefore,
        onTap: onTapReminder1DayBefore,
      ),
      _ReminderTileConfig(
        label: '마감 3일 전',
        description: 'D-3',
        option: ReminderOption.threeDaysBefore,
        onTap: onTapReminder3DaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 7일 전',
        description: 'D-7',
        option: ReminderOption.sevenDaysBefore,
        onTap: onTapReminder7DaysBefore,
      ),
      _ReminderTileConfig(
        label: '마감 당일',
        description: '마감날 아침',
        option: ReminderOption.onDueDate,
        onTap: onTapReminderOnDue,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2; // 2열 + 가로 간격 12

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((cfg) {
            final isSelected = selectedReminder == cfg.option;
            return SizedBox(
              width: width,
              child: _ReminderTile(
                label: cfg.label,
                description: cfg.description,
                selected: isSelected,
                onTap: cfg.onTap,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// 알림 옵션 enum (UI 하이라이트용)
enum ReminderOption {
  oneDayBefore,
  threeDaysBefore,
  sevenDaysBefore,
  onDueDate,
}

/// 알림 타일 구성 정보
class _ReminderTileConfig {
  final String label;
  final String description;
  final ReminderOption option;
  final VoidCallback? onTap;

  const _ReminderTileConfig({
    required this.label,
    required this.description,
    required this.option,
    this.onTap,
  });
}

/// 알림 옵션 개별 타일 UI
class _ReminderTile extends StatelessWidget {
  final String label;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  const _ReminderTile({
    required this.label,
    required this.description,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = selected ? scheme.primaryContainer : scheme.surfaceVariant;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;
    final labelColor = selected ? scheme.primary : scheme.onSurface;
    final descColor = selected ? scheme.primary : scheme.onSurfaceVariant;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall!.copyWith(
                  color: descColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
