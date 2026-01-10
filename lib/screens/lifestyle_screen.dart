import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lifestyle_log.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/slider_input.dart';

/// Lifestyle tracking screen
class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({super.key});

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {
  double _sleepHours = 7.0;
  double _stressLevel = 5;
  String _activityLevel = 'Moderate';

  String _getSleepLabel(double value) {
    if (value < 5) return '😴 Not enough';
    if (value < 7) return '😐 Fair';
    if (value <= 9) return '😊 Good';
    return '💤 Lots of rest';
  }

  String _getStressLabel(double value) {
    if (value <= 2) return 'Relaxed';
    if (value <= 4) return 'Mild';
    if (value <= 6) return 'Moderate';
    if (value <= 8) return 'High';
    return 'Very High';
  }

  void _saveLog() {
    final log = LifestyleLog(
      date: DateTime.now(),
      sleepHours: _sleepHours,
      stressLevel: _stressLevel.round(),
      activityLevel: _activityLevel,
    );
    
    context.read<AppState>().addLifestyleLog(log);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lifestyle logged successfully!'),
        backgroundColor: AppColors.statusGreen,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifestyle Tracking'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info card
                Card(
                  color: AppColors.secondaryLight.withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tracking lifestyle factors helps identify patterns that may affect your cycle.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Sleep hours slider
                SliderInput(
                  label: 'Sleep Hours',
                  value: _sleepHours,
                  min: 0,
                  max: 12,
                  divisions: 24,
                  onChanged: (value) => setState(() => _sleepHours = value),
                  icon: Icons.bedtime,
                  valueLabel: '${_sleepHours.toStringAsFixed(1)}h • ${_getSleepLabel(_sleepHours)}',
                  leftLabel: '0h',
                  rightLabel: '12h',
                ),
                const SizedBox(height: 12),
                
                // Stress level slider
                SliderInput(
                  label: 'Stress Level',
                  value: _stressLevel,
                  onChanged: (value) => setState(() => _stressLevel = value),
                  icon: Icons.psychology,
                  valueLabel: _getStressLabel(_stressLevel),
                  leftLabel: 'Relaxed',
                  rightLabel: 'Very High',
                ),
                const SizedBox(height: 12),
                
                // Activity level selector
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_run, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Activity Level',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppConstants.activityLevels.map((level) {
                            final isSelected = level == _activityLevel;
                            return ChoiceChip(
                              label: Text(level),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _activityLevel = level),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.divider,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Recent logs
                Text(
                  'Recent Lifestyle Logs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (appState.lifestyleLogs.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No lifestyle logs yet',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  ...appState.lifestyleLogs.take(5).map((log) => _LifestyleLogItem(log: log)),
                const SizedBox(height: 24),
                
                // Save button
                CustomButton(
                  text: 'Save Today\'s Log',
                  onPressed: _saveLog,
                  icon: Icons.check,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Lifestyle log item widget
class _LifestyleLogItem extends StatelessWidget {
  final LifestyleLog log;

  const _LifestyleLogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.today, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${log.date.day}/${log.date.month}/${log.date.year}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${log.sleepHours}h sleep • Stress: ${log.stressLevel}/10 • ${log.activityLevel}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
