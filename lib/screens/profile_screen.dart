import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Profile screen showing user information and quick actions
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final profile = appState.userProfile;
        
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
            title: const Text('My Profile'),
            actions: [
              IconButton(
                icon: Icon(Icons.edit_rounded, color: AppColors.primary),
                onPressed: () => Navigator.pushNamed(context, '/profile-edit'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: AppColors.primaryShadow(0.4),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 50)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name placeholder
                      const Text(
                        'Health Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${profile.age ?? 25} years old',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.loop_rounded,
                        label: 'Cycle Length',
                        value: '${profile.cycleLength} days',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.fitness_center_rounded,
                        label: 'Activity',
                        value: profile.lifestyleLevel,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'Cycle Day',
                        value: 'Day ${appState.currentCycleDay}',
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.event_rounded,
                        label: 'Next Period',
                        value: '${appState.daysUntilNextPeriod}d',
                        color: const Color(0xFF9C27B0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                
                // Quick Actions
                _SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 14),
                
                _ActionTile(
                  icon: Icons.edit_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your health information',
                  onTap: () => Navigator.pushNamed(context, '/profile-edit'),
                ),
                _ActionTile(
                  icon: Icons.history_rounded,
                  title: 'Symptom History',
                  subtitle: 'View your past symptom logs',
                  onTap: () => Navigator.pushNamed(context, '/symptom-history'),
                ),
                _ActionTile(
                  icon: Icons.timeline_rounded,
                  title: 'Cycle History',
                  subtitle: 'View your past cycles',
                  onTap: () => Navigator.pushNamed(context, '/cycle-history'),
                ),
                _ActionTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'Full Calendar',
                  subtitle: 'View cycle calendar',
                  onTap: () => Navigator.pushNamed(context, '/calendar'),
                ),
                _ActionTile(
                  icon: Icons.bar_chart_rounded,
                  title: 'Reports & Analytics',
                  subtitle: 'View trends and insights',
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),
                const SizedBox(height: 28),
                
                // Health Status
                _SectionHeader(title: 'Current Health Status'),
                const SizedBox(height: 14),
                
                _HealthStatusCard(status: appState.healthStatus),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action tile widget
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

/// Health status card
class _HealthStatusCard extends StatelessWidget {
  final String status;

  const _HealthStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors(status);
    final info = _getStatusInfo(status);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(info['emoji']!, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['label']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info['message']!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getStatusColors(String status) {
    switch (status) {
      case 'green':
        return [AppColors.statusGreen, const Color(0xFF2E7D32)];
      case 'yellow':
        return [AppColors.statusYellow, const Color(0xFFE65100)];
      case 'orange':
        return [AppColors.statusOrange, const Color(0xFFD32F2F)];
      default:
        return [AppColors.statusGreen, const Color(0xFF2E7D32)];
    }
  }

  Map<String, String> _getStatusInfo(String status) {
    switch (status) {
      case 'green':
        return {
          'emoji': '✨',
          'label': 'Looking Good!',
          'message': 'Your recent symptoms are within normal range. Keep up the healthy habits!',
        };
      case 'yellow':
        return {
          'emoji': '👀',
          'label': 'Worth Monitoring',
          'message': 'Some symptoms are slightly elevated. Continue logging to track patterns.',
        };
      case 'orange':
        return {
          'emoji': '💬',
          'label': 'Consider Consulting',
          'message': 'Your symptoms suggest speaking with a healthcare provider might be helpful.',
        };
      default:
        return {
          'emoji': '✨',
          'label': 'Looking Good!',
          'message': 'Your recent symptoms are within normal range.',
        };
    }
  }
}
