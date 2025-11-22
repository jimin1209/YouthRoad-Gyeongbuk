import 'package:flutter/material.dart';

/// 정책 카드/상세에서 사용하는 비교함 담기 버튼 (UI-only).
class PolicyCompareButton extends StatefulWidget {
  const PolicyCompareButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<PolicyCompareButton> createState() => _PolicyCompareButtonState();
}

class _PolicyCompareButtonState extends State<PolicyCompareButton> {
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: () {
        setState(() => _added = !_added);
        widget.onTap?.call();
      },
      icon: Icon(Icons.compare_arrows, color: _added ? scheme.primary : null),
      label: Text(_added ? '비교함 담김' : '비교함 담기'),
    );
  }
}
