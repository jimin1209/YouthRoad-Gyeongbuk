import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/notifiers/region_notifier.dart';
import 'region_chip.dart';

class RegionSelectorSection extends ConsumerWidget {
  const RegionSelectorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionState = ref.watch(regionProvider);
    final notifier = ref.read(regionProvider.notifier);
    final cities = notifier.availableCities;
    final selectedCity = notifier.selectedCity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '지역 선택',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              notifier.summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('시/군', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          children: [
            RegionChip(
              label: '전체',
              selected: selectedCity == null,
              onTap: notifier.resetCity,
            ),
            ...cities.map(
              (city) => RegionChip(
                label: city,
                selected: city == selectedCity,
                onTap: () => notifier.selectCity(city),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (selectedCity != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('읍/면/동', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                children: notifier.availableDistricts
                    .map(
                      (d) => RegionChip(
                        label: d,
                        selected: notifier.selectedDistrict == d ||
                            (d == '전체' &&
                                (notifier.selectedDistrict == null ||
                                    notifier.selectedDistrict!.isEmpty)),
                        onTap: () => notifier.selectDistrict(
                          d == '전체' ? null : d,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
      ],
    );
  }
}
