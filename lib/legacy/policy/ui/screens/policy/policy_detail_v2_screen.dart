import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:youth_road_app/application/providers.dart';
import 'package:youth_road_app/domain/entities/policy.dart';
import 'package:youth_road_app/navigation/route_paths.dart';
import 'package:youth_road_app/ui/widgets/app_appbar.dart';
import 'package:youth_road_app/ui/widgets/global_error_view.dart';
import 'package:youth_road_app/ui/widgets/policy_card_v2.dart';

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
    final colorScheme = theme.colorScheme;
    final region = (policy.rgnSeNm ?? '').trim().isEmpty ? '지역 전체' : policy.rgnSeNm!.trim();
    final ddayText = _formatDday(policy.dday);
    final periodText = _formatPeriod(policy.policyBgngYmd, policy.policyEndYmd,
        policy.applyStart, policy.applyEnd);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            policy.policyNm,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (policy.policyTypeNm != null)
                Chip(label: Text(policy.policyTypeNm!)),
              Chip(label: Text(region)),
              if (ddayText != null)
                Chip(
                  backgroundColor: colorScheme.primaryContainer,
                  label: Text(ddayText),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: '요약',
            child: Text(_cleanText(policy.policyScl) ?? '정보 없음'),
          ),
          const SizedBox(height: 16),
          _Section(
            title: '지원 내용',
            child: Text(_cleanText(policy.policyCn) ?? '지원 내용이 제공되지 않았습니다.'),
          ),
          const SizedBox(height: 16),
          _Section(
            title: '문의',
            child: Text(_cleanText(policy.policyEnq) ?? '문의처 정보가 없습니다.'),
          ),
          const SizedBox(height: 16),
          _Section(
            title: '신청 기간',
            child: Text(periodText ?? '기간 정보 없음'),
          ),
          const SizedBox(height: 16),
          if ((policy.dtlLinkUrl ?? '').isNotEmpty)
            FilledButton.icon(
              onPressed: () => _openLink(context, policy.dtlLinkUrl!),
              icon: const Icon(Icons.open_in_new),
              label: const Text('홈페이지에서 자세히 보기'),
            ),
          if (similar.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('유사 정책', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...similar.take(3).map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: PolicyCardV2(
                  policy: p,
                  onTap: () =>
                      context.pushReplacement(RoutePaths.policyDetail(p.id)),
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
    final launched = await launchUrlString(normalized);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('링크를 열 수 없습니다.')),
      );
    }
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
