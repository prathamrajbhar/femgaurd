import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/hormonal_pattern_analyzer.dart';
import '../utils/app_theme.dart';

/// PCOS Pattern Awareness Screen
///
/// This screen provides educational information about PCOS patterns
/// based on the user's logged data. This is for AWARENESS ONLY and
/// does NOT provide medical diagnosis.
class PCOSAwarenessScreen extends StatelessWidget {
  const PCOSAwarenessScreen({super.key});

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

                      // What is PCOS section
                      _buildSectionHeader(
                        context,
                        'What is PCOS?',
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

                      // When to consult a doctor section
                      _buildSectionHeader(
                        context,
                        'When to Consult a Doctor',
                        Icons.medical_services_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildConsultDoctorCard(context),
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
                  colorScheme.tertiary,
                  colorScheme.tertiary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.tertiary.withValues(alpha: 0.3),
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
                  'PCOS Pattern Awareness',
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
            color: colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: colorScheme.tertiary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title, style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildStatusCard(BuildContext context, HormonalPatternResult result) {
    final statusInfo = _getPCOSStatusInfo(result);

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
                'Understanding PCOS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Polycystic Ovary Syndrome (PCOS) is a hormonal condition that may affect the ovaries and overall hormonal balance. '
            'It is typically characterized by more persistent symptoms compared to PCOD.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoPoint(
            context,
            '🔹',
            'PCOS patterns tend to be more persistent',
          ),
          _buildInfoPoint(context, '🔹', 'May involve frequent missed periods'),
          _buildInfoPoint(
            context,
            '🔹',
            'Often associated with multiple symptoms',
          ),
          _buildInfoPoint(
            context,
            '🔹',
            'Higher hormonal imbalance indicators',
          ),
          _buildInfoPoint(context, '🔹', 'May require medical management'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: colorScheme.tertiary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This information is for awareness only. Consult a healthcare provider for proper evaluation.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.tertiary,
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
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${factor.points} pts',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.tertiary,
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

  Widget _buildConsultDoctorCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final consultReasons = [
      _ConsultReason(
        emoji: '📅',
        title: 'Irregular Periods',
        description:
            'Cycles consistently shorter than 21 days or longer than 35 days',
      ),
      _ConsultReason(
        emoji: '⏭️',
        title: 'Missed Periods',
        description: 'Frequently missing periods for 2 or more months',
      ),
      _ConsultReason(
        emoji: '🔴',
        title: 'Persistent Symptoms',
        description:
            'Ongoing symptoms like severe acne, unusual hair growth, or weight changes',
      ),
      _ConsultReason(
        emoji: '😴',
        title: 'Chronic Fatigue',
        description: 'Persistent tiredness that affects daily activities',
      ),
      _ConsultReason(
        emoji: '🩺',
        title: 'Family History',
        description: 'If close family members have PCOS or related conditions',
      ),
      _ConsultReason(
        emoji: '👶',
        title: 'Fertility Concerns',
        description: 'If you are planning pregnancy and have concerns',
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
              const Text('👩‍⚕️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Consider Consulting If...',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'You may benefit from professional consultation if you experience:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...consultReasons.map(
            (reason) => _buildConsultReasonItem(context, reason),
          ),
          const SizedBox(height: 16),
          // Doctor suggestion button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/doctors'),
              icon: Icon(
                Icons.local_hospital_rounded,
                color: colorScheme.tertiary,
              ),
              label: Text(
                'View Healthcare Providers',
                style: TextStyle(color: colorScheme.tertiary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.tertiary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultReasonItem(BuildContext context, _ConsultReason reason) {
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
              color: colorScheme.tertiaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(reason.emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reason.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reason.description,
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

  /// Get status info based on PCOS-specific scoring
  _PCOSStatusInfo _getPCOSStatusInfo(HormonalPatternResult result) {
    if (!result.hasEnoughData) {
      return _PCOSStatusInfo(
        label: 'Insufficient Data',
        description: 'Log more cycle and symptom data to see pattern analysis.',
        color: Colors.grey,
      );
    }

    // PCOS is typically indicated by higher scores (15+)
    if (result.score >= 15) {
      return _PCOSStatusInfo(
        label: 'PCOS-like Pattern',
        description:
            'Multiple persistent indicators suggest patterns commonly associated with PCOS.',
        color: AppColors.statusOrange,
      );
    } else if (result.score >= 9) {
      return _PCOSStatusInfo(
        label: 'Elevated Pattern',
        description:
            'Several indicators present. Pattern suggests possible hormonal variations.',
        color: AppColors.statusYellow,
      );
    } else if (result.score >= 5) {
      return _PCOSStatusInfo(
        label: 'Mild Pattern',
        description:
            'Some indicators observed. Continue monitoring your symptoms.',
        color: AppColors.primary,
      );
    } else {
      return _PCOSStatusInfo(
        label: 'Normal Variation',
        description:
            'Your patterns appear within typical ranges. Keep tracking!',
        color: AppColors.statusGreen,
      );
    }
  }
}

/// Helper class for PCOS status info
class _PCOSStatusInfo {
  final String label;
  final String description;
  final Color color;

  _PCOSStatusInfo({
    required this.label,
    required this.description,
    required this.color,
  });
}

/// Helper class for consult reasons
class _ConsultReason {
  final String emoji;
  final String title;
  final String description;

  _ConsultReason({
    required this.emoji,
    required this.title,
    required this.description,
  });
}
