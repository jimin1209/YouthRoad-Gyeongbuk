import 'package:flutter/material.dart';

class YouthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const YouthAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            )
          : null,
      title: Text(title),
      centerTitle: true,
      actions: actions,
    );
  }
}
