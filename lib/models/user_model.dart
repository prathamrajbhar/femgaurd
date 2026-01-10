/// User profile model for storing user data
class UserProfile {
  final int? age;
  final int cycleLength;
  final DateTime? lastPeriodDate;
  final String lifestyleLevel; // Low, Medium, High
  final bool hasCompletedOnboarding;
  final bool hasAcceptedConsent;

  UserProfile({
    this.age,
    this.cycleLength = 28,
    this.lastPeriodDate,
    this.lifestyleLevel = 'Medium',
    this.hasCompletedOnboarding = false,
    this.hasAcceptedConsent = false,
  });

  UserProfile copyWith({
    int? age,
    int? cycleLength,
    DateTime? lastPeriodDate,
    String? lifestyleLevel,
    bool? hasCompletedOnboarding,
    bool? hasAcceptedConsent,
  }) {
    return UserProfile(
      age: age ?? this.age,
      cycleLength: cycleLength ?? this.cycleLength,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      lifestyleLevel: lifestyleLevel ?? this.lifestyleLevel,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasAcceptedConsent: hasAcceptedConsent ?? this.hasAcceptedConsent,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'cycleLength': cycleLength,
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'lifestyleLevel': lifestyleLevel,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'hasAcceptedConsent': hasAcceptedConsent,
    };
  }

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: json['age'] as int?,
      cycleLength: json['cycleLength'] as int? ?? 28,
      lastPeriodDate: json['lastPeriodDate'] != null 
          ? DateTime.parse(json['lastPeriodDate'] as String) 
          : null,
      lifestyleLevel: json['lifestyleLevel'] as String? ?? 'Medium',
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      hasAcceptedConsent: json['hasAcceptedConsent'] as bool? ?? false,
    );
  }
}
