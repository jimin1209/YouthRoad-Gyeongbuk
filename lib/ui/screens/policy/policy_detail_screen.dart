import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../application/providers.dart';
import '../../../domain/entities/policy.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/policy_card_v2.dart';
import '../../widgets/policy_detail_metadata.dart';

class PolicyDetailScreen extends ConsumerStatefulWidget {
  const PolicyDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends ConsumerState<PolicyDetailScreen> {
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(policyDetailProvider.notifier).load(widget.id);
      final memo = ref.read(memoProvider)[widget.id];
      _memoController.text = memo ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(policyDetailProvider);
    final favorites = ref.watch(favoritesProvider);

    final policy = detailState.policy;

    return Scaffold(
      appBar: AppAppBar(title: '정책 상세 ${widget.id}'),
      body: policy == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          policy.title,
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
                      IconButton(
                        icon: const Icon(Icons.balance),
                        onPressed: () =>
                            ref.read(compareProvider.notifier).add(policy.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(policy.summary),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: policy.tags.map((t) => Chip(label: Text(t))).toList(),
                  ),
                  const SizedBox(height: 12),
                  PolicyDetailMetadata(policy: policy),
                  const Divider(height: 32),
                  Text('유사 정책', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (detailState.similar.isEmpty)
                    const Text('추천할 정책이 없어도 기본 정책을 보여드릴게요.'),
                  ...detailState.similar
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: PolicyCardV2(policy: p),
                        ),
                      )
                      .toList(),
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
                    onPressed: () {
                      ref
                          .read(memoProvider.notifier)
                          .save(policy.id, _memoController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('메모가 저장되었습니다.')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('메모 저장'),
                  ),
                  const Divider(height: 32),
                  FilledButton.icon(
                    onPressed: () => _openWebviewDialog(context, policy),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('관련 웹뷰 열기'),
                  ),
                ],
              ),
            ),
    );
  }

  void _openWebviewDialog(BuildContext context, Policy policy) {
    final url = policy.policyUrl;

    if (url == null || url.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(policy.title),
          content: const Text('정책 상세 웹페이지 정보를 찾을 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        final loadingNotifier = ValueNotifier<bool>(true);
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) => loadingNotifier.value = false,
            ),
          )
          ..loadRequest(Uri.parse(url));

        return AlertDialog(
          title: Text(policy.title),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.85,
            height: 420,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                ValueListenableBuilder<bool>(
                  valueListenable: loadingNotifier,
                  builder: (context, isLoading, _) {
                    if (!isLoading) return const SizedBox.shrink();
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
