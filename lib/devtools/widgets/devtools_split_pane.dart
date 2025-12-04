import 'package:flutter/material.dart';

class DevtoolsSplitPane extends StatelessWidget {
  const DevtoolsSplitPane({
    super.key,
    required this.list,
    required this.detail,
    this.leftWidth = 160,
  });

  final Widget list;
  final Widget detail;
  final double leftWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: leftWidth,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                right: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: list,
          ),
        ),
        Expanded(
          child: ClipRect(
            child: detail,
          ),
        ),
      ],
    );
  }
}
