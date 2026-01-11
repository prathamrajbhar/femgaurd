/// Pregnancy symptom types
enum PregnancySymptomType {
  nausea,
  fatigue,
  backPain,
  breastTenderness,
  moodSwings,
  foodAversions,
  cravings,
  headache,
  dizziness,
  swelling,
  contractions,
  kicksMovements,
}

/// Pregnancy symptom log entry
class PregnancySymptom {
  final DateTime date;
  final PregnancySymptomType type;
  final int severity; // 1-5
  final String? notes;

  const PregnancySymptom({
    required this.date,
    required this.type,
    this.severity = 3,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'type': type.index,
    'severity': severity,
    'notes': notes,
  };

  factory PregnancySymptom.fromJson(Map<String, dynamic> json) {
    return PregnancySymptom(
      date: DateTime.parse(json['date'] as String),
      type: PregnancySymptomType.values[json['type'] as int],
      severity: json['severity'] as int? ?? 3,
      notes: json['notes'] as String?,
    );
  }
}

/// Doctor visit record
class DoctorVisit {
  final DateTime date;
  final String doctorName;
  final String visitType; // e.g., "Ultrasound", "Checkup", "Blood Test"
  final String? notes;
  final bool isUpcoming;

  const DoctorVisit({
    required this.date,
    required this.doctorName,
    required this.visitType,
    this.notes,
    this.isUpcoming = false,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'doctorName': doctorName,
    'visitType': visitType,
    'notes': notes,
    'isUpcoming': isUpcoming,
  };

  factory DoctorVisit.fromJson(Map<String, dynamic> json) {
    return DoctorVisit(
      date: DateTime.parse(json['date'] as String),
      doctorName: json['doctorName'] as String,
      visitType: json['visitType'] as String,
      notes: json['notes'] as String?,
      isUpcoming: json['isUpcoming'] as bool? ?? false,
    );
  }
}

/// Pregnancy data model for tracking pregnancy journey
class PregnancyData {
  final DateTime dueDate;
  final DateTime? conceptionDate;
  final DateTime? lastPeriodDate;
  final List<PregnancySymptom> symptoms;
  final List<DoctorVisit> doctorVisits;
  final List<String> notes;
  final bool isActive;

  const PregnancyData({
    required this.dueDate,
    this.conceptionDate,
    this.lastPeriodDate,
    this.symptoms = const [],
    this.doctorVisits = const [],
    this.notes = const [],
    this.isActive = true,
  });

  /// Calculate current pregnancy week (1-42)
  int get currentWeek {
    final startDate = lastPeriodDate ?? conceptionDate?.subtract(const Duration(days: 14)) ?? 
        dueDate.subtract(const Duration(days: 280));
    final daysSinceStart = DateTime.now().difference(startDate).inDays;
    return (daysSinceStart / 7).floor() + 1;
  }

  /// Get current trimester (1, 2, or 3)
  int get trimester {
    if (currentWeek <= 12) return 1;
    if (currentWeek <= 27) return 2;
    return 3;
  }

  /// Days remaining until due date
  int get daysRemaining {
    final remaining = dueDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  /// Get baby size comparison for current week
  String get babySizeComparison {
    final sizes = {
      4: 'Poppy seed',
      5: 'Sesame seed',
      6: 'Lentil',
      7: 'Blueberry',
      8: 'Kidney bean',
      9: 'Grape',
      10: 'Kumquat',
      11: 'Fig',
      12: 'Lime',
      13: 'Peapod',
      14: 'Lemon',
      15: 'Apple',
      16: 'Avocado',
      17: 'Pear',
      18: 'Bell pepper',
      19: 'Tomato',
      20: 'Banana',
      21: 'Carrot',
      22: 'Papaya',
      23: 'Mango',
      24: 'Corn on the cob',
      25: 'Rutabaga',
      26: 'Scallion',
      27: 'Cauliflower',
      28: 'Eggplant',
      29: 'Butternut squash',
      30: 'Cabbage',
      31: 'Coconut',
      32: 'Squash',
      33: 'Pineapple',
      34: 'Cantaloupe',
      35: 'Honeydew melon',
      36: 'Romaine lettuce',
      37: 'Swiss chard',
      38: 'Leek',
      39: 'Mini watermelon',
      40: 'Small pumpkin',
    };
    return sizes[currentWeek] ?? (currentWeek < 4 ? 'Too early' : 'Full term');
  }

  /// Get weekly development tip
  String get weeklyTip {
    final tips = {
      1: "Track your last period date to estimate conception.",
      4: "The neural tube is forming - take your prenatal vitamins!",
      8: "Your baby's heart is beating! Consider scheduling your first ultrasound.",
      12: "End of first trimester! Morning sickness should start easing.",
      16: "You might start feeling baby movements soon!",
      20: "Halfway there! Time for the anatomy scan.",
      24: "Baby can hear your voice now. Talk and sing to them!",
      28: "Third trimester begins. Start thinking about birth plans.",
      32: "Baby is practicing breathing movements.",
      36: "Baby is considered full-term soon. Pack your hospital bag!",
      40: "Your due date is here! Every day now...",
    };
    
    for (final week in tips.keys.toList().reversed) {
      if (currentWeek >= week) return tips[week]!;
    }
    return "Congratulations on your pregnancy journey!";
  }

  PregnancyData copyWith({
    DateTime? dueDate,
    DateTime? conceptionDate,
    DateTime? lastPeriodDate,
    List<PregnancySymptom>? symptoms,
    List<DoctorVisit>? doctorVisits,
    List<String>? notes,
    bool? isActive,
  }) {
    return PregnancyData(
      dueDate: dueDate ?? this.dueDate,
      conceptionDate: conceptionDate ?? this.conceptionDate,
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      symptoms: symptoms ?? this.symptoms,
      doctorVisits: doctorVisits ?? this.doctorVisits,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'dueDate': dueDate.toIso8601String(),
    'conceptionDate': conceptionDate?.toIso8601String(),
    'lastPeriodDate': lastPeriodDate?.toIso8601String(),
    'symptoms': symptoms.map((s) => s.toJson()).toList(),
    'doctorVisits': doctorVisits.map((v) => v.toJson()).toList(),
    'notes': notes,
    'isActive': isActive,
  };

  factory PregnancyData.fromJson(Map<String, dynamic> json) {
    return PregnancyData(
      dueDate: DateTime.parse(json['dueDate'] as String),
      conceptionDate: json['conceptionDate'] != null 
          ? DateTime.parse(json['conceptionDate'] as String) 
          : null,
      lastPeriodDate: json['lastPeriodDate'] != null 
          ? DateTime.parse(json['lastPeriodDate'] as String) 
          : null,
      symptoms: (json['symptoms'] as List<dynamic>?)
          ?.map((s) => PregnancySymptom.fromJson(s as Map<String, dynamic>))
          .toList() ?? [],
      doctorVisits: (json['doctorVisits'] as List<dynamic>?)
          ?.map((v) => DoctorVisit.fromJson(v as Map<String, dynamic>))
          .toList() ?? [],
      notes: (json['notes'] as List<dynamic>?)?.cast<String>() ?? [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
