/// Partner sharing configuration for partner awareness mode
class PartnerSettings {
  final bool isEnabled;
  final String? partnerName;
  
  // Sharing options
  final bool shareCyclePhase;
  final bool sharePredictions;
  final bool shareMoodStatus;
  final bool shareSupportTips;
  
  // Privacy settings
  final bool showDetailedInfo;
  final bool enableNotifications;

  const PartnerSettings({
    this.isEnabled = false,
    this.partnerName,
    this.shareCyclePhase = true,
    this.sharePredictions = true,
    this.shareMoodStatus = false,
    this.shareSupportTips = true,
    this.showDetailedInfo = false,
    this.enableNotifications = false,
  });

  PartnerSettings copyWith({
    bool? isEnabled,
    String? partnerName,
    bool? shareCyclePhase,
    bool? sharePredictions,
    bool? shareMoodStatus,
    bool? shareSupportTips,
    bool? showDetailedInfo,
    bool? enableNotifications,
  }) {
    return PartnerSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      partnerName: partnerName ?? this.partnerName,
      shareCyclePhase: shareCyclePhase ?? this.shareCyclePhase,
      sharePredictions: sharePredictions ?? this.sharePredictions,
      shareMoodStatus: shareMoodStatus ?? this.shareMoodStatus,
      shareSupportTips: shareSupportTips ?? this.shareSupportTips,
      showDetailedInfo: showDetailedInfo ?? this.showDetailedInfo,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }

  Map<String, dynamic> toJson() => {
    'isEnabled': isEnabled,
    'partnerName': partnerName,
    'shareCyclePhase': shareCyclePhase,
    'sharePredictions': sharePredictions,
    'shareMoodStatus': shareMoodStatus,
    'shareSupportTips': shareSupportTips,
    'showDetailedInfo': showDetailedInfo,
    'enableNotifications': enableNotifications,
  };

  factory PartnerSettings.fromJson(Map<String, dynamic> json) {
    return PartnerSettings(
      isEnabled: json['isEnabled'] as bool? ?? false,
      partnerName: json['partnerName'] as String?,
      shareCyclePhase: json['shareCyclePhase'] as bool? ?? true,
      sharePredictions: json['sharePredictions'] as bool? ?? true,
      shareMoodStatus: json['shareMoodStatus'] as bool? ?? false,
      shareSupportTips: json['shareSupportTips'] as bool? ?? true,
      showDetailedInfo: json['showDetailedInfo'] as bool? ?? false,
      enableNotifications: json['enableNotifications'] as bool? ?? false,
    );
  }
}

/// Educational content for partners about cycle phases
class PartnerEducation {
  static const Map<String, PartnerPhaseInfo> phaseInfo = {
    'menstrual': PartnerPhaseInfo(
      phase: 'Menstrual Phase',
      duration: 'Days 1-5',
      whatHappens: 'The uterine lining sheds, causing menstrual bleeding.',
      howSheMightFeel: [
        'Cramping and discomfort',
        'Lower energy levels',
        'Possible mood changes',
        'May feel bloated',
      ],
      howYouCanHelp: [
        'Offer a heating pad for cramps',
        'Be patient and understanding',
        'Help with household tasks',
        'Bring her favorite comfort foods',
        'Give her space if she needs it',
      ],
    ),
    'follicular': PartnerPhaseInfo(
      phase: 'Follicular Phase',
      duration: 'Days 6-14',
      whatHappens: 'Estrogen rises as the body prepares for ovulation.',
      howSheMightFeel: [
        'Increased energy',
        'More social and outgoing',
        'Better mood overall',
        'May feel more confident',
      ],
      howYouCanHelp: [
        'Plan activities together',
        'Support her goals and projects',
        'Enjoy quality time together',
        'Be open to new experiences',
      ],
    ),
    'ovulatory': PartnerPhaseInfo(
      phase: 'Ovulation Phase',
      duration: 'Days 14-16',
      whatHappens: 'An egg is released - the most fertile time.',
      howSheMightFeel: [
        'Peak energy levels',
        'Heightened senses',
        'May feel more attractive',
        'Increased libido',
      ],
      howYouCanHelp: [
        'Be attentive and present',
        'Plan romantic activities',
        'Communicate openly',
        'Be aware this is fertile time',
      ],
    ),
    'luteal': PartnerPhaseInfo(
      phase: 'Luteal Phase',
      duration: 'Days 17-28',
      whatHappens: 'Progesterone rises, then drops before period starts.',
      howSheMightFeel: [
        'PMS symptoms may appear',
        'Mood swings possible',
        'Food cravings',
        'May feel more tired',
        'Breast tenderness',
      ],
      howYouCanHelp: [
        'Be extra patient and kind',
        'Don\'t take mood changes personally',
        'Offer comfort and support',
        'Help reduce stress',
        'Prepare for the cycle to repeat',
      ],
    ),
  };
}

/// Partner phase information model
class PartnerPhaseInfo {
  final String phase;
  final String duration;
  final String whatHappens;
  final List<String> howSheMightFeel;
  final List<String> howYouCanHelp;

  const PartnerPhaseInfo({
    required this.phase,
    required this.duration,
    required this.whatHappens,
    required this.howSheMightFeel,
    required this.howYouCanHelp,
  });
}
