import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transition fade + slide légère pour les pages fullscreen.
CustomTransitionPage<T> fadeSlidePage<T>({
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 280),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
