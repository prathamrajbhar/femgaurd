/// Symptom logging model for tracking pain, mood, and fatigue
class SymptomLog {
  final DateTime date;
  final int painLevel; // 0-10
  final int moodLevel; // 0-10
  final int fatigueLevel; // 0-10
  final String notes;

  SymptomLog({
    required this.date,
    this.painLevel = 0,
    this.moodLevel = 5,
    this.fatigueLevel = 0,
    this.notes = '',
  });

  /// Calculate average symptom severity
  double get averageSeverity => (painLevel + (10 - moodLevel) + fatigueLevel) / 3;

  SymptomLog copyWith({
    DateTime? date,
    int? painLevel,
    int? moodLevel,
    int? fatigueLevel,
    String? notes,
  }) {
    return SymptomLog(
      date: date ?? this.date,
      painLevel: painLevel ?? this.painLevel,
      moodLevel: moodLevel ?? this.moodLevel,
      fatigueLevel: fatigueLevel ?? this.fatigueLevel,
      notes: notes ?? this.notes,
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
    );
  }
}
