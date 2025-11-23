import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/notifiers/institution_notifier.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';

class InstitutionListScreen extends ConsumerStatefulWidget {
  const InstitutionListScreen({super.key});

  @override
  ConsumerState<InstitutionListScreen> createState() => _InstitutionListScreenState();
}

class _InstitutionListScreenState extends ConsumerState<InstitutionListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    ref.read(institutionNotifierProvider.notifier).search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(institutionNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(title: '기관 목록'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '기관명을 검색하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          Expanded(
            child: state.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('검색 결과가 없습니다.'));
                }
                return ListView.separated(
                  itemBuilder: (_, i) {
                    final inst = items[i];
                    return ListTile(
                      title: Text(inst.name),
                      subtitle: Text('instNo: ${inst.id}'),
                      onTap: () => context.push('/inst/${inst.id}/dept/list'),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: items.length,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => GlobalErrorView(
                message: '불러오지 못했습니다. 다시 시도해 주세요.',
                onRetry: () => ref.invalidate(institutionNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
