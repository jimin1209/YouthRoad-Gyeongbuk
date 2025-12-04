import 'package:flutter/material.dart';

class _TransitionPage<T> extends Page<T> {
  const _TransitionPage({
    required LocalKey key,
    required this.child,
    required this.transitionsBuilder,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  }) : super(key: key);

  final Widget child;
  final RouteTransitionsBuilder transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}

Page<T> buildSlideFadePage<T>({
  required LocalKey key,
  required Widget child,
  Duration transitionDuration = const Duration(milliseconds: 260),
  Duration reverseDuration = const Duration(milliseconds: 200),
}) {
  return _TransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeIn,
      );

      final slideAnimation = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      final fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}

Page<T> buildSearchOverlayPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return _TransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
        reverseCurve: Curves.easeIn,
      );

      final slideAnimation = Tween(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(curvedAnimation);

      final fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}
