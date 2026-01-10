import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

/// Profile setup screen
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _age = 25;
  int _cycleLength = 28;
  DateTime _lastPeriodDate = DateTime.now().subtract(const Duration(days: 14));
  String _lifestyleLevel = 'Medium';

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final profile = UserProfile(
        age: _age,
        cycleLength: _cycleLength,
        lastPeriodDate: _lastPeriodDate,
        lifestyleLevel: _lifestyleLevel,
        hasCompletedOnboarding: true,
        hasAcceptedConsent: true,
      );
      
      context.read<AppState>().updateProfile(profile);
      context.read<AppState>().initializeDummyData();
      
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
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
      setState(() => _lastPeriodDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Your Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text
                Text(
                  'Let\'s personalize your experience',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'This information helps us provide relevant insights',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                
                // Age input
                _InputCard(
                  icon: Icons.cake_outlined,
                  title: 'Your Age',
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _age.toDouble(),
                          min: 13,
                          max: 55,
                          divisions: 42,
                          onChanged: (value) {
                            setState(() => _age = value.round());
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_age',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Cycle length input
                _InputCard(
                  icon: Icons.calendar_month,
                  title: 'Average Cycle Length',
                  subtitle: 'Number of days from one period to the next',
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _cycleLength.toDouble(),
                          min: AppConstants.minCycleLength.toDouble(),
                          max: AppConstants.maxCycleLength.toDouble(),
                          divisions: AppConstants.maxCycleLength - AppConstants.minCycleLength,
                          onChanged: (value) {
                            setState(() => _cycleLength = value.round());
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_cycleLength days',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Last period date
                _InputCard(
                  icon: Icons.event,
                  title: 'Last Period Start Date',
                  child: InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(
                            '${_lastPeriodDate.day}/${_lastPeriodDate.month}/${_lastPeriodDate.year}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Icon(Icons.edit, color: AppColors.textLight, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Lifestyle level
                _InputCard(
                  icon: Icons.directions_run,
                  title: 'Activity Level',
                  child: Row(
                    children: AppConstants.lifestyleLevels.map((level) {
                      final isSelected = level == _lifestyleLevel;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(level),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _lifestyleLevel = level);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save button
                CustomButton(
                  text: 'Save & Continue',
                  onPressed: _saveProfile,
                  icon: Icons.check,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Input card wrapper widget
class _InputCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;

  const _InputCard({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
