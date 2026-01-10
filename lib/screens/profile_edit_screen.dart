import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// Profile edit screen
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late int _age;
  late int _cycleLength;
  late DateTime _lastPeriodDate;
  late String _lifestyleLevel;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _age = appState.userProfile.age ?? 25;
    _cycleLength = appState.userProfile.cycleLength;
    _lastPeriodDate = appState.userProfile.lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14));
    _lifestyleLevel = appState.userProfile.lifestyleLevel;
  }

  void _saveProfile() {
    final appState = context.read<AppState>();
    final updatedProfile = UserProfile(
      age: _age,
      cycleLength: _cycleLength,
      lastPeriodDate: _lastPeriodDate,
      lifestyleLevel: _lifestyleLevel,
      hasCompletedOnboarding: true,
      hasAcceptedConsent: true,
    );
    
    appState.updateProfile(updatedProfile);
    HapticFeedback.mediumImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.statusGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            icon: Icon(Icons.check_rounded, color: AppColors.primary),
            label: Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: AppColors.primaryShadow(0.3),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Update your health information',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Age card
            _EditCard(
              icon: Icons.cake_rounded,
              title: 'Your Age',
              value: '$_age years old',
              child: Column(
                children: [
                  Slider(
                    value: _age.toDouble(),
                    min: 13,
                    max: 55,
                    divisions: 42,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _age = value.round();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('13', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                        Text('55', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Cycle length card
            _EditCard(
              icon: Icons.loop_rounded,
              title: 'Cycle Length',
              value: '$_cycleLength days',
              child: Column(
                children: [
                  Slider(
                    value: _cycleLength.toDouble(),
                    min: AppConstants.minCycleLength.toDouble(),
                    max: AppConstants.maxCycleLength.toDouble(),
                    divisions: AppConstants.maxCycleLength - AppConstants.minCycleLength,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _cycleLength = value.round();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppConstants.minCycleLength}', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                        Text('${AppConstants.maxCycleLength}', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Last period date card
            _EditCard(
              icon: Icons.event_rounded,
              title: 'Last Period Start',
              value: '${_lastPeriodDate.day}/${_lastPeriodDate.month}/${_lastPeriodDate.year}',
              onTap: _selectDate,
              child: InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Tap to change date',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Activity level card
            _EditCard(
              icon: Icons.directions_run_rounded,
              title: 'Activity Level',
              value: _lifestyleLevel,
              child: Row(
                children: AppConstants.lifestyleLevels.map((level) {
                  final isSelected = level == _lifestyleLevel;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _lifestyleLevel = level;
                        });
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])
                              : null,
                          color: isSelected ? null : AppColors.background,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: isSelected ? null : Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              level == 'Low' ? Icons.self_improvement_rounded :
                              level == 'Medium' ? Icons.directions_walk_rounded :
                              Icons.directions_run_rounded,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              size: 24,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              level,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            
            // Save button
            GestureDetector(
              onTap: _saveProfile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppColors.primaryShadow(0.4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Edit card widget
class _EditCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget child;
  final VoidCallback? onTap;

  const _EditCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.child,
    this.onTap,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
