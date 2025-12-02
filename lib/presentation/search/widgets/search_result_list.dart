// FILE: lib/presentation/search/widgets/search_result_list.dart

import 'package:flutter/material.dart';

import '../../../domain/search/entities/search_category.dart';
import '../../../domain/search/entities/search_result_item.dart';
import '../viewmodels/search_result_viewmodel.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.items,
    this.onItemTap,
  });

  final List<SearchResultItem> items;
  final ValueChanged<SearchResultItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final viewModel =
            SearchResultViewModel.fromDomain(items[index]);
        return ListTile(
          title: Text(viewModel.title),
          subtitle: viewModel.subtitle != null
              ? Text(viewModel.subtitle!)
              : null,
          leading: _categoryIcon(viewModel.category),
          trailing: viewModel.region != null
              ? Text(
                  viewModel.region!,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : null,
          onTap: () => onItemTap?.call(items[index]),
        );
      },
    );
  }

  Widget _categoryIcon(SearchCategory category) {
    switch (category) {
      case SearchCategory.policy:
        return const Icon(Icons.assignment_outlined);
      case SearchCategory.institution:
        return const Icon(Icons.apartment_outlined);
      case SearchCategory.region:
        return const Icon(Icons.map_outlined);
      case SearchCategory.all:
        return const Icon(Icons.search);
    }
  }
}
