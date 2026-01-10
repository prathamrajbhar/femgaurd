/// Cycle data model for period tracking
class CycleData {
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;
  final String notes;

  CycleData({
    required this.startDate,
    this.endDate,
    this.cycleLength = 28,
    this.notes = '',
  });

  /// Calculate the number of days in the period
  int get periodLength {
    if (endDate == null) return 0;
    return endDate!.difference(startDate).inDays + 1;
  }

  CycleData copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? cycleLength,
    String? notes,
  }) {
    return CycleData(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      cycleLength: cycleLength ?? this.cycleLength,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'cycleLength': cycleLength,
      'notes': notes,
    };
  }

  /// Create from JSON
  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
      cycleLength: json['cycleLength'] as int? ?? 28,
      notes: json['notes'] as String? ?? '',
    );
  }
}
