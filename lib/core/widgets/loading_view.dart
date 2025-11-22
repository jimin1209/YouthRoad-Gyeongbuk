import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message, this.fullscreen = false});

  final String? message;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 48,
          width: 48,
          child: CircularProgressIndicator(),
        ),
        if (message != null) ...[
          const SizedBox(height: 12),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );

    if (fullscreen) {
      return Center(child: child);
    }
    return child;
  }
}
