/// Acne severity levels for PCOD awareness tracking
enum AcneSeverity { none, mild, severe }

/// Symptom logging model for tracking pain, mood, and fatigue
class SymptomLog {
  final DateTime date;
  final int painLevel; // 0-10
  final int moodLevel; // 0-10
  final int fatigueLevel; // 0-10
  final String notes;
  
  // Optional PCOD/PCOS awareness fields
  final bool? hasAcne;
  final AcneSeverity? acneSeverity;
  final bool? excessHairGrowth;
  final bool? weightGain;

  SymptomLog({
    required this.date,
    this.painLevel = 0,
    this.moodLevel = 5,
    this.fatigueLevel = 0,
    this.notes = '',
    this.hasAcne,
    this.acneSeverity,
    this.excessHairGrowth,
    this.weightGain,
  });

  /// Calculate average symptom severity
  double get averageSeverity => (painLevel + (10 - moodLevel) + fatigueLevel) / 3;

  SymptomLog copyWith({
    DateTime? date,
    int? painLevel,
    int? moodLevel,
    int? fatigueLevel,
    String? notes,
    bool? hasAcne,
    AcneSeverity? acneSeverity,
    bool? excessHairGrowth,
    bool? weightGain,
  }) {
    return SymptomLog(
      date: date ?? this.date,
      painLevel: painLevel ?? this.painLevel,
      moodLevel: moodLevel ?? this.moodLevel,
      fatigueLevel: fatigueLevel ?? this.fatigueLevel,
      notes: notes ?? this.notes,
      hasAcne: hasAcne ?? this.hasAcne,
      acneSeverity: acneSeverity ?? this.acneSeverity,
      excessHairGrowth: excessHairGrowth ?? this.excessHairGrowth,
      weightGain: weightGain ?? this.weightGain,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'painLevel': painLevel,
      'moodLevel': moodLevel,
      'fatigueLevel': fatigueLevel,
      'notes': notes,
      'hasAcne': hasAcne,
      'acneSeverity': acneSeverity?.index,
      'excessHairGrowth': excessHairGrowth,
      'weightGain': weightGain,
    };
  }

  /// Create from JSON
  factory SymptomLog.fromJson(Map<String, dynamic> json) {
    return SymptomLog(
      date: DateTime.parse(json['date'] as String),
      painLevel: json['painLevel'] as int? ?? 0,
      moodLevel: json['moodLevel'] as int? ?? 5,
      fatigueLevel: json['fatigueLevel'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      hasAcne: json['hasAcne'] as bool?,
      acneSeverity: json['acneSeverity'] != null
          ? AcneSeverity.values[json['acneSeverity'] as int]
          : null,
      excessHairGrowth: json['excessHairGrowth'] as bool?,
      weightGain: json['weightGain'] as bool?,
    );
  }
}
