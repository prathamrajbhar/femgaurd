/// App-wide constants and configuration
class AppConstants {
  // App info
  static const String appName = 'HerHealth';
  static const String appTagline = 'Your Menstrual & Hormonal Health Guardian';

  // Default values
  static const int defaultCycleLength = 28;
  static const int defaultPeriodLength = 5;
  static const int minCycleLength = 21;
  static const int maxCycleLength = 40;

  // Lifestyle levels
  static const List<String> lifestyleLevels = ['Low', 'Medium', 'High'];

  // Activity levels
  static const List<String> activityLevels = [
    'Sedentary',
    'Light',
    'Moderate',
    'Active',
    'Very Active',
  ];

  // Risk thresholds
  static const int orangeAlertThreshold = 10; // Show doctor suggestion after 10 orange alerts

  // Onboarding slides
  static const List<Map<String, String>> onboardingData = [
    {
      'title': 'Track Your Cycle',
      'description': 'Log your periods, symptoms, and daily health patterns with ease. Stay informed about your menstrual health journey.',
      'icon': '📅',
    },
    {
      'title': 'AI Pattern Analysis',
      'description': 'Our AI observes long-term patterns in your cycle and symptoms to help you understand your body better.',
      'icon': '🔍',
    },
    {
      'title': 'Awareness, Not Diagnosis',
      'description': 'We provide health awareness insights, not medical diagnoses. Always consult healthcare professionals for medical advice.',
      'icon': '💡',
    },
  ];

  // Disclaimer text
  static const String disclaimerText = '''
This app is designed to help you track and understand your menstrual and hormonal health patterns. 

Important Notice:
• This app does NOT provide medical diagnosis
• All insights are for awareness purposes only
• You maintain complete control over your data
• No data is shared with third parties
• Always consult a healthcare professional for medical concerns

By using this app, you acknowledge that:
1. The app is not a substitute for professional medical advice
2. You should seek medical attention for any health concerns
3. AI insights are observations, not diagnoses
''';

  // Predefined AI responses
  static const List<String> aiResponses = [
    "That's a great question! Based on your patterns, I've noticed some variations in your cycle. This is often normal, but if you're concerned, it's always good to discuss with a healthcare provider.",
    "I understand. Tracking your symptoms consistently can help identify patterns over time. Keep logging, and we'll provide helpful insights.",
    "Many people experience similar symptoms during their cycle. Remember, I'm here to help you understand patterns, but for medical advice, please consult a professional.",
    "Your lifestyle factors like sleep and stress can influence your cycle. Have you noticed any changes in your routine lately?",
    "That's interesting to note! I'll keep track of this and let you know if I observe any patterns related to it.",
    "Thank you for sharing. Remember, every person's cycle is unique. What matters most is understanding your own patterns.",
    "I'm here to support you! If you'd like to learn more about a specific symptom or pattern, feel free to ask.",
    "Stay hydrated and take care of yourself. Self-care during your cycle is important for overall well-being.",
  ];

  // Health insights (simple string list for display)
  static const List<String> sampleInsights = [
    'Your cycle length has varied by a few days over the past months. Minor variations are normal and can be influenced by stress, sleep, and lifestyle factors.',
    'You\'ve reported higher fatigue levels during the luteal phase (days 15-28). This is common and may be related to hormonal changes.',
    'On days with less than 6 hours of sleep, you tend to report higher pain levels. Consider prioritizing rest during your period.',
    'Your mood scores tend to dip slightly before your period. This premenstrual pattern is experienced by many.',
  ];

  // Educational content
  static const List<Map<String, String>> educationalContent = [
    {
      'title': 'Understanding Your Cycle',
      'description': 'A typical menstrual cycle ranges from 21-35 days. Tracking helps you understand your own unique patterns.',
    },
    {
      'title': 'Hormonal Changes',
      'description': 'Estrogen and progesterone levels fluctuate throughout your cycle, affecting mood, energy, and physical symptoms.',
    },
    {
      'title': 'Lifestyle Impact',
      'description': 'Sleep, stress, nutrition, and exercise can all influence your cycle regularity and symptom severity.',
    },
  ];
}

