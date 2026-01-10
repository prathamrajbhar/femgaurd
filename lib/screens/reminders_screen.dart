import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Reminders settings screen
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  // Reminder states
  bool _periodReminder = true;
  bool _symptomReminder = true;
  bool _pillReminder = false;
  bool _waterReminder = false;
  
  TimeOfDay _periodTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _symptomTime = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay _pillTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _waterTime = const TimeOfDay(hour: 10, minute: 0);
  
  int _periodDaysBefore = 2;
  String _waterFrequency = 'Every 2 hours';

  Future<void> _selectTime(TimeOfDay initialTime, Function(TimeOfDay) onSelected) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
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
      onSelected(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
        title: const Text('Reminders'),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Reminders saved!'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.statusGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(16),
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: AppColors.primaryShadow(0.3),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stay on Track',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set reminders to help you maintain your health routines',
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
            ),
            const SizedBox(height: 28),
            
            // Period reminder
            _ReminderCard(
              icon: Icons.event_rounded,
              iconColor: AppColors.primary,
              title: 'Period Reminder',
              subtitle: 'Get notified before your expected period',
              isEnabled: _periodReminder,
              onToggle: (value) => setState(() => _periodReminder = value),
              child: _periodReminder ? Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SettingOption(
                          label: 'Days before',
                          value: '$_periodDaysBefore days',
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => _DaysPickerSheet(
                                currentValue: _periodDaysBefore,
                                onChanged: (value) {
                                  setState(() => _periodDaysBefore = value);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SettingOption(
                          label: 'Time',
                          value: _formatTime(_periodTime),
                          onTap: () => _selectTime(_periodTime, (time) {
                            setState(() => _periodTime = time);
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ) : null,
            ),
            const SizedBox(height: 16),
            
            // Symptom logging reminder
            _ReminderCard(
              icon: Icons.edit_note_rounded,
              iconColor: AppColors.accent,
              title: 'Daily Symptom Logging',
              subtitle: 'Reminder to log how you\'re feeling',
              isEnabled: _symptomReminder,
              onToggle: (value) => setState(() => _symptomReminder = value),
              child: _symptomReminder ? Column(
                children: [
                  const SizedBox(height: 16),
                  _SettingOption(
                    label: 'Reminder time',
                    value: _formatTime(_symptomTime),
                    onTap: () => _selectTime(_symptomTime, (time) {
                      setState(() => _symptomTime = time);
                    }),
                  ),
                ],
              ) : null,
            ),
            const SizedBox(height: 16),
            
            // Pill reminder
            _ReminderCard(
              icon: Icons.medication_rounded,
              iconColor: AppColors.secondary,
              title: 'Pill Reminder',
              subtitle: 'Daily medication or supplement reminder',
              isEnabled: _pillReminder,
              onToggle: (value) => setState(() => _pillReminder = value),
              child: _pillReminder ? Column(
                children: [
                  const SizedBox(height: 16),
                  _SettingOption(
                    label: 'Reminder time',
                    value: _formatTime(_pillTime),
                    onTap: () => _selectTime(_pillTime, (time) {
                      setState(() => _pillTime = time);
                    }),
                  ),
                ],
              ) : null,
            ),
            const SizedBox(height: 16),
            
            // Water reminder
            _ReminderCard(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xFF2196F3),
              title: 'Water Reminder',
              subtitle: 'Stay hydrated throughout the day',
              isEnabled: _waterReminder,
              onToggle: (value) => setState(() => _waterReminder = value),
              child: _waterReminder ? Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _SettingOption(
                          label: 'Frequency',
                          value: _waterFrequency,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => _FrequencyPickerSheet(
                                currentValue: _waterFrequency,
                                onChanged: (value) {
                                  setState(() => _waterFrequency = value);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SettingOption(
                          label: 'Start time',
                          value: _formatTime(_waterTime),
                          onTap: () => _selectTime(_waterTime, (time) {
                            setState(() => _waterTime = time);
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ) : null,
            ),
            const SizedBox(height: 28),
            
            // Info note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Reminders will be sent as local notifications. Make sure notifications are enabled in your device settings.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
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

/// Reminder card widget
class _ReminderCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final Widget? child;

  const _ReminderCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    required this.onToggle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEnabled ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: isEnabled 
            ? Border.all(color: iconColor.withValues(alpha: 0.3))
            : Border.all(color: AppColors.border),
        boxShadow: isEnabled ? AppColors.softShadow : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: iconColor, size: 22),
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
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: iconColor,
              ),
            ],
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Setting option widget
class _SettingOption extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SettingOption({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Days picker bottom sheet
class _DaysPickerSheet extends StatelessWidget {
  final int currentValue;
  final ValueChanged<int> onChanged;

  const _DaysPickerSheet({required this.currentValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Days Before Period',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final value = index + 1;
                final isSelected = value == currentValue;
                return ListTile(
                  title: Text('$value ${value == 1 ? 'day' : 'days'} before'),
                  trailing: isSelected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
                  onTap: () => onChanged(value),
                  selected: isSelected,
                  selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Frequency picker bottom sheet
class _FrequencyPickerSheet extends StatelessWidget {
  final String currentValue;
  final ValueChanged<String> onChanged;

  const _FrequencyPickerSheet({required this.currentValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = ['Every hour', 'Every 2 hours', 'Every 3 hours', 'Every 4 hours'];
    
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Reminder Frequency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final value = options[index];
                final isSelected = value == currentValue;
                return ListTile(
                  title: Text(value),
                  trailing: isSelected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
                  onTap: () => onChanged(value),
                  selected: isSelected,
                  selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
