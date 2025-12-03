import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/filters/policy_filter_ui_state.dart';

class PolicyKeywordSheet extends ConsumerStatefulWidget {
  const PolicyKeywordSheet({super.key});

  @override
  ConsumerState<PolicyKeywordSheet> createState() => _PolicyKeywordSheetState();
}

class _PolicyKeywordSheetState extends ConsumerState<PolicyKeywordSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final ui = ref.read(policyFilterUiStateProvider);
    _controller = TextEditingController(text: ui.keyword);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '검색어 입력',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '검색어를 입력하세요',
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSubmit,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onSubmit(_controller.text),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit(String value) {
    ref.read(policyFilterUiStateProvider.notifier).setKeyword(value.trim());
    Navigator.of(context).pop();
  }
}
