import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/policy_detail_notifier.dart';
import '../../../application/providers.dart';
import '../../../application/services/memo_repository.dart';
import '../../../application/services/eligibility_service.dart';
import '../../../domain/entities/policy.dart';
import '../../../navigation/route_paths.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';
import '../../widgets/policy_card_v2.dart';
import '../../widgets/policy_detail_metadata.dart';
import '../../widgets/compare_badge.dart';

class PolicyDetailScreen extends ConsumerStatefulWidget {
  const PolicyDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends ConsumerState<PolicyDetailScreen> {
  final TextEditingController _memoController = TextEditingController();
  late final MemoRepository _memoRepository;

  @override
  void initState() {
    super.initState();
    _memoRepository = ref.read(memoRepositoryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
      _memoRepository.loadMemo(widget.id).then((memo) {
        if (!mounted) return;
        _memoController.text = memo ?? '';
      });
    });
  }

  void _loadDetail() {
    if (widget.id.isEmpty) {
      ref.read(policyDetailProvider.notifier).state = const PolicyDetailState(
        isLoading: false,
        error: PolicyDetailNotifier.errorMessage,
      );
      return;
    }
    ref.read(policyDetailProvider.notifier).load(widget.id);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(policyDetailProvider);
    final favorites = ref.watch(favoritesProvider);
    final compareAsync = ref.watch(compareProvider);
    final selectedRegion = ref.watch(regionProvider);

    final policy = detailState.policy;
    final tags = policy?.tags ?? const <String>[];
    final eligibilityText = policy == null
        ? '정보 없음'
        : _mapEligibilityResult(
            EligibilityService().evaluate(
              policy: policy,
              userAge: null,
              userRegion: selectedRegion,
            ),
          );

    Widget buildBody() {
      if (detailState.isLoading && policy == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (detailState.error != null && policy == null) {
        return GlobalErrorView(
          message: PolicyDetailNotifier.errorMessage,
          onRetry: _loadDetail,
        );
      }

      if (policy == null) {
        return GlobalErrorView(
          message: PolicyDetailNotifier.errorMessage,
          onRetry: _loadDetail,
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    policy.policyNm,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    favorites.contains(policy.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () =>
                      ref.read(favoritesProvider.notifier).toggle(policy.id),
                ),
                CompareBadge(
                  child: IconButton(
                    icon: Icon(
                      (compareAsync.valueOrNull ?? [])
                              .any((p) => p.id == policy.id)
                          ? Icons.balance
                          : Icons.balance_outlined,
                    ),
                    onPressed: () =>
                        ref.read(compareProvider.notifier).toggle(policy.id),
                  ),
                ),
              ],
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              buildTagChips(context, tags),
            ],
            const SizedBox(height: 8),
            Text(policy.policyCn ?? '정책 설명이 없습니다.'),
            const SizedBox(height: 12),
            PolicyDetailMetadata(policy: policy),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '지원 가능 여부: $eligibilityText',
              ),
            ),
            if (detailState.similar.isNotEmpty) ...[
              const Divider(height: 32),
              Text('유사 정책', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...detailState.similar.take(3).map(
                (p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: PolicyCardV2(
                    policy: p,
                    onTap: () {
                      if (p.id == policy.id) return;
                      context.push(RoutePaths.policyDetail(p.id));
                    },
                  ),
                ),
              ),
            ],
            const Divider(height: 32),
            Text('상담 메모', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '상담 내용을 메모해 두세요.',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () async {
                final text = _memoController.text;
                if (text.trim().isEmpty) {
                  await _memoRepository.clearMemo(policy.id);
                  _memoController.text = '';
                } else {
                  await _memoRepository.saveMemo(policy.id, text);
                }
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('메모가 저장되었습니다.')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('메모 저장'),
            ),
            const Divider(height: 32),
            FilledButton.icon(
  onPressed: () {
    final url = policy.detailUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
                        content: Text('정책 상세 웹페이지 정보를 찾을 수 없습니다.')),
                  );
                  return;
                }

                context.push(
                  RoutePaths.policyWebview,
                  extra: {
                    'title': policy.policyNm,
                    'url': url,
                  },
                );
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('관련 웹뷰 열기'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: '정책 상세'),
      body: buildBody(),
    );
  }

  String _mapEligibilityResult(EligibilityResult result) {
    switch (result) {
      case EligibilityResult.eligible:
        return 'Y';
      case EligibilityResult.notEligible:
        return 'N';
      case EligibilityResult.unknown:
        return '정보 없음';
    }
  }
}
