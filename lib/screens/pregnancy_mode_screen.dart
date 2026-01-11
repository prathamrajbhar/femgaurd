import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pregnancy_model.dart';
import '../utils/app_theme.dart';

/// Pregnancy mode screen for tracking pregnancy journey
class PregnancyModeScreen extends StatefulWidget {
  const PregnancyModeScreen({super.key});

  @override
  State<PregnancyModeScreen> createState() => _PregnancyModeScreenState();
}

class _PregnancyModeScreenState extends State<PregnancyModeScreen> {
  // Demo data
  late PregnancyData _pregnancyData;

  @override
  void initState() {
    super.initState();
    // Initialize with demo data (due date 20 weeks from now)
    _pregnancyData = PregnancyData(
      dueDate: DateTime.now().add(const Duration(days: 140)),
      lastPeriodDate: DateTime.now().subtract(const Duration(days: 140)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWeekProgressCard(),
                  const SizedBox(height: 20),
                  _buildBabySizeCard(),
                  const SizedBox(height: 20),
                  _buildWeeklyTipCard(),
                  const SizedBox(height: 20),
                  _buildMilestonesCard(),
                  const SizedBox(height: 20),
                  _buildQuickActionsRow(),
                  const SizedBox(height: 20),
                  _buildUpcomingCard(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppColors.softShadow,
          ),
          child: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF69B4), Color(0xFFFF1493)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text('🫃', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pregnancy Journey',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF69B4).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Week ${_pregnancyData.currentWeek} • Trimester ${_pregnancyData.trimester}',
                  style: TextStyle(
                    color: const Color(0xFFFF1493),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekProgressCard() {
    final progress = _pregnancyData.currentWeek / 40;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF69B4),
            const Color(0xFFFF1493),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF69B4).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Week ${_pregnancyData.currentWeek}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'of 40 weeks',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${_pregnancyData.daysRemaining}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'days to go',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrimesterLabel('1st', _pregnancyData.trimester >= 1),
              _buildTrimesterLabel('2nd', _pregnancyData.trimester >= 2),
              _buildTrimesterLabel('3rd', _pregnancyData.trimester >= 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrimesterLabel(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label Trimester',
        style: TextStyle(
          color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBabySizeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getBabySizeEmoji(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baby is now the size of a',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pregnancyData.babySizeComparison,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBabySizeEmoji() {
    final week = _pregnancyData.currentWeek;
    if (week < 8) return '🫐';
    if (week < 12) return '🍋';
    if (week < 16) return '🍎';
    if (week < 20) return '🥭';
    if (week < 24) return '🌽';
    if (week < 28) return '🍆';
    if (week < 32) return '🥥';
    if (week < 36) return '🍈';
    return '🎃';
  }

  Widget _buildWeeklyTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Week ${_pregnancyData.currentWeek} Tip',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _pregnancyData.weeklyTip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildMilestonesCard() {
    final milestones = _getMilestones();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'Upcoming Milestones',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...milestones.map((m) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: m['completed'] == true
                        ? Colors.green.withValues(alpha: 0.2)
                        : AppColors.primaryLight.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      m['completed'] == true ? Icons.check : Icons.schedule,
                      color: m['completed'] == true ? Colors.green : AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: m['completed'] == true
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        'Week ${m['week']}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMilestones() {
    final week = _pregnancyData.currentWeek;
    return [
      {'title': 'First Prenatal Visit', 'week': 8, 'completed': week >= 8},
      {'title': 'First Trimester Screening', 'week': 12, 'completed': week >= 12},
      {'title': 'Anatomy Scan', 'week': 20, 'completed': week >= 20},
      {'title': 'Glucose Test', 'week': 28, 'completed': week >= 28},
      {'title': 'Group B Strep Test', 'week': 36, 'completed': week >= 36},
    ];
  }

  Widget _buildQuickActionsRow() {
    final actions = [
      ('📝', 'Log', const Color(0xFFE91E63)),
      ('📅', 'Appts', const Color(0xFF4CAF50)),
      ('📚', 'Guide', const Color(0xFF2196F3)),
      ('💊', 'Meds', const Color(0xFFFF9800)),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${action.$1} ${action.$2} coming soon!'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: action.$3.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: action.$3.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: action.$3.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(action.$1, style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      action.$2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
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

  Widget _buildUpcomingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.15),
            Colors.purple.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Text('📆', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                Text(
                  _formatDate(_pregnancyData.dueDate),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_pregnancyData.daysRemaining} days',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
