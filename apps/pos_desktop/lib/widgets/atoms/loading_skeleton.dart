import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_spacing.dart';

/// Bloc shimmer réutilisable pour les états de chargement.
class LoadingSkeletonBox extends StatelessWidget {
  const LoadingSkeletonBox({
    super.key,
    this.height = 48,
    this.width,
    this.borderRadius = 12,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms);
  }
}

/// Liste verticale de skeletons (backoffice, trésorerie, etc.).
class LoadingSkeletonList extends StatelessWidget {
  const LoadingSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 72,
    this.padding = const EdgeInsets.all(AppSpacing.l),
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
      itemBuilder: (_, __) => LoadingSkeletonBox(height: itemHeight),
    );
  }
}

/// Grille de skeletons (produits, KDS).
class LoadingSkeletonGrid extends StatelessWidget {
  const LoadingSkeletonGrid({
    super.key,
    this.crossAxisCount = 3,
    this.itemCount = 6,
    this.aspectRatio = 0.68,
    this.padding = const EdgeInsets.all(AppSpacing.m),
  });

  final int crossAxisCount;
  final int itemCount;
  final double aspectRatio;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.m,
        crossAxisSpacing: AppSpacing.m,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => const LoadingSkeletonBox(height: double.infinity),
    );
  }
}
