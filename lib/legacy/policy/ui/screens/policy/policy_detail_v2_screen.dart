import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:youth_road_app/application/providers.dart';
import 'package:youth_road_app/domain/entities/policy.dart';
import 'package:youth_road_app/legacy/policy/application/notifiers/policy_detail_notifier.dart';
import 'package:youth_road_app/navigation/route_paths.dart';
import 'package:youth_road_app/ui/components/policy_card.dart';
import 'package:youth_road_app/ui/components/policy_cta_button.dart';
import 'package:youth_road_app/ui/components/policy_info_row.dart';
import 'package:youth_road_app/ui/components/policy_tag.dart';
import 'package:youth_road_app/ui/components/section_title.dart';
import 'package:youth_road_app/ui/widgets/app_appbar.dart';
import 'package:youth_road_app/ui/widgets/global_error_view.dart';

class PolicyDetailV2Screen extends ConsumerStatefulWidget {
  const PolicyDetailV2Screen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<PolicyDetailV2Screen> createState() => _PolicyDetailV2ScreenState();
}

class _PolicyDetailV2ScreenState extends ConsumerState<PolicyDetailV2Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    ref.read(policyDetailProvider.notifier).load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(policyDetailProvider);
    final policy = detailState.policy;

    Widget body() {
      if (detailState.isLoading && policy == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (detailState.error != null && policy == null) {
        return GlobalErrorView(
          message: PolicyDetailNotifier.errorMessage,
          onRetry: _load,
        );
      }
      if (policy == null) {
        return GlobalErrorView(
          message: PolicyDetailNotifier.errorMessage,
          onRetry: _load,
        );
      }
      return _buildDetail(context, policy, detailState.similar);
    }

    return Scaffold(
      appBar: const AppAppBar(title: '정책 상세'),
      body: body(),
    );
  }

  Widget _buildDetail(BuildContext context, Policy policy, List<Policy> similar) {
    final theme = Theme.of(context);
    final region = (policy.rgnSeNm ?? '').trim().isEmpty ? '지역 전체' : policy.rgnSeNm!.trim();
    final ddayText = _formatDday(policy.dday);
    final periodText =
        _formatPeriod(policy.policyBgngYmd, policy.policyEndYmd, policy.applyStart, policy.applyEnd);
    final tags = _buildTags(policy, region, ddayText);
    final hasLink = (policy.dtlLinkUrl ?? '').trim().isNotEmpty;
    final normalizedLink = (policy.dtlLinkUrl ?? '').trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  policy.policyNm,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                tooltip: hasLink ? '신청 링크 열기' : '신청 링크 없음',
                onPressed: hasLink ? () => _openLink(context, normalizedLink) : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((e) => PolicyTag(label: e)).toList(),
          ),
          const SizedBox(height: 20),
          PolicyCtaButton(
            text: hasLink ? '신청 페이지 열기' : '신청 링크 없음',
            onTap: hasLink ? () => _openLink(context, normalizedLink) : null,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.2,
            children: [
              FilledButton.icon(
                onPressed: () => _showInfo(context, '마감 알림 기능은 추후 제공 예정입니다.'),
                icon: const Icon(Icons.alarm_add_outlined),
                label: const Text('마감 알림'),
              ),
              OutlinedButton.icon(
                onPressed: () => _showInfo(context, '즐겨찾기 기능은 별도 화면에서 제공됩니다.'),
                icon: const Icon(Icons.bookmark_border),
                label: const Text('즐겨찾기'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => _showInfo(context, '공유 기능은 링크 열기로 대체됩니다.'),
                icon: const Icon(Icons.share_rounded),
                label: const Text('공유하기'),
              ),
              OutlinedButton.icon(
                onPressed: () => _showInfo(context, '비교함은 정책 목록 화면에서 사용할 수 있습니다.'),
                icon: const Icon(Icons.balance_outlined),
                label: const Text('비교함 이동'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SectionTitle(title: '지원 내용'),
          Text(
            _cleanText(policy.policyCn) ?? '지원 내용이 제공되지 않았습니다.',
            style: theme.textTheme.bodyMedium,
          ),
          const SectionTitle(title: '문의처'),
          Text(
            _cleanText(policy.policyEnq) ?? '문의처 정보가 없습니다.',
            style: theme.textTheme.bodyMedium,
          ),
          const SectionTitle(title: '신청 정보'),
          PolicyInfoRow(label: '신청 기간', value: periodText ?? '기간 정보 없음'),
          PolicyInfoRow(label: '주관 기관', value: policy.sprvsnInstNm ?? '주관 기관 정보 없음'),
          PolicyInfoRow(label: '운영 기관', value: policy.operInstNm ?? '운영 기관 정보 없음'),
          PolicyInfoRow(label: '지역', value: region),
          if (ddayText != null) PolicyInfoRow(label: '진행 상태', value: ddayText),
          if (hasLink) ...[
            const SizedBox(height: 12),
            PolicyCtaButton(
              text: '홈페이지에서 자세히 보기',
              onTap: () => _openLink(context, normalizedLink),
            ),
          ] else ...[
            const SizedBox(height: 12),
            PolicyInfoRow(label: '신청 링크', value: '제공된 링크 없음'),
          ],
          if (similar.isNotEmpty) ...[
            const SizedBox(height: 24),
            const SectionTitle(title: '유사 정책'),
            const SizedBox(height: 8),
            ...similar.take(3).map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: PolicyCard(
                  title: p.policyNm,
                  summary: _buildSummary(p),
                  tags: _buildTags(p, p.rgnSeNm ?? '지역 전체', _formatDday(p.dday)),
                  period: _formatPeriod(
                        p.policyBgngYmd,
                        p.policyEndYmd,
                        p.applyStart,
                        p.applyEnd,
                      ) ??
                      '기간 정보 없음',
                  onTap: () => context.pushReplacement(RoutePaths.policyDetail(p.id)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final normalized = url.trim();
    if (normalized.isEmpty) return;
    try {
      final launched = await launchUrlString(normalized);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('링크를 열 수 없습니다.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('잘못된 링크입니다.')),
        );
      }
    }
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  List<String> _buildTags(Policy policy, String region, String? ddayText) {
    final tags = <String>[];
    if (policy.policyTypeNm != null && policy.policyTypeNm!.trim().isNotEmpty) {
      tags.add(policy.policyTypeNm!.trim());
    }
    if (region.trim().isNotEmpty) {
      tags.add(region.trim());
    }
    tags.addAll(policy.tags.where((tag) => tag.trim().isNotEmpty));
    if (ddayText != null) {
      tags.add(ddayText);
    }
    return tags.toSet().toList();
  }

  String _buildSummary(Policy policy) {
    final candidates = [policy.policyScl, policy.policyCn, policy.policyEnq];
    for (final value in candidates) {
      if (value == null) continue;
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '지원 내용이 제공되지 않았습니다.';
  }

  String? _cleanText(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.replaceAll(RegExp(r'\n{3,}', multiLine: true), '\n\n');
  }

  String? _formatPeriod(
    DateTime? start,
    DateTime? end,
    DateTime? applyStart,
    DateTime? applyEnd,
  ) {
    final startText = _formatDate(applyStart ?? start);
    final endText = _formatDate(applyEnd ?? end);
    if (startText == null && endText == null) return null;
    if (startText != null && endText != null) return '$startText ~ $endText';
    if (startText != null) return '$startText 시작';
    return '~ $endText';
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String().split('T').first;
  }

  String? _formatDday(int? dday) {
    if (dday == null) return null;
    if (dday == 0) return 'D-Day';
    if (dday > 0) return 'D-$dday';
    return 'D+${dday.abs()}';
  }
}
