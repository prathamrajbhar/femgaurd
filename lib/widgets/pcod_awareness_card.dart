import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/hormonal_pattern_analyzer.dart';
import '../utils/app_theme.dart';

/// PCOD/PCOS Risk Awareness Card Widget
///
/// This widget displays hormonal pattern analysis results for awareness purposes only.
/// It does NOT provide medical diagnosis.
class PCODAwarenessCard extends StatelessWidget {
  const PCODAwarenessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final result = HormonalPatternAnalyzer.analyze(
          cycleHistory: appState.cycleHistory,
          symptomLogs: appState.symptomLogs,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            _buildSectionHeader(context),
            const SizedBox(height: 14),

            // Main Analysis Card
            _buildMainCard(context, result, colorScheme),

            if (result.hasEnoughData &&
                result.contributingFactors.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildFactorsCard(context, result),
            ],

            const SizedBox(height: 16),

            // Mandatory Disclaimer
            _buildDisclaimer(context),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.health_and_safety_rounded,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Text('PCOD / PCOS Awareness', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    HormonalPatternResult result,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Score indicator
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getScoreColor(
                    result.score,
                    colorScheme,
                  ).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Center(
                  child: result.hasEnoughData
                      ? Text(
                          '${result.score}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: _getScoreColor(result.score, colorScheme),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(
                          Icons.hourglass_empty_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.riskLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: result.hasEnoughData
                            ? _getScoreColor(result.score, colorScheme)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (result.hasEnoughData)
                      _buildScoreIndicator(result.score, colorScheme),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            result.riskDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Navigation buttons to detailed awareness screens
          _buildNavigationButtons(context, result),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    HormonalPatternResult result,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/pcod-awareness'),
            icon: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
            label: Text(
              'View PCOD Awareness',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/pcos-awareness'),
            icon: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: colorScheme.tertiary,
            ),
            label: Text(
              'View PCOS Awareness',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colorScheme.tertiary.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreIndicator(int score, ColorScheme colorScheme) {
    // Max expected score is around 20
    final normalizedScore = (score / 20).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: normalizedScore,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              _getScoreColor(score, colorScheme),
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildFactorsCard(BuildContext context, HormonalPatternResult result) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.list_alt_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Contributing Factors',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.contributingFactors.map(
            (factor) => _buildFactorItem(context, factor),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorItem(BuildContext context, ContributingFactor factor) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(factor.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      factor.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${factor.points}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  factor.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This assessment is for health awareness only and does not replace medical consultation.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get color based on score - uses theme-adaptive colors
  Color _getScoreColor(int score, ColorScheme colorScheme) {
    if (score >= 15) {
      return colorScheme.tertiary;
    } else if (score >= 9) {
      return colorScheme.secondary;
    } else if (score >= 5) {
      return colorScheme.primary;
    } else {
      return AppColors.statusGreen;
    }
  }
}
