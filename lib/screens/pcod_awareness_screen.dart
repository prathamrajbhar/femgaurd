import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/hormonal_pattern_analyzer.dart';
import '../utils/app_theme.dart';

/// PCOD Pattern Awareness Screen
///
/// This screen provides educational information about PCOD patterns
/// based on the user's logged data. This is for AWARENESS ONLY and
/// does NOT provide medical diagnosis.
class PCODAwarenessScreen extends StatelessWidget {
  const PCODAwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final result = HormonalPatternAnalyzer.analyze(
            cycleHistory: appState.cycleHistory,
            symptomLogs: appState.symptomLogs,
          );

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(child: _buildHeader(context)),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Status Badge Card
                      _buildStatusCard(context, result),
                      const SizedBox(height: 24),

                      // What is PCOD section
                      _buildSectionHeader(
                        context,
                        'What is PCOD?',
                        Icons.help_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildExplanationCard(context),
                      const SizedBox(height: 24),

                      // Why this result section (if data available)
                      if (result.hasEnoughData &&
                          result.contributingFactors.isNotEmpty) ...[
                        _buildSectionHeader(
                          context,
                          'Why This Result?',
                          Icons.analytics_rounded,
                        ),
                        const SizedBox(height: 14),
                        _buildContributingFactorsCard(context, result),
                        const SizedBox(height: 24),
                      ],

                      // Lifestyle Tips section
                      _buildSectionHeader(
                        context,
                        'Lifestyle Improvement Tips',
                        Icons.favorite_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildLifestyleTipsCard(context),
                      const SizedBox(height: 24),

                      // Disclaimer (MANDATORY)
                      _buildDisclaimer(context),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PCOD Pattern Awareness',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Health awareness information',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, HormonalPatternResult result) {
    final statusInfo = _getPCODStatusInfo(result);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [statusInfo.color, statusInfo.color.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: statusInfo.color.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Center(
              child: result.hasEnoughData
                  ? Text(
                      '${result.score}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.hourglass_empty_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pattern Status',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusInfo.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📖', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Understanding PCOD',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Polycystic Ovarian Disease (PCOD) is a common condition affecting the ovaries. '
            'It may involve irregular menstrual cycles and hormonal imbalances.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoPoint(
            context,
            '🔹',
            'PCOD patterns are typically mild to moderate',
          ),
          _buildInfoPoint(
            context,
            '🔹',
            'Often involves irregular menstrual cycles',
          ),
          _buildInfoPoint(
            context,
            '🔹',
            'May be managed with lifestyle changes',
          ),
          _buildInfoPoint(context, '🔹', 'Affects hormonal balance in women'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This information is for awareness only. Consult a healthcare provider for proper evaluation.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(BuildContext context, String emoji, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributingFactorsCard(
    BuildContext context,
    HormonalPatternResult result,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Contributing Factors',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Based on your logged data, these patterns were observed:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...result.contributingFactors.map(
            (factor) => _buildFactorItem(context, factor),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorItem(BuildContext context, ContributingFactor factor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(factor.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${factor.points} pts',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  factor.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleTipsCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tips = [
      _LifestyleTip(
        emoji: '🥗',
        title: 'Balanced Diet',
        description: 'Focus on whole foods, vegetables, and lean proteins',
      ),
      _LifestyleTip(
        emoji: '🏃‍♀️',
        title: 'Regular Exercise',
        description: 'Aim for 30 minutes of moderate activity daily',
      ),
      _LifestyleTip(
        emoji: '😴',
        title: 'Quality Sleep',
        description: 'Maintain 7-8 hours of consistent sleep',
      ),
      _LifestyleTip(
        emoji: '🧘',
        title: 'Stress Management',
        description: 'Practice relaxation techniques like yoga or meditation',
      ),
      _LifestyleTip(
        emoji: '💧',
        title: 'Stay Hydrated',
        description: 'Drink adequate water throughout the day',
      ),
      _LifestyleTip(
        emoji: '📝',
        title: 'Track Regularly',
        description: 'Log symptoms and cycles for better awareness',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💪', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Healthy Habits',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'These lifestyle changes may help support hormonal balance:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => _buildTipItem(context, tip)),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, _LifestyleTip tip) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(tip.emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 22,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 10),
              Text(
                'Important Disclaimer',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'This information is for health awareness only and does not replace professional medical advice. '
            'The patterns shown are based on your logged data and do not constitute a medical diagnosis. '
            'Always consult a qualified healthcare provider for proper evaluation and treatment.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Get status info based on PCOD-specific scoring
  _PCODStatusInfo _getPCODStatusInfo(HormonalPatternResult result) {
    if (!result.hasEnoughData) {
      return _PCODStatusInfo(
        label: 'Insufficient Data',
        description: 'Log more cycle and symptom data to see pattern analysis.',
        color: Colors.grey,
      );
    }

    // PCOD is typically mild to moderate (score 5-14)
    if (result.score >= 15) {
      return _PCODStatusInfo(
        label: 'Strong Pattern',
        description:
            'Multiple indicators suggest patterns that may warrant professional consultation.',
        color: AppColors.statusOrange,
      );
    } else if (result.score >= 9) {
      return _PCODStatusInfo(
        label: 'Possible PCOD Pattern',
        description:
            'Several indicators suggest possible hormonal variations. Consider tracking more.',
        color: AppColors.statusYellow,
      );
    } else if (result.score >= 5) {
      return _PCODStatusInfo(
        label: 'Mild Pattern',
        description:
            'Some indicators present. Continue monitoring and maintain healthy habits.',
        color: AppColors.primary,
      );
    } else {
      return _PCODStatusInfo(
        label: 'Normal Variation',
        description:
            'Your patterns appear within typical ranges. Keep tracking!',
        color: AppColors.statusGreen,
      );
    }
  }
}

/// Helper class for PCOD status info
class _PCODStatusInfo {
  final String label;
  final String description;
  final Color color;

  _PCODStatusInfo({
    required this.label,
    required this.description,
    required this.color,
  });
}

/// Helper class for lifestyle tips
class _LifestyleTip {
  final String emoji;
  final String title;
  final String description;

  _LifestyleTip({
    required this.emoji,
    required this.title,
    required this.description,
  });
}
