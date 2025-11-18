import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../bookmark/controller/bookmark_controller.dart';
import '../../bookmark/data/bookmark_models.dart';
import '../controller/policy_detail_controller.dart';
import '../controller/policy_list_controller.dart';
import '../controller/policy_engagement_controller.dart';
import 'widgets/policy_card.dart';

class PolicyDetailPage extends ConsumerWidget {
  const PolicyDetailPage({super.key, required this.policyId});
  final String policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policyAsync = ref.watch(policyDetailControllerProvider(policyId));
    return Scaffold(
      appBar: AppBar(title: const Text('정책 상세')),
      body: policyAsync.when(
        data: (policy) {
          ref.read(policyEngagementControllerProvider.notifier).recordView(policy);
          final bookmarkController = ref.read(bookmarkControllerProvider.notifier);
          final bookmarks = ref.watch(bookmarkControllerProvider);
          final isBookmarked = bookmarks.maybeWhen(
                data: (items) => items.any((item) => item.policy.id == policy.id),
                orElse: () => false,
              );
          final related = ref.watch(relatedPoliciesProvider(policy));
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              Text(
                policy.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(policy.regionName)),
                  ...policy.categories.map((category) => Chip(label: Text(category))),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ActionButton(
                    icon: Icons.map_outlined,
                    label: '지도에서 보기',
                    onTap: () {
                      ref.read(policyFilterUseProfileProvider.notifier).state = false;
                      ref.read(policyFilterStateProvider.notifier).state =
                          ref.read(policyFilterStateProvider.notifier).state.copyWith(
                                region: policy.regionCode,
                              );
                      context.push(
                        '/home/unity-map',
                        extra: {
                          'regionCode': policy.regionCode,
                          'regionName': policy.regionName,
                        },
                      );
                    },
                  ),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: '링크 공유',
                    onTap: policy.applicationUrl.isEmpty
                        ? null
                        : () => _sharePolicy(context, policy.applicationUrl),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DetailSectionCard(
                title: '요약',
                children: [
                  Text(policy.summary, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 12),
                  _InfoRow(label: '주관 기관', value: policy.institutionName ?? '-'),
                  if (policy.contact.isNotEmpty)
                    _InfoRow(label: '문의처', value: policy.contact),
                ],
              ),
              const SizedBox(height: 16),
              _DetailSectionCard(
                title: '지원 조건',
                children: [
                  _InfoRow(label: '연령', value: '${policy.minAge} ~ ${policy.maxAge}세'),
                  if (policy.targetGroups.isNotEmpty)
                    _InfoRow(label: '대상', value: policy.targetGroups.join(', ')),
                ],
              ),
              const SizedBox(height: 16),
              _DetailSectionCard(
                title: '지원 혜택',
                children: [
                  _InfoRow(label: '형태', value: policy.supportType),
                  const SizedBox(height: 8),
                  Text(policy.supportDetail, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),
              _DetailSectionCard(
                title: '신청 및 일정',
                children: [
                  _InfoRow(
                    label: '신청 기간',
                    value: _buildScheduleText(policy.startDate, policy.endDate),
                  ),
                  _InfoRow(label: '방법', value: policy.applicationMethod),
                  if (policy.applicationUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            launchUrlString(policy.applicationUrl, mode: LaunchMode.externalApplication),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('신청 페이지 열기'),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () async {
                  if (isBookmarked) {
                    await bookmarkController.toggle(policy);
                    _showSnack(context, '북마크에서 제거했습니다.');
                  } else {
                    final folder = await _pickFolder(context) ?? BookmarkFolder.favorite;
                    await bookmarkController.toggle(policy, folder: folder);
                    _showSnack(context, '${folder.label} 폴더에 추가되었습니다.');
                  }
                },
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                label: Text(isBookmarked ? '북마크 해제' : '북마크 저장'),
              ),
              const SizedBox(height: 28),
              Text('연관 정책 추천', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: related.when(
                  data: (items) => items.isEmpty
                      ? const Center(child: Text('연관 정책이 없습니다.'))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, index) => SizedBox(
                            width: 320,
                            child: PolicyCard(policy: items[index]),
                          ),
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemCount: items.length,
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('연관 정책을 불러오지 못했습니다: $e')),
                ),
              ),
            ],
          );
        },
        loading: () => const _DetailSkeleton(),
        error: (e, _) => Center(child: Text('불러오지 못했습니다: $e')),
      ),
    );
  }

  String _buildScheduleText(DateTime? start, DateTime? end) {
    final startText = start != null ? start.toLocal().toString().split(' ').first : '상시';
    final endText = end != null ? end.toLocal().toString().split(' ').first : '미정';
    return '$startText ~ $endText';
  }

  Future<BookmarkFolder?> _pickFolder(BuildContext context) {
    return showModalBottomSheet<BookmarkFolder>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: BookmarkFolder.values
                .map(
                  (folder) => ListTile(
                    title: Text(folder.label),
                    onTap: () => Navigator.of(context).pop(folder),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _sharePolicy(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    _showSnack(context, '링크가 복사되었습니다. 원하는 채팅 앱에 붙여넣어 공유하세요.');
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  const _DetailSectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, index) => Container(
        height: index == 0 ? 120 : 150,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
