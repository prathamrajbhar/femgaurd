import 'dart:math';
import '../models/symptom_log.dart';
import '../models/cycle_model.dart';

/// Cycle phases for health insights
enum CyclePhase {
  menstrual,    // Days 1-5
  follicular,   // Days 6-13
  ovulatory,    // Days 14-16
  luteal,       // Days 17-28
}

extension CyclePhaseExtension on CyclePhase {
  String get displayName {
    switch (this) {
      case CyclePhase.menstrual: return 'Menstrual Phase';
      case CyclePhase.follicular: return 'Follicular Phase';
      case CyclePhase.ovulatory: return 'Ovulation Phase';
      case CyclePhase.luteal: return 'Luteal Phase';
    }
  }

  String get emoji {
    switch (this) {
      case CyclePhase.menstrual: return '🩸';
      case CyclePhase.follicular: return '🌱';
      case CyclePhase.ovulatory: return '🌸';
      case CyclePhase.luteal: return '🌙';
    }
  }

  String get description {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Your period is here. Your body is shedding the uterine lining.';
      case CyclePhase.follicular:
        return 'Your body is preparing for ovulation. Energy levels typically rise.';
      case CyclePhase.ovulatory:
        return 'Peak fertility time. You may feel your best during this phase.';
      case CyclePhase.luteal:
        return 'Post-ovulation phase. Hormone changes may bring PMS symptoms.';
    }
  }

  List<String> get expectedFeelings {
    switch (this) {
      case CyclePhase.menstrual:
        return [
          'Lower energy levels',
          'Possible cramping',
          'Need for rest and comfort',
          'Cravings for warm foods',
        ];
      case CyclePhase.follicular:
        return [
          'Increasing energy',
          'Better focus and clarity',
          'More social motivation',
          'Improved mood',
        ];
      case CyclePhase.ovulatory:
        return [
          'Peak energy levels',
          'Heightened confidence',
          'Increased libido',
          'Better communication',
        ];
      case CyclePhase.luteal:
        return [
          'PMS symptoms may appear',
          'Mood fluctuations',
          'Food cravings',
          'Desire for quiet time',
        ];
    }
  }

  List<String> get selfCareTips {
    switch (this) {
      case CyclePhase.menstrual:
        return [
          'Rest when you need to',
          'Use a heating pad for cramps',
          'Eat iron-rich foods',
          'Gentle movement like walking',
        ];
      case CyclePhase.follicular:
        return [
          'Try new workouts',
          'Start new projects',
          'Social activities',
          'High-intensity exercise',
        ];
      case CyclePhase.ovulatory:
        return [
          'Schedule important meetings',
          'Date nights or social events',
          'High-energy activities',
          'Express yourself creatively',
        ];
      case CyclePhase.luteal:
        return [
          'Prioritize sleep',
          'Reduce caffeine intake',
          'Practice stress management',
          'Prepare for your period',
        ];
    }
  }
}

/// Health insight generated from pattern analysis
class HealthInsight {
  final String title;
  final String description;
  final String emoji;
  final InsightType type;
  final InsightSeverity severity;
  final String? action;

  const HealthInsight({
    required this.title,
    required this.description,
    required this.emoji,
    required this.type,
    this.severity = InsightSeverity.info,
    this.action,
  });
}

enum InsightType {
  cyclePattern,
  symptomTrend,
  wellnessTip,
  irregularity,
  positive,
}

enum InsightSeverity {
  info,
  suggestion,
  attention,
}

/// Engine for generating health insights and predictions
class InsightsEngine {
  /// Get current cycle phase based on cycle day
  static CyclePhase getCurrentPhase(int cycleDay, int cycleLength) {
    final normalizedDay = cycleDay % cycleLength;
    
    if (normalizedDay <= 5) return CyclePhase.menstrual;
    if (normalizedDay <= 13) return CyclePhase.follicular;
    if (normalizedDay <= 16) return CyclePhase.ovulatory;
    return CyclePhase.luteal;
  }

  /// Generate "What you might feel today" predictions
  static List<String> getTodayPredictions(
    CyclePhase phase,
    List<SymptomLog> recentLogs,
  ) {
    final predictions = <String>[];
    
    // Add phase-based predictions
    predictions.addAll(phase.expectedFeelings.take(2));
    
    // Add pattern-based predictions from logs
    if (recentLogs.isNotEmpty) {
      final avgPain = recentLogs.map((l) => l.painLevel).reduce((a, b) => a + b) / recentLogs.length;
      final avgEnergy = recentLogs.map((l) => l.energyLevel).reduce((a, b) => a + b) / recentLogs.length;
      
      if (avgPain > 5) {
        predictions.add('Based on patterns: possible discomfort');
      }
      if (avgEnergy < 5) {
        predictions.add('You may feel more tired than usual');
      }
    }
    
    return predictions.take(4).toList();
  }

  /// Generate health insights from historical data
  static List<HealthInsight> generateInsights(
    List<CycleData> cycles,
    List<SymptomLog> symptomLogs,
    int cycleDay,
    int cycleLength,
  ) {
    final insights = <HealthInsight>[];
    
    // Cycle regularity insight
    if (cycles.length >= 3) {
      final lengths = cycles.map((c) => c.cycleLength).toList();
      final variance = _calculateVariance(lengths);
      
      if (variance < 3) {
        insights.add(const HealthInsight(
          title: 'Regular Cycles',
          description: 'Your cycles have been consistent lately. Great sign!',
          emoji: '✅',
          type: InsightType.positive,
          severity: InsightSeverity.info,
        ));
      } else if (variance > 7) {
        insights.add(HealthInsight(
          title: 'Irregular Pattern',
          description: 'Your cycle lengths have varied. Consider tracking more data.',
          emoji: '📊',
          type: InsightType.irregularity,
          severity: InsightSeverity.attention,
          action: 'Keep logging to identify patterns',
        ));
      }
    }

    // Symptom pattern insights
    if (symptomLogs.length >= 7) {
      final recentLogs = symptomLogs.take(7).toList();
      
      // Pain pattern
      final painDays = recentLogs.where((l) => l.painLevel > 5).length;
      if (painDays >= 4) {
        insights.add(HealthInsight(
          title: 'Elevated Pain Levels',
          description: 'You\'ve logged significant pain $painDays days this week.',
          emoji: '💫',
          type: InsightType.symptomTrend,
          severity: InsightSeverity.attention,
          action: 'Try heating pads or gentle stretching',
        ));
      }

      // Fatigue pattern
      final fatigueDays = recentLogs.where((l) => l.fatigueLevel > 6).length;
      if (fatigueDays >= 4) {
        insights.add(HealthInsight(
          title: 'Fatigue Trend',
          description: 'Your energy has been low lately. This is common during certain phases.',
          emoji: '😴',
          type: InsightType.symptomTrend,
          severity: InsightSeverity.suggestion,
          action: 'Prioritize rest and consider iron-rich foods',
        ));
      }

      // Mood pattern
      final lowMoodDays = recentLogs.where((l) => l.moodLevel < 4).length;
      if (lowMoodDays >= 3) {
        insights.add(const HealthInsight(
          title: 'Mood Changes',
          description: 'Mood fluctuations are normal during hormonal shifts.',
          emoji: '🌈',
          type: InsightType.wellnessTip,
          severity: InsightSeverity.info,
        ));
      }

      // Exercise correlation
      final exerciseLogs = recentLogs.where((l) => l.didExercise).toList();
      if (exerciseLogs.isNotEmpty) {
        final exerciseEnergy = exerciseLogs.map((l) => l.energyLevel).reduce((a, b) => a + b) / exerciseLogs.length;
        final noExerciseEnergy = recentLogs.where((l) => !l.didExercise).map((l) => l.energyLevel).fold<double>(0, (a, b) => a + b);
        final noExerciseCount = recentLogs.where((l) => !l.didExercise).length;
        
        if (noExerciseCount > 0 && exerciseEnergy > (noExerciseEnergy / noExerciseCount) + 1) {
          insights.add(const HealthInsight(
            title: 'Exercise Boost',
            description: 'Your energy is higher on days you exercise. Keep it up!',
            emoji: '🏃',
            type: InsightType.positive,
            severity: InsightSeverity.info,
          ));
        }
      }
    }

    // Phase-specific wellness tips
    final phase = getCurrentPhase(cycleDay, cycleLength);
    insights.add(HealthInsight(
      title: 'Phase Tip',
      description: phase.selfCareTips.first,
      emoji: '💡',
      type: InsightType.wellnessTip,
      severity: InsightSeverity.suggestion,
    ));

    // Limit insights to prevent overwhelm
    return insights.take(4).toList();
  }

  /// Calculate ovulation day estimate
  static int getOvulationDay(int cycleLength) {
    // Ovulation typically occurs 14 days before the next period
    return cycleLength - 14;
  }

  /// Get fertile window (5 days before ovulation + ovulation day)
  static (int start, int end) getFertileWindow(int cycleLength) {
    final ovulationDay = getOvulationDay(cycleLength);
    return (ovulationDay - 5, ovulationDay);
  }

  /// Get cycle day summary text
  static String getCycleDaySummary(int cycleDay, int cycleLength) {
    final phase = getCurrentPhase(cycleDay, cycleLength);
    final fertileWindow = getFertileWindow(cycleLength);
    
    if (cycleDay >= fertileWindow.$1 && cycleDay <= fertileWindow.$2) {
      return 'Fertile window • ${phase.displayName}';
    }
    return phase.displayName;
  }

  /// Get days until next period
  static int getDaysUntilPeriod(int cycleDay, int cycleLength) {
    return cycleLength - cycleDay;
  }

  /// Get period likelihood text
  static String getPeriodLikelihood(int daysUntil) {
    if (daysUntil <= 0) return 'Period may start today';
    if (daysUntil == 1) return 'Period likely tomorrow';
    if (daysUntil <= 3) return 'Period expected in $daysUntil days';
    if (daysUntil <= 7) return 'Period in about a week';
    return '$daysUntil days until expected period';
  }

  /// Calculate variance of a list of numbers
  static double _calculateVariance(List<int> values) {
    if (values.isEmpty) return 0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => pow(v - mean, 2));
    return sqrt(squaredDiffs.reduce((a, b) => a + b) / values.length);
  }

  /// Get greeting based on time of day
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Get supportive message based on cycle phase
  static String getSupportiveMessage(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Take it easy today. Your body is doing important work. 💜';
      case CyclePhase.follicular:
        return 'New beginnings! This is a great time for fresh starts. 🌱';
      case CyclePhase.ovulatory:
        return 'You\'re at your peak! Make the most of this energy. ✨';
      case CyclePhase.luteal:
        return 'Be gentle with yourself as your body prepares for change. 🌙';
    }
  }

  /// Get symptom severity indicator for a log
  static String getSymptomSeverityEmoji(SymptomLog log) {
    if (!log.hasSymptoms) return '🟢';
    if (log.averageSeverity < 3) return '🟡';
    if (log.averageSeverity < 6) return '🟠';
    return '🔴';
  }
}
