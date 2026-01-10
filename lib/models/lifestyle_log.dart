/// Lifestyle tracking model for sleep, stress, and activity
class LifestyleLog {
  final DateTime date;
  final double sleepHours; // 0-12
  final int stressLevel; // 0-10
  final String activityLevel; // Sedentary, Light, Moderate, Active, Very Active

  LifestyleLog({
    required this.date,
    this.sleepHours = 7.0,
    this.stressLevel = 5,
    this.activityLevel = 'Moderate',
  });

  LifestyleLog copyWith({
    DateTime? date,
    double? sleepHours,
    int? stressLevel,
    String? activityLevel,
  }) {
    return LifestyleLog(
      date: date ?? this.date,
      sleepHours: sleepHours ?? this.sleepHours,
      stressLevel: stressLevel ?? this.stressLevel,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'sleepHours': sleepHours,
      'stressLevel': stressLevel,
      'activityLevel': activityLevel,
    };
  }

  /// Create from JSON
  factory LifestyleLog.fromJson(Map<String, dynamic> json) {
    return LifestyleLog(
      date: DateTime.parse(json['date'] as String),
      sleepHours: (json['sleepHours'] as num?)?.toDouble() ?? 7.0,
      stressLevel: json['stressLevel'] as int? ?? 5,
      activityLevel: json['activityLevel'] as String? ?? 'Moderate',
    );
  }
}
