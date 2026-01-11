import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import 'daily_logging_screen.dart';

/// Full calendar screen for cycle tracking
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    HapticFeedback.selectionClick();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    HapticFeedback.selectionClick();
  }

  void _goToToday() {
    setState(() {
      _currentMonth = DateTime.now();
      _selectedDate = DateTime.now();
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final periodDays = appState.periodDays;
        final nextPeriod = appState.nextPeriodDate;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppColors.softShadow,
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Cycle Calendar'),
            actions: [
              TextButton.icon(
                onPressed: _goToToday,
                icon: Icon(Icons.today_rounded, color: AppColors.primary, size: 20),
                label: Text(
                  'Today',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Month navigation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _previousMonth,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                      ),
                    ),
                    Text(
                      _getMonthYearString(_currentMonth),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      onPressed: _nextMonth,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Weekday headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                    return SizedBox(
                      width: 40,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              
              // Calendar grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: _getDaysInMonthGrid(),
                    itemBuilder: (context, index) {
                      final date = _getDateForIndex(index);
                      if (date == null) return const SizedBox();
                      
                      final isToday = _isToday(date);
                      final isSelected = _selectedDate != null &&
                          date.year == _selectedDate!.year &&
                          date.month == _selectedDate!.month &&
                          date.day == _selectedDate!.day;
                      final isPeriodDay = periodDays.contains(DateTime(date.year, date.month, date.day));
                      final isPredictedPeriod = _isPredictedPeriod(date, nextPeriod, appState.userProfile.cycleLength);
                      final isFertileWindow = _isFertileWindow(date, appState);
                      final isCurrentMonth = date.month == _currentMonth.month;
                      
                      final hasSymptomLog = appState.symptomLogs.any((log) =>
                          log.date.year == date.year &&
                          log.date.month == date.month &&
                          log.date.day == date.day);
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedDate = date);
                          HapticFeedback.selectionClick();
                        },
                        onLongPress: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DailyLoggingScreen(selectedDate: date),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: isPeriodDay
                                ? LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])
                                : isPredictedPeriod
                                    ? LinearGradient(colors: [
                                        AppColors.primary.withValues(alpha: 0.3),
                                        AppColors.primaryLight
                                      ])
                                    : null,
                            color: isSelected && !isPeriodDay && !isPredictedPeriod
                                ? AppColors.primaryLight
                                : isFertileWindow && !isPeriodDay
                                    ? AppColors.accent.withValues(alpha: 0.2)
                                    : null,
                            borderRadius: BorderRadius.circular(12),
                            border: isToday
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: isPeriodDay
                                        ? Colors.white
                                        : isCurrentMonth
                                            ? AppColors.textPrimary
                                            : AppColors.textLight,
                                    fontWeight: isToday || isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (isFertileWindow && !isPeriodDay)
                                Positioned(
                                  bottom: 4,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              // Symptom log indicator dots
                              if (hasSymptomLog)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Legend
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendItem(
                          color: AppColors.primary,
                          label: 'Period',
                        ),
                        _LegendItem(
                          color: AppColors.primaryLight,
                          label: 'Predicted',
                          isBordered: true,
                        ),
                        _LegendItem(
                          color: AppColors.accent,
                          label: 'Fertile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Selected date info
                    if (_selectedDate != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryDark],
                                ),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Text(
                                '${_selectedDate!.day}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getFullDateString(_selectedDate!),
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _getDateStatus(_selectedDate!, periodDays, nextPeriod, appState),
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Quick log button
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DailyLoggingScreen(selectedDate: _selectedDate),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Log',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getFullDateString(DateTime date) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  int _getDaysInMonthGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startPadding = firstDay.weekday % 7;
    final totalDays = lastDay.day + startPadding;
    return ((totalDays / 7).ceil()) * 7;
  }

  DateTime? _getDateForIndex(int index) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startPadding = firstDay.weekday % 7;
    final dayOffset = index - startPadding;
    
    if (dayOffset < 0) {
      // Previous month
      return DateTime(_currentMonth.year, _currentMonth.month, dayOffset + 1);
    }
    
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    if (dayOffset >= lastDay.day) {
      // Next month
      return DateTime(_currentMonth.year, _currentMonth.month + 1, dayOffset - lastDay.day + 1);
    }
    
    return DateTime(_currentMonth.year, _currentMonth.month, dayOffset + 1);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isPredictedPeriod(DateTime date, DateTime nextPeriod, int cycleLength) {
    // Show predicted period for next 5 days starting from nextPeriod
    if (date.isBefore(DateTime.now())) return false;
    final diff = date.difference(nextPeriod).inDays;
    return diff >= 0 && diff < 5;
  }

  bool _isFertileWindow(DateTime date, AppState appState) {
    if (appState.cycleHistory.isEmpty) return false;
    final cycleLength = appState.userProfile.cycleLength;
    final lastPeriod = appState.cycleHistory.first.startDate;
    final daysSince = date.difference(lastPeriod).inDays;
    final cycleDay = (daysSince % cycleLength) + 1;
    // Fertile window: approximately days 10-17 of cycle
    return cycleDay >= 10 && cycleDay <= 17;
  }

  String _getDateStatus(DateTime date, Set<DateTime> periodDays, DateTime nextPeriod, AppState appState) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    if (periodDays.contains(normalizedDate)) {
      return 'Period day';
    }
    
    if (_isPredictedPeriod(date, nextPeriod, appState.userProfile.cycleLength)) {
      return 'Predicted period';
    }
    
    if (_isFertileWindow(date, appState)) {
      return 'Fertile window';
    }
    
    return 'Regular day';
  }
}

/// Legend item widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBordered;

  const _LegendItem({
    required this.color,
    required this.label,
    this.isBordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isBordered ? color.withValues(alpha: 0.3) : color,
            borderRadius: BorderRadius.circular(4),
            border: isBordered ? Border.all(color: color, width: 2) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
