import '../models/cycle_model.dart';
import '../models/doctor_model.dart';
import '../models/lifestyle_log.dart';
import '../models/symptom_log.dart';

/// Dummy data for the application
class DummyData {
  /// Sample cycle history
  static List<CycleData> get cycleHistory {
    final now = DateTime.now();
    return [
      CycleData(
        startDate: now.subtract(const Duration(days: 28)),
        endDate: now.subtract(const Duration(days: 23)),
        cycleLength: 28,
      ),
      CycleData(
        startDate: now.subtract(const Duration(days: 56)),
        endDate: now.subtract(const Duration(days: 51)),
        cycleLength: 28,
      ),
      CycleData(
        startDate: now.subtract(const Duration(days: 85)),
        endDate: now.subtract(const Duration(days: 80)),
        cycleLength: 29,
      ),
      CycleData(
        startDate: now.subtract(const Duration(days: 112)),
        endDate: now.subtract(const Duration(days: 107)),
        cycleLength: 27,
      ),
      CycleData(
        startDate: now.subtract(const Duration(days: 140)),
        endDate: now.subtract(const Duration(days: 135)),
        cycleLength: 28,
      ),
    ];
  }

  /// Sample symptom logs
  static List<SymptomLog> get symptomLogs {
    final now = DateTime.now();
    return [
      SymptomLog(date: now.subtract(const Duration(days: 1)), painLevel: 3, moodLevel: 6, fatigueLevel: 4),
      SymptomLog(date: now.subtract(const Duration(days: 2)), painLevel: 5, moodLevel: 5, fatigueLevel: 6),
      SymptomLog(date: now.subtract(const Duration(days: 3)), painLevel: 7, moodLevel: 4, fatigueLevel: 7),
      SymptomLog(date: now.subtract(const Duration(days: 4)), painLevel: 6, moodLevel: 4, fatigueLevel: 5),
      SymptomLog(date: now.subtract(const Duration(days: 5)), painLevel: 4, moodLevel: 5, fatigueLevel: 4),
      SymptomLog(date: now.subtract(const Duration(days: 6)), painLevel: 2, moodLevel: 7, fatigueLevel: 3),
      SymptomLog(date: now.subtract(const Duration(days: 7)), painLevel: 1, moodLevel: 8, fatigueLevel: 2),
      SymptomLog(date: now.subtract(const Duration(days: 14)), painLevel: 2, moodLevel: 7, fatigueLevel: 3),
      SymptomLog(date: now.subtract(const Duration(days: 21)), painLevel: 3, moodLevel: 6, fatigueLevel: 4),
      SymptomLog(date: now.subtract(const Duration(days: 28)), painLevel: 6, moodLevel: 5, fatigueLevel: 6),
    ];
  }

  /// Sample lifestyle logs
  static List<LifestyleLog> get lifestyleLogs {
    final now = DateTime.now();
    return [
      LifestyleLog(date: now.subtract(const Duration(days: 1)), sleepHours: 7, stressLevel: 5, activityLevel: 'Moderate'),
      LifestyleLog(date: now.subtract(const Duration(days: 2)), sleepHours: 6, stressLevel: 6, activityLevel: 'Light'),
      LifestyleLog(date: now.subtract(const Duration(days: 3)), sleepHours: 5, stressLevel: 7, activityLevel: 'Sedentary'),
      LifestyleLog(date: now.subtract(const Duration(days: 4)), sleepHours: 7.5, stressLevel: 4, activityLevel: 'Active'),
      LifestyleLog(date: now.subtract(const Duration(days: 5)), sleepHours: 8, stressLevel: 3, activityLevel: 'Moderate'),
      LifestyleLog(date: now.subtract(const Duration(days: 6)), sleepHours: 6.5, stressLevel: 5, activityLevel: 'Light'),
      LifestyleLog(date: now.subtract(const Duration(days: 7)), sleepHours: 7, stressLevel: 4, activityLevel: 'Moderate'),
    ];
  }

  /// Sample doctors list
  static List<Doctor> get doctors {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Gynecologist',
        distance: '2 km',
        phone: '+1 234 567 8901',
        address: '123 Health Street, Medical Center',
        rating: 4.8,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Emily Chen',
        specialty: 'Endocrinologist',
        distance: '4 km',
        phone: '+1 234 567 8902',
        address: '456 Wellness Ave, City Hospital',
        rating: 4.7,
      ),
      Doctor(
        id: '3',
        name: 'Dr. Michelle Roberts',
        specialty: 'Gynecologist',
        distance: '5.5 km',
        phone: '+1 234 567 8903',
        address: '789 Care Blvd, Women\'s Clinic',
        rating: 4.9,
      ),
      Doctor(
        id: '4',
        name: 'Dr. Lisa Thompson',
        specialty: 'Reproductive Endocrinologist',
        distance: '7 km',
        phone: '+1 234 567 8904',
        address: '321 Healing Road, Specialty Center',
        rating: 4.6,
      ),
    ];
  }

  /// Cycle trend data for charts (last 6 months)
  static List<int> get cycleLengthTrend => [28, 27, 29, 28, 28, 27];

  /// Period length data for charts (last 6 months)
  static List<int> get periodLengthTrend => [5, 6, 5, 5, 4, 5];

  /// Monthly symptom averages for charts
  static Map<String, List<double>> get symptomTrends => {
    'pain': [4.2, 3.8, 5.1, 4.5, 4.0, 3.9],
    'mood': [6.0, 5.5, 5.8, 6.2, 6.5, 6.0],
    'fatigue': [4.5, 5.0, 5.5, 4.8, 4.2, 4.0],
  };
}
