import 'package:flutter/material.dart';

import '../../policy_new/data/mappers/youth_center_mapper.dart';
import '../../policy_new/presentation/map/youth_center_map_provider.dart';
import 'center_card_item.dart';

class CenterListBottomSheet extends StatelessWidget {
  const CenterListBottomSheet({
    super.key,
    required this.centers,
    required this.radiusKm,
    required this.onCenterTap,
    required this.status,
    this.errorMessage,
    this.onRetry,
  });

  final List<CenterMarkerPoint> centers;
  final double radiusKm;
  final void Function(CenterMarkerPoint center, int index) onCenterTap;
  final YouthCenterMapStatus status;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paddingBottom = MediaQuery.of(context).padding.bottom + 12;

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: paddingBottom),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.9),
              ],
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 220,
              maxHeight: 260,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _buildRadiusPill(context, radiusKm, colors.primary),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (status) {
      case YouthCenterMapStatus.loading:
        return const Center(
          child: Text('주변 센터 정보를 불러오는 중입니다.'),
        );
      case YouthCenterMapStatus.empty:
        return const Center(
          child: Text('반경 20km 내 센터가 없습니다.'),
        );
      case YouthCenterMapStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorMessage ?? '센터 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              if (onRetry != null)
                OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('다시 시도'),
                ),
            ],
          ),
        );
      case YouthCenterMapStatus.initial:
        return const Center(
          child: Text('주변 센터 정보를 불러오는 중입니다.'),
        );
      case YouthCenterMapStatus.loaded:
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: centers.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final center = centers[index];
            return CenterCardItem(
              center: center,
              onTap: () => onCenterTap(center, index),
            );
          },
        );
    }
  }

  Widget _buildRadiusPill(BuildContext context, double radiusKm, Color color) {
    final roundedRadius = radiusKm.round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        '내 위치 기준 반경 ${roundedRadius}km',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
