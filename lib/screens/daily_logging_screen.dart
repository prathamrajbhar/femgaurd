import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/symptom_log.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Comprehensive daily logging screen with icon-based, tap-only inputs
/// Target: Complete logging in under 30 seconds
class DailyLoggingScreen extends StatefulWidget {
  final DateTime? selectedDate;
  
  const DailyLoggingScreen({super.key, this.selectedDate});

  @override
  State<DailyLoggingScreen> createState() => _DailyLoggingScreenState();
}

class _DailyLoggingScreenState extends State<DailyLoggingScreen>
    with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  
  // Flow tracking
  FlowIntensity _flowIntensity = FlowIntensity.none;
  
  // Pain tracking
  PainTypes _painTypes = const PainTypes();
  int _painLevel = 0;
  
  // Mood & Energy
  MoodState _selectedMood = MoodState.calm;
  int _energyLevel = 5;
  int _stressLevel = 3;
  
  // Discharge
  DischargeType _dischargeType = DischargeType.none;
  
  // Sleep
  double _sleepHours = 7.0;
  int _sleepQuality = 3;
  
  // Exercise
  bool _didExercise = false;
  String? _exerciseType;
  
  // Additional symptoms
  bool _bloating = false;
  bool _cravings = false;
  bool _brainFog = false;
  
  // Sensitive (private)
  bool _showSensitiveSection = false;
  bool? _sexualActivity;
  
  // Notes
  final _notesController = TextEditingController();
  
  // Current section for UX
  int _currentSection = 0;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
    _loadExistingLog();
  }

  void _loadExistingLog() {
    final appState = context.read<AppState>();
    final existingLog = appState.symptomLogs.where((log) {
      return log.date.year == _selectedDate.year &&
             log.date.month == _selectedDate.month &&
             log.date.day == _selectedDate.day;
    }).firstOrNull;
    
    if (existingLog != null) {
      setState(() {
        _flowIntensity = existingLog.flowIntensity;
        _painTypes = existingLog.painTypes;
        _painLevel = existingLog.painLevel;
        _energyLevel = existingLog.energyLevel;
        _stressLevel = existingLog.stressLevel;
        _dischargeType = existingLog.dischargeType;
        _sleepHours = existingLog.sleepHours ?? 7.0;
        _sleepQuality = existingLog.sleepQuality ?? 3;
        _didExercise = existingLog.didExercise;
        _exerciseType = existingLog.exerciseType;
        _bloating = existingLog.bloating;
        _cravings = existingLog.cravings;
        _brainFog = existingLog.brainFog;
        _sexualActivity = existingLog.sexualActivity;
        _notesController.text = existingLog.notes;
        if (existingLog.moodState != null) {
          _selectedMood = existingLog.moodState!;
        }
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _saveLog() {
    HapticFeedback.mediumImpact();
    
    final log = SymptomLog(
      date: _selectedDate,
      painLevel: _painLevel,
      moodLevel: _getMoodLevelFromState(_selectedMood),
      fatigueLevel: 10 - _energyLevel,
      stressLevel: _stressLevel,
      energyLevel: _energyLevel,
      flowIntensity: _flowIntensity,
      painTypes: _painTypes,
      moodState: _selectedMood,
      dischargeType: _dischargeType,
      sleepHours: _sleepHours,
      sleepQuality: _sleepQuality,
      didExercise: _didExercise,
      exerciseType: _exerciseType,
      sexualActivity: _sexualActivity,
      bloating: _bloating,
      cravings: _cravings,
      brainFog: _brainFog,
      notes: _notesController.text,
    );
    
    context.read<AppState>().addSymptomLog(log);
    
    _showSuccessAnimation();
  }

  int _getMoodLevelFromState(MoodState mood) {
    switch (mood) {
      case MoodState.happy: return 9;
      case MoodState.energetic: return 8;
      case MoodState.calm: return 6;
      case MoodState.anxious: return 4;
      case MoodState.irritable: return 3;
      case MoodState.sad: return 2;
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        });
        return Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.7)],
                    ),
                  ),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Logged! 💪',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(context),
              _buildProgressIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentSection = index),
                  children: [
                    _buildFlowSection(),
                    _buildPainSection(),
                    _buildMoodSection(),
                    _buildWellnessSection(),
                    _buildNotesSection(),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _selectedDate.day == DateTime.now().day &&
                    _selectedDate.month == DateTime.now().month &&
                    _selectedDate.year == DateTime.now().year;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? "Today's Log" : 'Log Entry',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(_selectedDate),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentSection + 1}/5',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
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
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(5, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentSection 
                    ? AppColors.accent 
                    : AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFlowSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Flow', Icons.water_drop),
          const SizedBox(height: 8),
          Text(
            'Are you on your period today?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          _buildFlowSelector(),
          const SizedBox(height: 32),
          _buildSectionTitle('Discharge', Icons.opacity),
          const SizedBox(height: 16),
          _buildDischargeSelector(),
        ],
      ),
    );
  }

  Widget _buildFlowSelector() {
    final options = [
      (FlowIntensity.none, '💧', 'None'),
      (FlowIntensity.spotting, '🩸', 'Spotting'),
      (FlowIntensity.light, '🩸', 'Light'),
      (FlowIntensity.medium, '🩸🩸', 'Medium'),
      (FlowIntensity.heavy, '🩸🩸🩸', 'Heavy'),
    ];
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = _flowIntensity == option.$1;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _flowIntensity = option.$1);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.accent.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: Column(
              children: [
                Text(option.$2, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  option.$3,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected 
                        ? AppColors.accent 
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDischargeSelector() {
    final options = [
      (DischargeType.none, 'None', '⚪'),
      (DischargeType.dry, 'Dry', '🟤'),
      (DischargeType.sticky, 'Sticky', '🟡'),
      (DischargeType.creamy, 'Creamy', '⚪'),
      (DischargeType.watery, 'Watery', '💧'),
      (DischargeType.eggWhite, 'Egg White', '🥚'),
    ];
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = _dischargeType == option.$1;
        return _buildChip(
          label: option.$2,
          icon: option.$3,
          isSelected: isSelected,
          onTap: () => setState(() => _dischargeType = option.$1),
        );
      }).toList(),
    );
  }

  Widget _buildPainSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pain & Discomfort', Icons.healing),
          const SizedBox(height: 8),
          Text(
            'Tap all that apply',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          _buildPainTypesGrid(),
          const SizedBox(height: 24),
          if (_painTypes.hasPain) ...[
            Text(
              'Pain Intensity',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildPainIntensitySlider(),
          ],
          const SizedBox(height: 24),
          _buildSectionTitle('Other Symptoms', Icons.bubble_chart),
          const SizedBox(height: 16),
          _buildOtherSymptomsGrid(),
        ],
      ),
    );
  }

  Widget _buildPainTypesGrid() {
    final painOptions = [
      ('Cramps', '😣', _painTypes.cramps, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(cramps: v))),
      ('Headache', '🤕', _painTypes.headache, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(headache: v))),
      ('Backache', '💆', _painTypes.backache, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(backache: v))),
      ('Breast Pain', '💗', _painTypes.breastPain, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(breastPain: v))),
      ('Joint Pain', '🦴', _painTypes.jointPain, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(jointPain: v))),
      ('Nausea', '🤢', _painTypes.nausea, (bool v) => 
          setState(() => _painTypes = _painTypes.copyWith(nausea: v))),
    ];
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: painOptions.map((option) {
        return _buildToggleButton(
          label: option.$1,
          emoji: option.$2,
          isSelected: option.$3,
          onTap: () => option.$4(!option.$3),
        );
      }).toList(),
    );
  }

  Widget _buildPainIntensitySlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mild', style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              )),
              Text(
                '$_painLevel/10',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getPainColor(_painLevel),
                  fontSize: 18,
                ),
              ),
              Text('Severe', style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              )),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getPainColor(_painLevel),
              thumbColor: _getPainColor(_painLevel),
              overlayColor: _getPainColor(_painLevel).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _painLevel.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) {
                HapticFeedback.selectionClick();
                setState(() => _painLevel = v.round());
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPainColor(int level) {
    if (level <= 3) return Colors.green;
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildOtherSymptomsGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildToggleButton(
          label: 'Bloating',
          emoji: '🫄',
          isSelected: _bloating,
          onTap: () => setState(() => _bloating = !_bloating),
        ),
        _buildToggleButton(
          label: 'Cravings',
          emoji: '🍫',
          isSelected: _cravings,
          onTap: () => setState(() => _cravings = !_cravings),
        ),
        _buildToggleButton(
          label: 'Brain Fog',
          emoji: '🌫️',
          isSelected: _brainFog,
          onTap: () => setState(() => _brainFog = !_brainFog),
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('How are you feeling?', Icons.emoji_emotions),
          const SizedBox(height: 20),
          _buildMoodSelector(),
          const SizedBox(height: 32),
          _buildSectionTitle('Energy Level', Icons.bolt),
          const SizedBox(height: 16),
          _buildEnergySelector(),
          const SizedBox(height: 32),
          _buildSectionTitle('Stress Level', Icons.psychology),
          const SizedBox(height: 16),
          _buildStressSelector(),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      (MoodState.happy, '😊', 'Happy'),
      (MoodState.calm, '😌', 'Calm'),
      (MoodState.energetic, '⚡', 'Energetic'),  
      (MoodState.anxious, '😰', 'Anxious'),
      (MoodState.irritable, '😤', 'Irritable'),
      (MoodState.sad, '😢', 'Sad'),
    ];
    
    return Wrap(
      spacing: 12,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: moods.map((mood) {
        final isSelected = _selectedMood == mood.$1;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedMood = mood.$1);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.accent.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(mood.$2, style: TextStyle(
                  fontSize: isSelected ? 40 : 32,
                )),
                const SizedBox(height: 8),
                Text(
                  mood.$3,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected 
                        ? AppColors.accent 
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnergySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('😴 Low'),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.bolt,
                    size: 24,
                    color: index < _energyLevel ~/ 2
                        ? Colors.amber
                        : Colors.grey.withValues(alpha: 0.3),
                  );
                }),
              ),
              const Text('⚡ High'),
            ],
          ),
          Slider(
            value: _energyLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _energyLevel = v.round());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStressSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('😌 Relaxed'),
              Text(
                _getStressLabel(_stressLevel),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStressColor(_stressLevel),
                ),
              ),
              const Text('😰 Stressed'),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getStressColor(_stressLevel),
              thumbColor: _getStressColor(_stressLevel),
            ),
            child: Slider(
              value: _stressLevel.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) {
                HapticFeedback.selectionClick();
                setState(() => _stressLevel = v.round());
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStressLabel(int level) {
    if (level <= 2) return 'Very Relaxed';
    if (level <= 4) return 'Calm';
    if (level <= 6) return 'Moderate';
    if (level <= 8) return 'Stressed';
    return 'Very Stressed';
  }

  Color _getStressColor(int level) {
    if (level <= 3) return Colors.green;
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildWellnessSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Sleep', Icons.bedtime),
          const SizedBox(height: 16),
          _buildSleepSelector(),
          const SizedBox(height: 24),
          _buildSectionTitle('Exercise', Icons.fitness_center),
          const SizedBox(height: 16),
          _buildExerciseSelector(),
          const SizedBox(height: 24),
          _buildSensitiveSection(),
        ],
      ),
    );
  }

  Widget _buildSleepSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hours: ${_sleepHours.toStringAsFixed(1)}h'),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < _sleepQuality ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _sleepHours,
            min: 0,
            max: 12,
            divisions: 24,
            label: '${_sleepHours.toStringAsFixed(1)}h',
            onChanged: (v) {
              HapticFeedback.selectionClick();
              setState(() => _sleepHours = v);
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _sleepQuality = index + 1);
                },
                child: Column(
                  children: [
                    Icon(
                      index < _sleepQuality ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            'Sleep Quality',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSelector() {
    final exercises = ['None', 'Walking', 'Running', 'Yoga', 'Gym', 'Swimming', 'Other'];
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: exercises.map((exercise) {
        final isNone = exercise == 'None';
        final isSelected = isNone ? !_didExercise : (_didExercise && _exerciseType == exercise);
        return _buildChip(
          label: exercise,
          icon: _getExerciseEmoji(exercise),
          isSelected: isSelected,
          onTap: () {
            setState(() {
              if (isNone) {
                _didExercise = false;
                _exerciseType = null;
              } else {
                _didExercise = true;
                _exerciseType = exercise;
              }
            });
          },
        );
      }).toList(),
    );
  }

  String _getExerciseEmoji(String exercise) {
    switch (exercise) {
      case 'None': return '🚫';
      case 'Walking': return '🚶';
      case 'Running': return '🏃';
      case 'Yoga': return '🧘';
      case 'Gym': return '🏋️';
      case 'Swimming': return '🏊';
      default: return '💪';
    }
  }

  Widget _buildSensitiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _showSensitiveSection = !_showSensitiveSection),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Private Tracking',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _showSensitiveSection ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),
        ),
        if (_showSensitiveSection) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildToggleButton(
                label: 'Sexual Activity',
                emoji: '💕',
                isSelected: _sexualActivity == true,
                onTap: () => setState(() => _sexualActivity = _sexualActivity == true ? null : true),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNotesSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Notes', Icons.edit_note),
          const SizedBox(height: 8),
          Text(
            'Anything else you want to remember?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Add notes about your day...',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickLogSummary(),
        ],
      ),
    );
  }

  Widget _buildQuickLogSummary() {
    final summaryItems = <String>[];
    if (_flowIntensity != FlowIntensity.none) summaryItems.add('🩸 ${_flowIntensity.name}');
    if (_painTypes.hasPain) summaryItems.add('😣 Pain: ${_painTypes.painCount} types');
    summaryItems.add('${_getMoodEmoji(_selectedMood)} ${_selectedMood.name}');
    if (_didExercise) summaryItems.add('🏃 $_exerciseType');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Log Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: summaryItems.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(item, style: const TextStyle(fontSize: 13)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _getMoodEmoji(MoodState mood) {
    switch (mood) {
      case MoodState.happy: return '😊';
      case MoodState.calm: return '😌';
      case MoodState.energetic: return '⚡';
      case MoodState.anxious: return '😰';
      case MoodState.irritable: return '😤';
      case MoodState.sad: return '😢';
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentSection > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentSection > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _currentSection == 4 ? _saveLog : () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentSection == 4 ? 'Save Log ✓' : 'Continue',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required String emoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.accent.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? AppColors.accent 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.accent.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? AppColors.accent 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
