import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Cycle history screen showing past menstrual cycles
class CycleHistoryScreen extends StatelessWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final cycleHistory = appState.cycleHistory;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppColors.softShadow,
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Cycle History'),
          ),
          body: cycleHistory.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: [
                    // Summary card
                    _buildSummaryCard(context, appState),
                    // Cycle list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: cycleHistory.length,
                        itemBuilder: (context, index) {
                          final cycle = cycleHistory[index];
                          return _CycleCard(
                            cycle: cycle,
                            cycleNumber: cycleHistory.length - index,
                            averageCycleLength: appState.userProfile.cycleLength,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, AppState appState) {
    final cycleHistory = appState.cycleHistory;
    final avgLength = appState.userProfile.cycleLength;
    final totalCycles = cycleHistory.length;
    
    // Calculate average period length
    int totalPeriodDays = 0;
    int countWithEnd = 0;
    for (final cycle in cycleHistory) {
      if (cycle.endDate != null) {
        totalPeriodDays += cycle.endDate!.difference(cycle.startDate).inDays + 1;
        countWithEnd++;
      }
    }
    final avgPeriodLength = countWithEnd > 0 ? (totalPeriodDays / countWithEnd).round() : 5;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.primaryShadow(0.35),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.insights_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cycle Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Based on your tracked data',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _SummaryItem(
                label: 'Total Cycles',
                value: '$totalCycles',
                icon: Icons.loop_rounded,
              ),
              _SummaryItem(
                label: 'Avg. Cycle',
                value: '$avgLength days',
                icon: Icons.calendar_today_rounded,
              ),
              _SummaryItem(
                label: 'Avg. Period',
                value: '$avgPeriodLength days',
                icon: Icons.water_drop_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.timeline_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Cycle History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your cycle history will appear here once you start tracking',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/cycle-tracking'),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Tracking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary item widget
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cycle card widget
class _CycleCard extends StatelessWidget {
  final dynamic cycle;
  final int cycleNumber;
  final int averageCycleLength;

  const _CycleCard({
    required this.cycle,
    required this.cycleNumber,
    required this.averageCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    final periodLength = cycle.endDate != null
        ? cycle.endDate!.difference(cycle.startDate).inDays + 1
        : null;
    final isRecent = DateTime.now().difference(cycle.startDate).inDays < 30;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.softShadow,
        border: isRecent ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRecent ? AppColors.primaryLight.withValues(alpha: 0.3) : null,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
            child: Row(
              children: [
                // Cycle number badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      '#$cycleNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateRange(cycle.startDate, cycle.endDate),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getTimeAgo(cycle.startDate),
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isRecent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Recent',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _DetailItem(
                  icon: Icons.water_drop_rounded,
                  label: 'Period',
                  value: periodLength != null ? '$periodLength days' : 'Ongoing',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                _DetailItem(
                  icon: Icons.loop_rounded,
                  label: 'Cycle',
                  value: '${cycle.cycleLength} days',
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 16),
                _DetailItem(
                  icon: Icons.compare_arrows_rounded,
                  label: 'vs Avg',
                  value: _getVariation(cycle.cycleLength, averageCycleLength),
                  color: _getVariationColor(cycle.cycleLength, averageCycleLength),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime? end) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final startStr = '${months[start.month - 1]} ${start.day}';
    if (end == null) return '$startStr - Ongoing';
    final endStr = '${months[end.month - 1]} ${end.day}';
    return '$startStr - $endStr';
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} months ago';
    return '${(diff.inDays / 365).floor()} years ago';
  }

  String _getVariation(int length, int average) {
    final diff = length - average;
    if (diff == 0) return 'On track';
    if (diff > 0) return '+$diff days';
    return '$diff days';
  }

  Color _getVariationColor(int length, int average) {
    final diff = (length - average).abs();
    if (diff == 0) return AppColors.statusGreen;
    if (diff <= 3) return AppColors.statusYellow;
    return AppColors.statusOrange;
  }
}

/// Detail item widget
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
