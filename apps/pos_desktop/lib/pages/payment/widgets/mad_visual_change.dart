import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_spacing.dart';

/// Un composant visuel affichant graphiquement les billets et pièces de monnaie MAD.
class MadVisualChange extends StatelessWidget {
  const MadVisualChange({super.key, required this.breakdown});

  final List<MadBreakdownEntry> breakdown;

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) return const SizedBox.shrink();

    // Sépare les billets et les pièces pour un affichage structuré
    final banknotes = breakdown.where((e) => !e.denomination.isCoin).toList();
    final coins = breakdown.where((e) => e.denomination.isCoin).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (banknotes.isNotEmpty) ...[
          Text(
            'Billets à rendre',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.m,
            runSpacing: AppSpacing.m,
            children: [
              for (final entry in banknotes)
                _DenominationVisual(entry: entry),
            ],
          ),
          if (coins.isNotEmpty) const SizedBox(height: AppSpacing.m),
        ],
        if (coins.isNotEmpty) ...[
          Text(
            'Pièces à rendre',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.m,
            runSpacing: AppSpacing.m,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final entry in coins)
                _DenominationVisual(entry: entry),
            ],
          ),
        ],
      ],
    );
  }
}

class _DenominationVisual extends StatelessWidget {
  const _DenominationVisual({required this.entry});

  final MadBreakdownEntry entry;

  @override
  Widget build(BuildContext context) {
    final denom = entry.denomination;
    final isCoin = denom.isCoin;

    Widget child;
    if (isCoin) {
      child = _buildCoin(context, denom);
    } else {
      child = _buildBanknote(context, denom);
    }

    return Badge(
      label: Text(
        '${entry.count}x',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      largeSize: 20,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: child,
    );
  }

  Widget _buildBanknote(BuildContext context, MadDenomination denom) {
    final gradient = _getBanknoteGradient(denom.valueDh);
    return Container(
      width: 120,
      height: 64,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Cadre intérieur du billet
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          // Filigrane/motif en arrière-plan (Simulé)
          Positioned(
            right: 8,
            top: 8,
            bottom: 8,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.star_half_outlined,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),
          // Valeur principale au centre
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${denom.valueDh.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                    height: 1.1,
                    shadows: [
                      Shadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 1)),
                    ],
                  ),
                ),
                const Text(
                  'DIRHAMS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Petite valeur en haut à gauche
          Positioned(
            top: 8,
            left: 8,
            child: Text(
              '${denom.valueDh.toInt()}',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ),
          // Petite valeur en bas à droite
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              '${denom.valueDh.toInt()}',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoin(BuildContext context, MadDenomination denom) {
    final isBimetallic = denom.valueDh == 10 || denom.valueDh == 5;
    final size = denom.valueDh >= 5 ? 56.0 : 48.0;

    if (isBimetallic) {
      // 10 DH et 5 DH: Bicolores (or/argent ou argent/or)
      final outerColor = denom.valueDh == 10 ? const Color(0xFFCFD8DC) : const Color(0xFFFFD54F);
      final innerColor = denom.valueDh == 10 ? const Color(0xFFFFD54F) : const Color(0xFFCFD8DC);

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [outerColor, outerColor.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 3,
              offset: const Offset(0, 1.5),
            ),
          ],
          border: Border.all(color: Colors.black26, width: 0.5),
        ),
        padding: EdgeInsets.all(size * 0.16),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [innerColor, innerColor.withValues(alpha: 0.8)],
            ),
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
          alignment: Alignment.center,
          child: Text(
            '${denom.valueDh.toInt()}',
            style: TextStyle(
              color: denom.valueDh == 10 ? const Color(0xFF5D4037) : const Color(0xFF37474F),
              fontWeight: FontWeight.w900,
              fontSize: size * 0.28,
            ),
          ),
        ),
      );
    } else {
      // Autre pièces: argentées ou cuivrées
      final isSilver = denom.valueDh >= 0.5;
      final coinColor = isSilver ? const Color(0xFFECEFF1) : const Color(0xFFFFCC80);
      final textColor = isSilver ? const Color(0xFF455A64) : const Color(0xFF5D4037);

      String valText;
      if (denom.valueDh == 0.5) {
        valText = '½';
      } else if (denom.valueDh == 0.2) {
        valText = '0.2';
      } else if (denom.valueDh == 0.1) {
        valText = '0.1';
      } else {
        valText = '${denom.valueDh.toInt()}';
      }

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [coinColor, coinColor.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 3,
              offset: const Offset(0, 1.5),
            ),
          ],
          border: Border.all(color: Colors.black26, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          valText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.35,
          ),
        ),
      );
    }
  }

  LinearGradient _getBanknoteGradient(double value) {
    return switch (value.toInt()) {
      200 => const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      100 => const LinearGradient(
          colors: [Color(0xFF5D4037), Color(0xFF8D6E63), Color(0xFFA1887F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      50 => const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      20 => const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0), Color(0xFFE040FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      _ => const LinearGradient(
          colors: [Color(0xFF78909C), Color(0xFF90A4AE), Color(0xFFB0BEC5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
    };
  }
}
