import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import 'cycle_tracking_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

/// Main home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Cycle'),
    _NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Chat'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const _DashboardPage(),
          const CycleTrackingScreen(),
          const ChatScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _ModernBottomNav(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItem({required this.icon, required this.activeIcon, required this.label});
}

/// Modern floating bottom navigation bar with glassmorphism and animations
class _ModernBottomNav extends StatefulWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ModernBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_ModernBottomNav> createState() => _ModernBottomNavState();
}

class _ModernBottomNavState extends State<_ModernBottomNav> with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _scaleControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );
    _scaleAnimations = _scaleControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTapDown(int index) {
    _scaleControllers[index].forward();
  }

  void _onTapUp(int index) {
    _scaleControllers[index].reverse();
    widget.onTap(index);
  }

  void _onTapCancel(int index) {
    _scaleControllers[index].reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                // Main shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                // Subtle inner glow
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, -4),
                  spreadRadius: -8,
                ),
              ],
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.items.length, (index) {
                final isSelected = index == widget.currentIndex;
                final item = widget.items[index];
                
                return GestureDetector(
                  onTapDown: (_) => _onTapDown(index),
                  onTapUp: (_) => _onTapUp(index),
                  onTapCancel: () => _onTapCancel(index),
                  behavior: HitTestBehavior.opaque,
                  child: ScaleTransition(
                    scale: _scaleAnimations[index],
                    child: AnimatedContainer(
                      duration: AppDurations.normal,
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 20 : 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected 
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                            spreadRadius: -2,
                          ),
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon with enhanced styling
                          AnimatedContainer(
                            duration: AppDurations.fast,
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected 
                                  ? Colors.white 
                                  : AppColors.textLight,
                              size: isSelected ? 22 : 24,
                            ),
                          ),
                          // Animated label for selected item
                          AnimatedSize(
                            duration: AppDurations.normal,
                            curve: Curves.easeOutCubic,
                            child: SizedBox(
                              width: isSelected ? null : 0,
                              child: isSelected ? Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    item.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ) : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashboard page content
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
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
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
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
                      child: const Text('🌸', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FemGuard',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Your health companion',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 11,
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
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: IconButton(
                      icon: Stack(
                        children: [
                          Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.statusOrange,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.surface, width: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              // Content
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Greeting
                    _buildGreeting(context),
                    const SizedBox(height: 24),
                    
                    // Cycle Hero Card
                    _CycleHeroCard(
                      cycleDay: appState.currentCycleDay,
                      daysUntilNext: appState.daysUntilNextPeriod,
                      nextDate: appState.nextPeriodDate,
                      healthStatus: appState.healthStatus,
                    ),
                    const SizedBox(height: 20),
                    
                    // Quick Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _QuickStatCard(
                            icon: Icons.favorite_rounded,
                            label: 'Status',
                            value: _getStatusLabel(appState.healthStatus),
                            color: _getStatusColor(appState.healthStatus),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickStatCard(
                            icon: Icons.loop_rounded,
                            label: 'Cycle',
                            value: '${appState.userProfile.cycleLength}d avg',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    
                    // Quick Actions Header
                    _SectionHeader(title: 'Quick Actions'),
                    const SizedBox(height: 14),
                    
                    // Quick Actions Grid
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.add_circle_outline_rounded,
                            title: 'Log Symptoms',
                            subtitle: 'Track how you feel',
                            gradient: [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
                            onTap: () => Navigator.pushNamed(context, '/symptom-logging'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.insights_rounded,
                            title: 'View Insights',
                            subtitle: 'AI-powered analysis',
                            gradient: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
                            onTap: () => Navigator.pushNamed(context, '/insights'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.spa_rounded,
                            title: 'Lifestyle',
                            subtitle: 'Sleep & activity',
                            gradient: [const Color(0xFFFA709A), const Color(0xFFFEE140)],
                            onTap: () => Navigator.pushNamed(context, '/lifestyle'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.bar_chart_rounded,
                            title: 'Reports',
                            subtitle: 'Trends & stats',
                            gradient: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                            onTap: () => Navigator.pushNamed(context, '/reports'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    
                    // Health Resources
                    _SectionHeader(title: 'Resources'),
                    const SizedBox(height: 14),
                    
                    _ResourceCard(
                      icon: Icons.shield_outlined,
                      title: 'Risk Awareness',
                      subtitle: 'Understanding health indicators',
                      emoji: '🛡️',
                      onTap: () => Navigator.pushNamed(context, '/risk-awareness'),
                    ),
                    const SizedBox(height: 10),
                    
                    if (appState.shouldShowDoctorSuggestion) ...[
                      _ResourceCard(
                        icon: Icons.local_hospital_outlined,
                        title: 'Doctor Suggestions',
                        subtitle: 'Consider consulting a professional',
                        emoji: '👩‍⚕️',
                        isHighlighted: true,
                        onTap: () => Navigator.pushNamed(context, '/doctors'),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;
    
    if (hour < 12) {
      greeting = 'Good Morning';
      emoji = '☀️';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      emoji = '🌤️';
    } else {
      greeting = 'Good Evening';
      emoji = '🌙';
    }
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(emoji, style: const TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Here\'s your health summary',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'green': return 'Normal';
      case 'yellow': return 'Monitor';
      case 'orange': return 'Consult';
      default: return 'Normal';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'green': return AppColors.statusGreen;
      case 'yellow': return AppColors.statusYellow;
      case 'orange': return AppColors.statusOrange;
      default: return AppColors.statusGreen;
    }
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

/// Cycle hero card with glassmorphism effect
class _CycleHeroCard extends StatelessWidget {
  final int cycleDay;
  final int daysUntilNext;
  final DateTime nextDate;
  final String healthStatus;

  const _CycleHeroCard({
    required this.cycleDay,
    required this.daysUntilNext,
    required this.nextDate,
    required this.healthStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.primaryDark.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 60,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day counter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Day',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$cycleDay',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Cycle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_rounded,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$daysUntilNext days until next',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${nextDate.day}/${nextDate.month}/${nextDate.year}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Status bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Health Status',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(healthStatus),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusLabel(healthStatus),
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'green': return 'Normal';
      case 'yellow': return 'Monitor';
      case 'orange': return 'Consult';
      default: return 'Normal';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'green': return AppColors.statusGreen;
      case 'yellow': return AppColors.statusYellow;
      case 'orange': return AppColors.statusOrange;
      default: return AppColors.statusGreen;
    }
  }
}

/// Quick stat card
class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
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
}

/// Action card with gradient
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
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
    );
  }
}

/// Resource card
class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String emoji;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _ResourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted 
              ? AppColors.statusOrange.withValues(alpha: 0.1) 
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isHighlighted 
              ? Border.all(color: AppColors.statusOrange.withValues(alpha: 0.3))
              : null,
          boxShadow: isHighlighted 
              ? null 
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isHighlighted ? AppColors.statusOrange : AppColors.primary)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
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
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
