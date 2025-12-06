import 'package:flutter/material.dart';

class CompareEntryBar extends StatelessWidget {
  const CompareEntryBar({
    super.key,
    required this.itemCount,
    required this.onOpenCompare,
    this.onClear,
    this.margin,
  });

  /// 비교에 담긴 정책 개수
  final int itemCount;

  /// 비교 화면으로 진입
  final VoidCallback onOpenCompare;

  /// 선택 초기화 (선택적인 콜백)
  final VoidCallback? onClear;

  /// 바깥 여백 (선택)
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, -2),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // 왼쪽: 선택 개수 & 안내 문구
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '비교할 정책 $itemCount개',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '최대 5개까지 선택할 수 있어요.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (onClear != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              height: 36,
              child: TextButton(
                onPressed: onClear,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('비우기'),
              ),
            ),
          ],

          const SizedBox(width: 12),

          // 오른쪽: "비교하기" 버튼
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: onOpenCompare,
              icon: const Icon(Icons.table_chart_outlined, size: 18),
              label: const Text('비교하기'),
              style: FilledButton.styleFrom(
                // ❗ 핵심: width에 double.infinity 사용 금지
                //  - Row 안이기 때문에, 폭이 "unconstrained" 상태임
                //  - 여기서 Infinity를 요구하면 지금 같은 에러 발생
                minimumSize: const Size(0, 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
