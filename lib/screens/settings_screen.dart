import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Modern settings and profile screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
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
                    // Profile Card
                    _ProfileCard(appState: appState),
                    const SizedBox(height: 24),
                    
                    // Quick Access - Most used features
                    _SettingsSection(
                      title: 'Quick Access',
                      children: [
                        _SettingsTile(
                          icon: Icons.edit_rounded,
                          title: 'Edit Profile',
                          subtitle: 'Update your health info',
                          onTap: () => Navigator.pushNamed(context, '/profile-edit'),
                        ),
                        _SettingsTile(
                          icon: Icons.calendar_month_rounded,
                          title: 'Cycle Calendar',
                          subtitle: 'View full calendar',
                          onTap: () => Navigator.pushNamed(context, '/calendar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Settings - Theme & Notifications
                    _SettingsSection(
                      title: 'Settings',
                      children: [
                        _ThemeTile(
                          currentTheme: appState.selectedTheme,
                          onTap: () => _showThemePicker(context, appState),
                        ),
                        _ToggleTile(
                          icon: Icons.notifications_active_rounded,
                          title: 'Notifications',
                          subtitle: 'Period reminders & insights',
                          value: appState.notificationsEnabled,
                          onChanged: (_) => appState.toggleNotifications(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // History & Data
                    _SettingsSection(
                      title: 'History & Data',
                      children: [
                        _SettingsTile(
                          icon: Icons.psychology_rounded,
                          title: 'Symptom History',
                          subtitle: 'View past symptom logs',
                          onTap: () => Navigator.pushNamed(context, '/symptom-history'),
                        ),
                        _SettingsTile(
                          icon: Icons.timeline_rounded,
                          title: 'Cycle History',
                          subtitle: 'View past cycles',
                          onTap: () => Navigator.pushNamed(context, '/cycle-history'),
                        ),
                        _SettingsTile(
                          icon: Icons.download_rounded,
                          title: 'Export Data',
                          subtitle: 'Download your data',
                          onTap: () => _showSnackBar(context, 'Data exported successfully!'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Support & Info
                    _SettingsSection(
                      title: 'Support',
                      children: [
                        _SettingsTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & FAQ',
                          subtitle: 'Get answers',
                          onTap: () => Navigator.pushNamed(context, '/help'),
                        ),
                        _SettingsTile(
                          icon: Icons.emergency_rounded,
                          title: 'Emergency Contacts',
                          subtitle: 'Quick access helplines',
                          onTap: () => Navigator.pushNamed(context, '/emergency-contacts'),
                        ),
                        _SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: 'About',
                          subtitle: 'App info & privacy',
                          onTap: () => Navigator.pushNamed(context, '/about'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Danger Zone
                    _DangerCard(
                      onTap: () => _showDeleteConfirmation(context, appState),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: AppColors.primaryShadow(0.3),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Text(
            'Profile & Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.statusOrange),
            const SizedBox(width: 10),
            const Text('Delete All Data?'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your logged data, cycle history, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusOrange,
            ),
            onPressed: () {
              appState.resetAllData();
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ThemePickerSheet(appState: appState),
    );
  }
}

/// Profile card
class _ProfileCard extends StatelessWidget {
  final AppState appState;

  const _ProfileCard({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: AppColors.primaryShadow(0.35),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Center(
              child: Text('👤', style: TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Age: ${appState.userProfile.age ?? "Not set"}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Cycle: ${appState.userProfile.cycleLength} days',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings section
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(
            children: List.generate(children.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Divider(color: AppColors.divider, height: 1, indent: 60);
              }
              return children[index ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}

/// Settings tile
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
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
                      fontSize: 14,
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
            onTap != null 
                ? Icon(Icons.chevron_right_rounded, color: AppColors.textLight)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

/// Toggle tile
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
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
                    fontSize: 14,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Theme tile
class _ThemeTile extends StatelessWidget {
  final ColorTheme currentTheme;
  final VoidCallback onTap;

  const _ThemeTile({required this.currentTheme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors.forTheme(currentTheme);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colors.primary, colors.primaryDark]),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.palette_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Theme',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${currentTheme.emoji} ${currentTheme.displayName}',
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

/// Danger card
class _DangerCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DangerCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.statusOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.statusOrange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.statusOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(Icons.delete_forever_rounded, color: AppColors.statusOrange, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete All Data',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Permanently remove all your data',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.statusOrange,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme picker bottom sheet
class _ThemePickerSheet extends StatelessWidget {
  final AppState appState;

  const _ThemePickerSheet({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(Icons.palette_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Theme',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Select your preferred color',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemCount: ColorTheme.values.length,
              itemBuilder: (context, index) {
                final theme = ColorTheme.values[index];
                final isSelected = theme == appState.selectedTheme;
                final colors = ThemeColors.forTheme(theme);
                
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    appState.setTheme(theme);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: isSelected ? colors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected 
                          ? [BoxShadow(
                              color: colors.primary.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colors.primary, colors.primaryDark],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(theme.emoji, style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          theme.displayName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? colors.primaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
