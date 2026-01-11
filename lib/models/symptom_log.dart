/// Acne severity levels for PCOD awareness tracking
enum AcneSeverity { none, mild, severe }

/// Flow intensity levels
enum FlowIntensity { none, spotting, light, medium, heavy }

/// Discharge type for cycle tracking
enum DischargeType { none, dry, sticky, creamy, watery, eggWhite }

/// Mood states for emotional tracking
enum MoodState { happy, calm, anxious, irritable, sad, energetic }

/// Pain type flags
class PainTypes {
  final bool cramps;
  final bool headache;
  final bool backache;
  final bool breastPain;
  final bool jointPain;
  final bool nausea;

  const PainTypes({
    this.cramps = false,
    this.headache = false,
    this.backache = false,
    this.breastPain = false,
    this.jointPain = false,
    this.nausea = false,
  });

  bool get hasPain => cramps || headache || backache || breastPain || jointPain || nausea;
  
  int get painCount => [cramps, headache, backache, breastPain, jointPain, nausea]
      .where((p) => p).length;

  PainTypes copyWith({
    bool? cramps,
    bool? headache,
    bool? backache,
    bool? breastPain,
    bool? jointPain,
    bool? nausea,
  }) {
    return PainTypes(
      cramps: cramps ?? this.cramps,
      headache: headache ?? this.headache,
      backache: backache ?? this.backache,
      breastPain: breastPain ?? this.breastPain,
      jointPain: jointPain ?? this.jointPain,
      nausea: nausea ?? this.nausea,
    );
  }

  Map<String, dynamic> toJson() => {
    'cramps': cramps,
    'headache': headache,
    'backache': backache,
    'breastPain': breastPain,
    'jointPain': jointPain,
    'nausea': nausea,
  };

  factory PainTypes.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PainTypes();
    return PainTypes(
      cramps: json['cramps'] as bool? ?? false,
      headache: json['headache'] as bool? ?? false,
      backache: json['backache'] as bool? ?? false,
      breastPain: json['breastPain'] as bool? ?? false,
      jointPain: json['jointPain'] as bool? ?? false,
      nausea: json['nausea'] as bool? ?? false,
    );
  }
}

/// Enhanced symptom logging model for comprehensive health tracking
class SymptomLog {
  final DateTime date;
  
  // Core tracking (0-10 scales)
  final int painLevel;
  final int moodLevel;
  final int fatigueLevel;
  final int stressLevel;
  final int energyLevel;
  
  // Flow tracking
  final FlowIntensity flowIntensity;
  
  // Detailed pain types
  final PainTypes painTypes;
  
  // Mood state
  final MoodState? moodState;
  
  // Discharge tracking
  final DischargeType dischargeType;
  
  // Sleep tracking
  final double? sleepHours;
  final int? sleepQuality; // 1-5
  
  // Activity tracking
  final bool didExercise;
  final String? exerciseType;
  final int? exerciseMinutes;
  
  // Sensitive tracking (private)
  final bool? sexualActivity;
  final bool? protectedSex;
  
  // Additional symptoms
  final bool bloating;
  final bool cravings;
  final bool brainFog;
  final bool hotFlashes;
  
  // Notes
  final String notes;
  
  // PCOD/PCOS awareness fields (legacy support)
  final bool? hasAcne;
  final AcneSeverity? acneSeverity;
  final bool? excessHairGrowth;
  final bool? weightGain;

  SymptomLog({
    required this.date,
    this.painLevel = 0,
    this.moodLevel = 5,
    this.fatigueLevel = 0,
    this.stressLevel = 0,
    this.energyLevel = 5,
    this.flowIntensity = FlowIntensity.none,
    this.painTypes = const PainTypes(),
    this.moodState,
    this.dischargeType = DischargeType.none,
    this.sleepHours,
    this.sleepQuality,
    this.didExercise = false,
    this.exerciseType,
    this.exerciseMinutes,
    this.sexualActivity,
    this.protectedSex,
    this.bloating = false,
    this.cravings = false,
    this.brainFog = false,
    this.hotFlashes = false,
    this.notes = '',
    this.hasAcne,
    this.acneSeverity,
    this.excessHairGrowth,
    this.weightGain,
  });

  /// Calculate average symptom severity
  double get averageSeverity => (painLevel + (10 - moodLevel) + fatigueLevel + stressLevel) / 4;

  /// Check if any symptoms were logged for this day
  bool get hasSymptoms => 
      painLevel > 0 || 
      fatigueLevel > 0 || 
      stressLevel > 3 ||
      flowIntensity != FlowIntensity.none ||
      painTypes.hasPain ||
      bloating ||
      cravings;

  /// Get symptom summary for calendar display
  List<String> get symptomIcons {
    final icons = <String>[];
    if (flowIntensity != FlowIntensity.none) icons.add('💧');
    if (painTypes.hasPain || painLevel > 3) icons.add('😣');
    if (moodLevel < 4) icons.add('😔');
    if (fatigueLevel > 5) icons.add('😴');
    if (bloating) icons.add('🫄');
    if (cravings) icons.add('🍫');
    if (didExercise) icons.add('🏃');
    return icons;
  }

  SymptomLog copyWith({
    DateTime? date,
    int? painLevel,
    int? moodLevel,
    int? fatigueLevel,
    int? stressLevel,
    int? energyLevel,
    FlowIntensity? flowIntensity,
    PainTypes? painTypes,
    MoodState? moodState,
    DischargeType? dischargeType,
    double? sleepHours,
    int? sleepQuality,
    bool? didExercise,
    String? exerciseType,
    int? exerciseMinutes,
    bool? sexualActivity,
    bool? protectedSex,
    bool? bloating,
    bool? cravings,
    bool? brainFog,
    bool? hotFlashes,
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
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      painTypes: painTypes ?? this.painTypes,
      moodState: moodState ?? this.moodState,
      dischargeType: dischargeType ?? this.dischargeType,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      didExercise: didExercise ?? this.didExercise,
      exerciseType: exerciseType ?? this.exerciseType,
      exerciseMinutes: exerciseMinutes ?? this.exerciseMinutes,
      sexualActivity: sexualActivity ?? this.sexualActivity,
      protectedSex: protectedSex ?? this.protectedSex,
      bloating: bloating ?? this.bloating,
      cravings: cravings ?? this.cravings,
      brainFog: brainFog ?? this.brainFog,
      hotFlashes: hotFlashes ?? this.hotFlashes,
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
      'stressLevel': stressLevel,
      'energyLevel': energyLevel,
      'flowIntensity': flowIntensity.index,
      'painTypes': painTypes.toJson(),
      'moodState': moodState?.index,
      'dischargeType': dischargeType.index,
      'sleepHours': sleepHours,
      'sleepQuality': sleepQuality,
      'didExercise': didExercise,
      'exerciseType': exerciseType,
      'exerciseMinutes': exerciseMinutes,
      'sexualActivity': sexualActivity,
      'protectedSex': protectedSex,
      'bloating': bloating,
      'cravings': cravings,
      'brainFog': brainFog,
      'hotFlashes': hotFlashes,
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
      stressLevel: json['stressLevel'] as int? ?? 0,
      energyLevel: json['energyLevel'] as int? ?? 5,
      flowIntensity: json['flowIntensity'] != null 
          ? FlowIntensity.values[json['flowIntensity'] as int]
          : FlowIntensity.none,
      painTypes: PainTypes.fromJson(json['painTypes'] as Map<String, dynamic>?),
      moodState: json['moodState'] != null 
          ? MoodState.values[json['moodState'] as int]
          : null,
      dischargeType: json['dischargeType'] != null 
          ? DischargeType.values[json['dischargeType'] as int]
          : DischargeType.none,
      sleepHours: (json['sleepHours'] as num?)?.toDouble(),
      sleepQuality: json['sleepQuality'] as int?,
      didExercise: json['didExercise'] as bool? ?? false,
      exerciseType: json['exerciseType'] as String?,
      exerciseMinutes: json['exerciseMinutes'] as int?,
      sexualActivity: json['sexualActivity'] as bool?,
      protectedSex: json['protectedSex'] as bool?,
      bloating: json['bloating'] as bool? ?? false,
      cravings: json['cravings'] as bool? ?? false,
      brainFog: json['brainFog'] as bool? ?? false,
      hotFlashes: json['hotFlashes'] as bool? ?? false,
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
