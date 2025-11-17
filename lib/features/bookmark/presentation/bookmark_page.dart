import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/bookmark_controller.dart';
import '../../policy/presentation/widgets/policy_card.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: bookmarks.isEmpty
          ? const Center(child: Text('북마크한 정책이 없습니다.'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final policy = bookmarks[index];
                return PolicyCard(policy: policy);
              },
            ),
    );
  }
}
