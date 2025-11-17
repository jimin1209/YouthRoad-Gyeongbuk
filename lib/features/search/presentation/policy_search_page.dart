import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/policy_search_controller.dart';
import '../../policy/presentation/widgets/policy_card.dart';

class PolicySearchPage extends ConsumerStatefulWidget {
  const PolicySearchPage({super.key});

  @override
  ConsumerState<PolicySearchPage> createState() => _PolicySearchPageState();
}

class _PolicySearchPageState extends ConsumerState<PolicySearchPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(policySearchControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('정책 검색')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '제목/내용을 검색하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref
                        .read(policySearchControllerProvider.notifier)
                        .setParams(PolicySearchParams(query: _controller.text));
                  },
                ),
              ),
              onSubmitted: (_) {
                ref
                    .read(policySearchControllerProvider.notifier)
                    .setParams(PolicySearchParams(query: _controller.text));
              },
            ),
          ),
          Expanded(
            child: results.when(
              data: (policies) => ListView.builder(
                itemCount: policies.length,
                itemBuilder: (context, index) =>
                    PolicyCard(policy: policies[index]),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('검색 실패: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
