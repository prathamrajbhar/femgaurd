import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../models/cycle_model.dart';
import '../models/lifestyle_log.dart';
import '../models/symptom_log.dart';
import '../models/user_model.dart';
import '../dummy_data/dummy_data.dart';
import '../utils/constants.dart';
import '../utils/app_theme.dart';

/// App state management using ChangeNotifier (Provider pattern)
/// Now with local storage persistence
class AppState extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // User profile
  UserProfile _userProfile = UserProfile();
  UserProfile get userProfile => _userProfile;

  // Cycle data
  List<CycleData> _cycleHistory = [];
  List<CycleData> get cycleHistory => _cycleHistory;

  // Symptom logs
  List<SymptomLog> _symptomLogs = [];
  List<SymptomLog> get symptomLogs => _symptomLogs;

  // Lifestyle logs
  List<LifestyleLog> _lifestyleLogs = [];
  List<LifestyleLog> get lifestyleLogs => _lifestyleLogs;

  // Chat messages
  List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => _chatMessages;

  // Orange alert counter
  int _orangeAlertCount = 0;
  int get orangeAlertCount => _orangeAlertCount;

  // Notifications enabled
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  // Selected color theme
  ColorTheme _selectedTheme = ColorTheme.rose;
  ColorTheme get selectedTheme => _selectedTheme;

  /// Initialize the app state with local storage
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFromStorage();
    _isInitialized = true;
    notifyListeners();
  }

  /// Load all data from local storage
  Future<void> _loadFromStorage() async {
    // Load theme
    final themeIndex = _prefs.getInt('selectedTheme') ?? 0;
    _selectedTheme = ColorTheme.values[themeIndex];
    AppColors.setTheme(_selectedTheme);

    // Load notifications setting
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;

    // Load orange alert count
    _orangeAlertCount = _prefs.getInt('orangeAlertCount') ?? 0;

    // Load user profile
    final profileJson = _prefs.getString('userProfile');
    if (profileJson != null) {
      _userProfile = UserProfile.fromJson(jsonDecode(profileJson));
    }

    // Load cycle history
    final cyclesJson = _prefs.getStringList('cycleHistory');
    if (cyclesJson != null && cyclesJson.isNotEmpty) {
      _cycleHistory = cyclesJson
          .map((json) => CycleData.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load symptom logs
    final symptomsJson = _prefs.getStringList('symptomLogs');
    if (symptomsJson != null && symptomsJson.isNotEmpty) {
      _symptomLogs = symptomsJson
          .map((json) => SymptomLog.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load lifestyle logs
    final lifestyleJson = _prefs.getStringList('lifestyleLogs');
    if (lifestyleJson != null && lifestyleJson.isNotEmpty) {
      _lifestyleLogs = lifestyleJson
          .map((json) => LifestyleLog.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load chat messages
    final chatJson = _prefs.getStringList('chatMessages');
    if (chatJson != null && chatJson.isNotEmpty) {
      _chatMessages = chatJson
          .map((json) => ChatMessage.fromJson(jsonDecode(json)))
          .toList();
    }
  }

  /// Save all data to local storage
  Future<void> _saveToStorage() async {
    await _prefs.setInt('selectedTheme', _selectedTheme.index);
    await _prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await _prefs.setInt('orangeAlertCount', _orangeAlertCount);
    await _prefs.setString('userProfile', jsonEncode(_userProfile.toJson()));
    
    await _prefs.setStringList(
      'cycleHistory',
      _cycleHistory.map((c) => jsonEncode(c.toJson())).toList(),
    );
    
    await _prefs.setStringList(
      'symptomLogs',
      _symptomLogs.map((s) => jsonEncode(s.toJson())).toList(),
    );
    
    await _prefs.setStringList(
      'lifestyleLogs',
      _lifestyleLogs.map((l) => jsonEncode(l.toJson())).toList(),
    );
    
    await _prefs.setStringList(
      'chatMessages',
      _chatMessages.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }

  /// Set the app color theme
  void setTheme(ColorTheme theme) {
    _selectedTheme = theme;
    AppColors.setTheme(theme);
    _prefs.setInt('selectedTheme', theme.index);
    notifyListeners();
  }

  /// Initialize with dummy data (for first-time users or demo)
  Future<void> initializeDummyData() async {
    _cycleHistory = DummyData.cycleHistory;
    _symptomLogs = DummyData.symptomLogs;
    _lifestyleLogs = DummyData.lifestyleLogs;
    _orangeAlertCount = 8;
    await _saveToStorage();
    notifyListeners();
  }

  /// Check if this is the first launch
  bool get isFirstLaunch => !_userProfile.hasCompletedOnboarding;

  /// Calculate current cycle day
  int get currentCycleDay {
    if (_cycleHistory.isEmpty || _userProfile.lastPeriodDate == null) {
      return 1;
    }
    final lastPeriod = _cycleHistory.first.startDate;
    final daysSince = DateTime.now().difference(lastPeriod).inDays;
    return (daysSince % _userProfile.cycleLength) + 1;
  }

  /// Predict next period date
  DateTime get nextPeriodDate {
    if (_cycleHistory.isEmpty) {
      return DateTime.now().add(Duration(days: _userProfile.cycleLength));
    }
    final lastPeriod = _cycleHistory.first.startDate;
    final daysSince = DateTime.now().difference(lastPeriod).inDays;
    final cyclesCompleted = daysSince ~/ _userProfile.cycleLength;
    return lastPeriod.add(Duration(days: (cyclesCompleted + 1) * _userProfile.cycleLength));
  }

  /// Days until next period
  int get daysUntilNextPeriod {
    return nextPeriodDate.difference(DateTime.now()).inDays;
  }

  /// Get health status based on recent symptoms
  String get healthStatus {
    if (_symptomLogs.isEmpty) return 'green';
    
    final recentLogs = _symptomLogs.where((log) {
      return DateTime.now().difference(log.date).inDays <= 7;
    }).toList();

    if (recentLogs.isEmpty) return 'green';

    final avgSeverity = recentLogs.map((l) => l.averageSeverity).reduce((a, b) => a + b) / recentLogs.length;

    if (avgSeverity > 6) return 'orange';
    if (avgSeverity > 4) return 'yellow';
    return 'green';
  }

  /// Should show doctor suggestion
  bool get shouldShowDoctorSuggestion {
    return _orangeAlertCount >= AppConstants.orangeAlertThreshold;
  }

  // ==================== Actions ====================

  /// Update user profile
  Future<void> updateProfile(UserProfile profile) async {
    _userProfile = profile;
    await _saveToStorage();
    notifyListeners();
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _userProfile = _userProfile.copyWith(hasCompletedOnboarding: true);
    await _saveToStorage();
    notifyListeners();
  }

  /// Accept consent
  Future<void> acceptConsent() async {
    _userProfile = _userProfile.copyWith(hasAcceptedConsent: true);
    await _saveToStorage();
    notifyListeners();
  }

  /// Add a new cycle (period start)
  Future<void> addCycle(CycleData cycle) async {
    _cycleHistory.insert(0, cycle);
    await _saveToStorage();
    notifyListeners();
  }

  /// Update cycle end date
  Future<void> updateCycleEnd(DateTime endDate) async {
    if (_cycleHistory.isNotEmpty) {
      _cycleHistory[0] = _cycleHistory[0].copyWith(endDate: endDate);
      await _saveToStorage();
      notifyListeners();
    }
  }

  /// Start a new period on the given date
  Future<void> startPeriod(DateTime date) async {
    final newCycle = CycleData(
      startDate: date,
      cycleLength: _userProfile.cycleLength,
    );
    _cycleHistory.insert(0, newCycle);
    await _saveToStorage();
    notifyListeners();
  }

  /// End the current period on the given date
  Future<void> endPeriod(DateTime date) async {
    if (_cycleHistory.isNotEmpty) {
      _cycleHistory[0] = _cycleHistory[0].copyWith(endDate: date);
      await _saveToStorage();
      notifyListeners();
    }
  }

  /// Add symptom log
  Future<void> addSymptomLog(SymptomLog log) async {
    _symptomLogs.insert(0, log);
    
    if (log.averageSeverity > 6) {
      _orangeAlertCount++;
    }
    
    await _saveToStorage();
    notifyListeners();
  }

  /// Add lifestyle log
  Future<void> addLifestyleLog(LifestyleLog log) async {
    _lifestyleLogs.insert(0, log);
    await _saveToStorage();
    notifyListeners();
  }

  /// Add chat message and get AI response
  void sendMessage(String text) {
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
    );
    _chatMessages.add(userMessage);
    notifyListeners();

    // Simulate AI response delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final random = Random();
      final responseIndex = random.nextInt(AppConstants.aiResponses.length);
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: AppConstants.aiResponses[responseIndex],
        isUser: false,
      );
      _chatMessages.add(aiMessage);
      _saveToStorage();
      notifyListeners();
    });
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  /// Reset all data
  Future<void> resetAllData() async {
    _userProfile = UserProfile();
    _cycleHistory = [];
    _symptomLogs = [];
    _lifestyleLogs = [];
    _chatMessages = [];
    _orangeAlertCount = 0;
    _notificationsEnabled = true;
    _selectedTheme = ColorTheme.rose;
    AppColors.setTheme(ColorTheme.rose);
    await _prefs.clear();
    notifyListeners();
  }

  /// Mark period days on calendar
  Set<DateTime> get periodDays {
    final days = <DateTime>{};
    for (final cycle in _cycleHistory) {
      if (cycle.endDate != null) {
        var current = cycle.startDate;
        while (!current.isAfter(cycle.endDate!)) {
          days.add(DateTime(current.year, current.month, current.day));
          current = current.add(const Duration(days: 1));
        }
      } else {
        days.add(DateTime(cycle.startDate.year, cycle.startDate.month, cycle.startDate.day));
      }
    }
    return days;
  }
}
