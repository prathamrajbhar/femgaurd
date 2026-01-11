import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/insights_engine.dart';
import '../utils/app_theme.dart';
import 'daily_logging_screen.dart';

/// Insights-driven home page that replaces the passive dashboard
/// Shows active health insights, predictions, and cycle phase information
class InsightsHomePage extends StatefulWidget {
  const InsightsHomePage({super.key});

  @override
  State<InsightsHomePage> createState() => _InsightsHomePageState();
}

class _InsightsHomePageState extends State<InsightsHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final cycleDay = appState.currentCycleDay;
        final cycleLength = appState.userProfile.cycleLength;
        final phase = InsightsEngine.getCurrentPhase(cycleDay, cycleLength);
        final insights = InsightsEngine.generateInsights(
          appState.cycleHistory,
          appState.symptomLogs,
          cycleDay,
          cycleLength,
        );
        final predictions = InsightsEngine.getTodayPredictions(
          phase,
          appState.symptomLogs.take(7).toList(),
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryLight.withValues(alpha: 0.3),
                AppColors.background,
                AppColors.background,
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Greeting with supportive message
                      _buildGreetingSection(phase),
                      const SizedBox(height: 20),

                      // Cycle Phase Hero Card
                      _CyclePhaseHeroCard(
                        phase: phase,
                        cycleDay: cycleDay,
                        cycleLength: cycleLength,
                        daysUntilPeriod: InsightsEngine.getDaysUntilPeriod(cycleDay, cycleLength),
                      ),
                      const SizedBox(height: 20),

                      // Quick Log Button
                      _buildQuickLogButton(),
                      const SizedBox(height: 24),

                      // Today's Predictions
                      if (predictions.isNotEmpty) ...[
                        _buildSectionHeader('What You Might Feel Today', '🌟'),
                        const SizedBox(height: 12),
                        _buildPredictionsCard(predictions),
                        const SizedBox(height: 24),
                      ],

                      // Health Insights
                      if (insights.isNotEmpty) ...[
                        _buildSectionHeader('Your Insights', '💡'),
                        const SizedBox(height: 12),
                        ...insights.map((insight) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _InsightCard(insight: insight),
                        )),
                        const SizedBox(height: 16),
                      ],

                      // Self-Care Tips for Phase
                      _buildSectionHeader('Self-Care Tips', '💜'),
                      const SizedBox(height: 12),
                      _buildSelfCareTipsCard(phase),
                      const SizedBox(height: 24),

                      // Quick Actions
                      _buildSectionHeader('Quick Actions', '⚡'),
                      const SizedBox(height: 12),
                      _buildQuickActionsGrid(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text('🌸', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FemGuard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Your health companion',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.softShadow,
          ),
          child: IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textSecondary,
                  size: 26,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection(CyclePhase phase) {
    final greeting = InsightsEngine.getTimeBasedGreeting();
    final supportMessage = InsightsEngine.getSupportiveMessage(phase);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          supportMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DailyLoggingScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent,
              AppColors.accent.withValues(alpha: 0.85),
              AppColors.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log How You Feel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Takes just 30 seconds',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionsCard(List<String> predictions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: predictions.map((prediction) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prediction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSelfCareTipsCard(CyclePhase phase) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.15),
            AppColors.primaryLight.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(phase.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                phase.displayName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...phase.selfCareTips.take(3).map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✓', style: TextStyle(color: Colors.green)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/health-tips'),
            child: Text(
              'See all tips →',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      ('📅', 'Calendar', '/calendar', const Color(0xFFE91E63)),
      ('📊', 'Reports', '/reports', const Color(0xFF4CAF50)),
      ('🩺', 'Insights', '/insights', const Color(0xFF2196F3)),
      ('💡', 'Tips', '/health-tips', const Color(0xFFFF9800)),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pushNamed(context, action.$3);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: action.$4.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: action.$4.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: action.$4.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(action.$1, style: const TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action.$2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Cycle Phase Hero Card
class _CyclePhaseHeroCard extends StatelessWidget {
  final CyclePhase phase;
  final int cycleDay;
  final int cycleLength;
  final int daysUntilPeriod;

  const _CyclePhaseHeroCard({
    required this.phase,
    required this.cycleDay,
    required this.cycleLength,
    required this.daysUntilPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getPhaseGradient(),
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getPhaseGradient().first.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Day badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Day',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '$cycleDay',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Phase info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(phase.emoji, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  phase.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            phase.description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Period prediction
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        InsightsEngine.getPeriodLikelihood(daysUntilPeriod),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getPhaseGradient() {
    switch (phase) {
      case CyclePhase.menstrual:
        return [const Color(0xFFE91E63), const Color(0xFFC2185B)];
      case CyclePhase.follicular:
        return [const Color(0xFF4CAF50), const Color(0xFF388E3C)];
      case CyclePhase.ovulatory:
        return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
      case CyclePhase.luteal:
        return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
    }
  }
}

/// Individual Insight Card
class _InsightCard extends StatelessWidget {
  final HealthInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _getSeverityColor().withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getSeverityColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(insight.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (insight.action != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '💡 ${insight.action}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor() {
    switch (insight.severity) {
      case InsightSeverity.info:
        return Colors.blue;
      case InsightSeverity.suggestion:
        return Colors.green;
      case InsightSeverity.attention:
        return Colors.orange;
    }
  }
}
