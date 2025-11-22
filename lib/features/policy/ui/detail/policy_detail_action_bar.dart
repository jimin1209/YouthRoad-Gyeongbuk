import 'package:flutter/material.dart';

/// 상세 액션을 상단 한 줄로 모은 UI (mock 상태 토글).
class PolicyDetailActionBar extends StatefulWidget {
  const PolicyDetailActionBar({
    super.key,
    this.onFavorite,
    this.onApplied,
    this.onOpenWeb,
    this.onShare,
    this.onCompare,
  });

  final VoidCallback? onFavorite;
  final VoidCallback? onApplied;
  final VoidCallback? onOpenWeb;
  final VoidCallback? onShare;
  final VoidCallback? onCompare;

  @override
  State<PolicyDetailActionBar> createState() => _PolicyDetailActionBarState();
}

class _PolicyDetailActionBarState extends State<PolicyDetailActionBar> {
  bool _fav = false;
  bool _applied = false;
  bool _compared = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(
              icon: _fav ? Icons.favorite : Icons.favorite_border,
              label: '즐겨찾기',
              color: _fav ? scheme.primary : null,
              onTap: () {
                setState(() => _fav = !_fav);
                widget.onFavorite?.call();
              },
            ),
            _item(
              icon: _applied ? Icons.task_alt : Icons.check_circle_outline,
              label: '신청했어요',
              color: _applied ? scheme.secondary : null,
              onTap: () {
                setState(() => _applied = !_applied);
                widget.onApplied?.call();
              },
            ),
            _item(icon: Icons.link, label: '웹뷰', onTap: widget.onOpenWeb),
            _item(icon: Icons.ios_share, label: '공유', onTap: widget.onShare),
            _item(
              icon: Icons.compare_arrows,
              label: _compared ? '비교함 담김' : '비교함',
              color: _compared ? scheme.primary : null,
              onTap: () {
                setState(() => _compared = !_compared);
                widget.onCompare?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onTap, icon: Icon(icon, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
