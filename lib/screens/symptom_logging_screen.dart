import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/symptom_log.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Modern symptom logging screen
class SymptomLoggingScreen extends StatefulWidget {
  const SymptomLoggingScreen({super.key});

  @override
  State<SymptomLoggingScreen> createState() => _SymptomLoggingScreenState();
}

class _SymptomLoggingScreenState extends State<SymptomLoggingScreen> {
  double _painLevel = 0;
  double _moodLevel = 5;
  double _fatigueLevel = 0;
  String _notes = '';

  // Quick symptom selection
  final List<String> _selectedSymptoms = [];
  final List<_QuickSymptom> _quickSymptoms = [
    _QuickSymptom('💆', 'Headache'),
    _QuickSymptom('🤢', 'Nausea'),
    _QuickSymptom('🌊', 'Bloating'),
    _QuickSymptom('🔥', 'Cramps'),
    _QuickSymptom('😤', 'Irritable'),
    _QuickSymptom('🍫', 'Cravings'),
  ];

  String _getPainEmoji(double value) {
    if (value == 0) return '😊';
    if (value <= 3) return '😐';
    if (value <= 6) return '😣';
    if (value <= 8) return '😖';
    return '😫';
  }

  String _getMoodEmoji(double value) {
    if (value <= 2) return '😢';
    if (value <= 4) return '😕';
    if (value <= 6) return '😐';
    if (value <= 8) return '🙂';
    return '😊';
  }

  String _getFatigueEmoji(double value) {
    if (value == 0) return '⚡';
    if (value <= 3) return '🙂';
    if (value <= 6) return '😐';
    if (value <= 8) return '😴';
    return '😵';
  }

  void _saveLog() {
    final allNotes = [
      if (_notes.isNotEmpty) _notes,
      if (_selectedSymptoms.isNotEmpty) 'Symptoms: ${_selectedSymptoms.join(", ")}',
    ].join('\n');

    final log = SymptomLog(
      date: DateTime.now(),
      painLevel: _painLevel.round(),
      moodLevel: _moodLevel.round(),
      fatigueLevel: _fatigueLevel.round(),
      notes: allNotes,
    );
    
    context.read<AppState>().addSymptomLog(log);
    HapticFeedback.mediumImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Symptoms logged!'),
          ],
        ),
        backgroundColor: AppColors.statusGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick symptoms
                    _SectionLabel(title: 'Quick Symptoms'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _quickSymptoms.map((symptom) {
                        final isSelected = _selectedSymptoms.contains(symptom.label);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              if (isSelected) {
                                _selectedSymptoms.remove(symptom.label);
                              } else {
                                _selectedSymptoms.add(symptom.label);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: AppDurations.fast,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                              boxShadow: isSelected ? AppColors.primaryShadow(0.2) : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(symptom.emoji, style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  symptom.label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    
                    // Pain level
                    _SectionLabel(title: 'Pain Level'),
                    const SizedBox(height: 12),
                    _ModernSliderCard(
                      emoji: _getPainEmoji(_painLevel),
                      value: _painLevel,
                      label: _getPainLabel(_painLevel),
                      gradientColors: [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
                      onChanged: (value) => setState(() => _painLevel = value),
                    ),
                    const SizedBox(height: 20),
                    
                    // Mood level
                    _SectionLabel(title: 'Mood'),
                    const SizedBox(height: 12),
                    _ModernSliderCard(
                      emoji: _getMoodEmoji(_moodLevel),
                      value: _moodLevel,
                      label: _getMoodLabel(_moodLevel),
                      gradientColors: [const Color(0xFFA8EDEA), const Color(0xFFFED6E3)],
                      onChanged: (value) => setState(() => _moodLevel = value),
                    ),
                    const SizedBox(height: 20),
                    
                    // Fatigue level
                    _SectionLabel(title: 'Energy Level'),
                    const SizedBox(height: 12),
                    _ModernSliderCard(
                      emoji: _getFatigueEmoji(_fatigueLevel),
                      value: _fatigueLevel,
                      label: _getFatigueLabel(_fatigueLevel),
                      gradientColors: [const Color(0xFFD299C2), const Color(0xFFFEF9D7)],
                      isReversed: true,
                      onChanged: (value) => setState(() => _fatigueLevel = value),
                    ),
                    const SizedBox(height: 28),
                    
                    // Notes
                    _SectionLabel(title: 'Additional Notes'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: TextField(
                        maxLines: 3,
                        onChanged: (value) => _notes = value,
                        decoration: InputDecoration(
                          hintText: 'Any other symptoms or notes...',
                          hintStyle: TextStyle(color: AppColors.textLight),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Save button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      child: Row(
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textSecondary),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Symptoms',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'How are you feeling today?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Date badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.today_rounded, size: 14, color: AppColors.primaryDark),
                const SizedBox(width: 6),
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _saveLog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppColors.primaryShadow(0.35),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded, color: Colors.white),
                const SizedBox(width: 10),
                const Text(
                  'Save Symptoms',
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
      ),
    );
  }

  String _getPainLabel(double value) {
    if (value == 0) return 'No pain';
    if (value <= 3) return 'Mild';
    if (value <= 6) return 'Moderate';
    if (value <= 8) return 'Severe';
    return 'Intense';
  }

  String _getMoodLabel(double value) {
    if (value <= 2) return 'Very low';
    if (value <= 4) return 'Low';
    if (value <= 6) return 'Neutral';
    if (value <= 8) return 'Good';
    return 'Great';
  }

  String _getFatigueLabel(double value) {
    if (value == 0) return 'Energetic';
    if (value <= 3) return 'Refreshed';
    if (value <= 6) return 'Normal';
    if (value <= 8) return 'Tired';
    return 'Exhausted';
  }
}

class _QuickSymptom {
  final String emoji;
  final String label;

  _QuickSymptom(this.emoji, this.label);
}

/// Section label
class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

/// Modern slider card
class _ModernSliderCard extends StatelessWidget {
  final String emoji;
  final double value;
  final String label;
  final List<Color> gradientColors;
  final ValueChanged<double> onChanged;
  final bool isReversed;

  const _ModernSliderCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.gradientColors,
    required this.onChanged,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Emoji
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              // Label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isReversed 
                          ? 'Slide right for more fatigue'
                          : 'Slide right for higher intensity',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Value
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: gradientColors[0].withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  value.round().toString(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: gradientColors[0],
              inactiveTrackColor: gradientColors[0].withValues(alpha: 0.2),
              thumbColor: gradientColors[0],
              overlayColor: gradientColors[0].withValues(alpha: 0.15),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) {
                HapticFeedback.selectionClick();
                onChanged(v);
              },
            ),
          ),
          // Scale labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isReversed ? 'Full energy' : 'None',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  isReversed ? 'Exhausted' : 'Maximum',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
