import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/ui_reaction_controller.dart';
import '../../application/filters/policy_filter_ui_state.dart';
import '../../application/providers.dart';
import '../../domain/values/policy_feed_type.dart';

class PolicyKeywordSheet extends ConsumerStatefulWidget {
  const PolicyKeywordSheet({
    super.key,
    this.feedType = PolicyFeedType.search,
  });

  final PolicyFeedType feedType;

  @override
  ConsumerState<PolicyKeywordSheet> createState() => _PolicyKeywordSheetState();
}

class _PolicyKeywordSheetState extends ConsumerState<PolicyKeywordSheet> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final ui = ref.read(policyFilterUiStateProvider);
    _controller = TextEditingController(text: ui.keyword);
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
                onChanged: _onChanged,
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
    _debounce?.cancel();
    _applyKeyword(value);
    Navigator.of(context).pop();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _applyKeyword(value);
    });
  }

  void _applyKeyword(String value) {
    final keyword = value.trim();
    final prev = ref.read(policyFilterUiStateProvider).keyword;
    ref.read(policyFilterUiStateProvider.notifier).setKeyword(keyword);

    final reaction =
        ref.read(uiReactionControllerProvider(widget.feedType).notifier);
    if (prev == keyword) {
      reaction.markUnchanged(ref.read(policyQueryProvider(widget.feedType)).hash);
    } else {
      reaction.markSearchConfirmed(keyword);
    }
  }
}
