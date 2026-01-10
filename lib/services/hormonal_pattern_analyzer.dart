import '../models/cycle_model.dart';
import '../models/symptom_log.dart';

/// Result model for hormonal pattern analysis
class HormonalPatternResult {
  final int score;
  final String riskLabel;
  final String riskDescription;
  final List<ContributingFactor> contributingFactors;
  final bool hasEnoughData;

  const HormonalPatternResult({
    required this.score,
    required this.riskLabel,
    required this.riskDescription,
    required this.contributingFactors,
    required this.hasEnoughData,
  });

  /// Create a result indicating insufficient data
  factory HormonalPatternResult.insufficientData() {
    return const HormonalPatternResult(
      score: 0,
      riskLabel: 'Insufficient Data',
      riskDescription: 'Log more cycle and symptom data to see pattern analysis.',
      contributingFactors: [],
      hasEnoughData: false,
    );
  }
}

/// Model for individual contributing factors
class ContributingFactor {
  final String name;
  final String description;
  final int points;
  final String icon;

  const ContributingFactor({
    required this.name,
    required this.description,
    required this.points,
    required this.icon,
  });
}

/// Analyzer for hormonal patterns based on cycle and symptom data
/// 
/// This analyzer provides AWARENESS ONLY and does NOT provide medical diagnosis.
/// Users should always consult healthcare professionals for medical advice.
class HormonalPatternAnalyzer {
  /// Minimum number of cycles required for meaningful analysis
  static const int minCyclesRequired = 3;

  /// Analyze cycle and symptom data for potential hormonal patterns
  /// 
  /// Returns a [HormonalPatternResult] containing:
  /// - Overall awareness score
  /// - Risk label (for awareness purposes only)
  /// - List of contributing factors
  static HormonalPatternResult analyze({
    required List<CycleData> cycleHistory,
    required List<SymptomLog> symptomLogs,
  }) {
    // Check if we have enough data
    if (cycleHistory.length < minCyclesRequired) {
      return HormonalPatternResult.insufficientData();
    }

    int totalScore = 0;
    final factors = <ContributingFactor>[];

    // 1. Analyze cycle irregularity (variation > 7 days)
    final irregularityResult = _analyzeCycleIrregularity(cycleHistory);
    if (irregularityResult != null) {
      totalScore += irregularityResult.points;
      factors.add(irregularityResult);
    }

    // 2. Analyze long cycle gaps (> 35 days)
    final longCycleResult = _analyzeLongCycles(cycleHistory);
    if (longCycleResult != null) {
      totalScore += longCycleResult.points;
      factors.add(longCycleResult);
    }

    // 3. Analyze missed periods
    final missedPeriodResult = _analyzeMissedPeriods(cycleHistory);
    if (missedPeriodResult != null) {
      totalScore += missedPeriodResult.points;
      factors.add(missedPeriodResult);
    }

    // 4. Analyze acne patterns from symptom logs
    final acneResult = _analyzeAcne(symptomLogs);
    if (acneResult != null) {
      totalScore += acneResult.points;
      factors.add(acneResult);
    }

    // 5. Analyze excess hair growth
    final hairGrowthResult = _analyzeExcessHairGrowth(symptomLogs);
    if (hairGrowthResult != null) {
      totalScore += hairGrowthResult.points;
      factors.add(hairGrowthResult);
    }

    // 6. Analyze weight gain
    final weightResult = _analyzeWeightGain(symptomLogs);
    if (weightResult != null) {
      totalScore += weightResult.points;
      factors.add(weightResult);
    }

    // 7. Analyze persistent fatigue
    final fatigueResult = _analyzePersistentFatigue(symptomLogs);
    if (fatigueResult != null) {
      totalScore += fatigueResult.points;
      factors.add(fatigueResult);
    }

    // Determine risk label based on score
    final (label, description) = _getRiskInterpretation(totalScore);

    return HormonalPatternResult(
      score: totalScore,
      riskLabel: label,
      riskDescription: description,
      contributingFactors: factors,
      hasEnoughData: true,
    );
  }

  /// Analyze cycle length variation
  static ContributingFactor? _analyzeCycleIrregularity(List<CycleData> cycles) {
    if (cycles.length < 2) return null;

    final lengths = cycles.map((c) => c.cycleLength).toList();
    final maxLength = lengths.reduce((a, b) => a > b ? a : b);
    final minLength = lengths.reduce((a, b) => a < b ? a : b);
    final variation = maxLength - minLength;

    if (variation > 7) {
      return ContributingFactor(
        name: 'Irregular Cycles',
        description: 'Cycle length varies by more than 7 days ($variation days variation observed)',
        points: 2,
        icon: '📊',
      );
    }
    return null;
  }

  /// Analyze for long cycle gaps (> 35 days)
  static ContributingFactor? _analyzeLongCycles(List<CycleData> cycles) {
    final longCycles = cycles.where((c) => c.cycleLength > 35).toList();
    
    if (longCycles.isNotEmpty) {
      final percentage = (longCycles.length / cycles.length * 100).round();
      return ContributingFactor(
        name: 'Extended Cycle Length',
        description: '$percentage% of cycles exceed 35 days',
        points: 3,
        icon: '📅',
      );
    }
    return null;
  }

  /// Analyze for missed periods (gaps > 45 days suggest missed period)
  static ContributingFactor? _analyzeMissedPeriods(List<CycleData> cycles) {
    if (cycles.length < 2) return null;

    int missedCount = 0;
    
    // Sort cycles by date (newest first)
    final sortedCycles = List<CycleData>.from(cycles)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    for (int i = 0; i < sortedCycles.length - 1; i++) {
      final gap = sortedCycles[i].startDate
          .difference(sortedCycles[i + 1].startDate)
          .inDays;
      
      // Gap > 45 days suggests a missed period
      if (gap > 45) {
        missedCount++;
      }
    }

    if (missedCount == 0) return null;

    final isFrequent = missedCount >= 2;
    return ContributingFactor(
      name: isFrequent ? 'Frequent Missed Periods' : 'Occasional Missed Period',
      description: '$missedCount instance(s) of extended gaps observed',
      points: isFrequent ? 4 : 2,
      icon: '⏭️',
    );
  }

  /// Analyze acne patterns from symptom logs
  static ContributingFactor? _analyzeAcne(List<SymptomLog> logs) {
    final logsWithAcne = logs.where((l) => l.hasAcne == true).toList();
    
    if (logsWithAcne.isEmpty) return null;

    // Check severity - if any log has severe acne
    final hasSevereAcne = logsWithAcne.any((l) => l.acneSeverity == AcneSeverity.severe);
    
    if (hasSevereAcne) {
      return const ContributingFactor(
        name: 'Severe Acne',
        description: 'Persistent severe acne patterns observed',
        points: 3,
        icon: '🔴',
      );
    } else if (logsWithAcne.length >= 3) {
      return const ContributingFactor(
        name: 'Recurring Acne',
        description: 'Mild acne patterns noted in multiple logs',
        points: 1,
        icon: '🟡',
      );
    }
    return null;
  }

  /// Analyze excess hair growth
  static ContributingFactor? _analyzeExcessHairGrowth(List<SymptomLog> logs) {
    final hasExcessHair = logs.any((l) => l.excessHairGrowth == true);
    
    if (hasExcessHair) {
      return const ContributingFactor(
        name: 'Excess Hair Growth',
        description: 'Unusual hair growth patterns reported',
        points: 3,
        icon: '🌿',
      );
    }
    return null;
  }

  /// Analyze weight gain
  static ContributingFactor? _analyzeWeightGain(List<SymptomLog> logs) {
    final hasWeightGain = logs.any((l) => l.weightGain == true);
    
    if (hasWeightGain) {
      return const ContributingFactor(
        name: 'Weight Changes',
        description: 'Unexplained weight gain reported',
        points: 2,
        icon: '⚖️',
      );
    }
    return null;
  }

  /// Analyze persistent fatigue patterns
  static ContributingFactor? _analyzePersistentFatigue(List<SymptomLog> logs) {
    if (logs.length < 5) return null;

    // Check recent logs for high fatigue (>= 7)
    final recentLogs = logs.take(14).toList();
    final highFatigueLogs = recentLogs.where((l) => l.fatigueLevel >= 7).toList();
    
    // If more than 40% of recent logs show high fatigue
    if (highFatigueLogs.length >= (recentLogs.length * 0.4)) {
      return ContributingFactor(
        name: 'Persistent Fatigue',
        description: 'Consistently elevated fatigue levels observed',
        points: 1,
        icon: '😴',
      );
    }
    return null;
  }

  /// Get risk interpretation based on total score
  /// Returns (label, description)
  static (String, String) _getRiskInterpretation(int score) {
    if (score >= 15) {
      return (
        'PCOS-like Pattern',
        'Multiple indicators suggest hormonal patterns commonly associated with PCOS. Consider consulting a healthcare provider for professional evaluation.',
      );
    } else if (score >= 9) {
      return (
        'Strong PCOD Tendency',
        'Several indicators point toward hormonal imbalances. Tracking consistently and speaking with a doctor may provide more clarity.',
      );
    } else if (score >= 5) {
      return (
        'Possible PCOD Pattern',
        'Some indicators suggest potential hormonal variations. Continue tracking and monitor any changes.',
      );
    } else {
      return (
        'Normal Variation',
        'Your patterns appear within typical ranges. Continue tracking for ongoing awareness.',
      );
    }
  }
}
