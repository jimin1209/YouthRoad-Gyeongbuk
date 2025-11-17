import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/controller/policy_list_controller.dart';
import '../controller/policy_search_controller.dart';
import '../../policy/controller/policy_metadata_providers.dart';
import '../../region/providers/providers.dart';
import '../../policy/presentation/widgets/policy_card.dart';

class PolicySearchPage extends ConsumerStatefulWidget {
  const PolicySearchPage({super.key});

  @override
  ConsumerState<PolicySearchPage> createState() => _PolicySearchPageState();
}

class _PolicySearchPageState extends ConsumerState<PolicySearchPage> {
  final _controller = TextEditingController();
  String? _selectedRegion;
  String? _selectedStatus;
  final Set<String> _selectedCategories = <String>{};

  @override
  void initState() {
    super.initState();
    final filter = ref.read(filterStateProvider);
    _selectedRegion = filter.region;
    _selectedStatus = filter.status;
    _selectedCategories.addAll(filter.categories);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final params = PolicySearchParams(
      query: _controller.text.trim(),
      region: _selectedRegion,
      categories: _selectedCategories.toList(),
      status: _selectedStatus,
    );
    ref.read(policySearchControllerProvider.notifier).setParams(params);
    final notifier = ref.read(filterStateProvider.notifier);
    notifier.state = notifier.state.copyWith(
      region: _selectedRegion,
      categories: _selectedCategories.toList(),
      status: _selectedStatus,
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(policySearchControllerProvider);
    final regions = ref.watch(regionListProvider);
    final categories = ref.watch(categoryListProvider);
    final statusOptions = const {
      'OPEN': '모집중',
      'CLOSED': '마감',
      'UPCOMING': '예정',
    };
    final normalizedStatus =
        _selectedStatus != null && statusOptions.containsKey(_selectedStatus)
            ? _selectedStatus
            : null;
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
                  onPressed: _submitSearch,
                ),
              ),
              onSubmitted: (_) => _submitSearch(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                regions.when(
                  data: (items) {
                    final regionValue =
                        items.any((region) => region.code == _selectedRegion)
                            ? _selectedRegion
                            : null;
                    return DropdownButtonFormField<String?>(
                      value: regionValue,
                      decoration: const InputDecoration(labelText: '지역'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String?>(value: null, child: Text('전체')),
                        ...items.map(
                          (region) => DropdownMenuItem(
                            value: region.code,
                            child: Text(region.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _selectedRegion = value),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('지역 정보를 불러오지 못했습니다: $e'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: normalizedStatus,
                  decoration: const InputDecoration(labelText: '상태'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('전체')),
                    ...statusOptions.entries.map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _selectedStatus = value),
                ),
                const SizedBox(height: 12),
                Text('관심 분야', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                categories.when(
                  data: (items) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((category) {
                      final selected = _selectedCategories.contains(category.code);
                      return FilterChip(
                        label: Text(category.name),
                        selected: selected,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _selectedCategories.add(category.code);
                            } else {
                              _selectedCategories.remove(category.code);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('카테고리를 불러오지 못했습니다: $e'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedRegion = null;
                        _selectedStatus = null;
                        _selectedCategories.clear();
                      });
                      final notifier = ref.read(filterStateProvider.notifier);
                      notifier.state = PolicyFilter.initial();
                    },
                    child: const Text('필터 초기화'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('검색하기'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: results.when(
              data: (policies) => policies.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
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
