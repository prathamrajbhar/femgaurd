/// Notification model for in-app notifications
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.index,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values[json['type'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

/// Types of notifications
enum NotificationType {
  periodReminder, // Period starting soon
  periodStarted, // Period has started
  symptomReminder, // Reminder to log symptoms
  healthTip, // Daily health tips
  cycleComplete, // Cycle completed
  insightAlert, // Pattern detected
  hydrationReminder, // Hydration reminder
  medicationReminder, // Medication reminder
  doctorSuggestion, // Suggest doctor consultation
  general, // General notifications
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.periodReminder:
        return 'Period Reminder';
      case NotificationType.periodStarted:
        return 'Period Started';
      case NotificationType.symptomReminder:
        return 'Symptom Logging';
      case NotificationType.healthTip:
        return 'Health Tip';
      case NotificationType.cycleComplete:
        return 'Cycle Complete';
      case NotificationType.insightAlert:
        return 'Pattern Insight';
      case NotificationType.hydrationReminder:
        return 'Hydration';
      case NotificationType.medicationReminder:
        return 'Medication';
      case NotificationType.doctorSuggestion:
        return 'Health Alert';
      case NotificationType.general:
        return 'Notification';
    }
  }

  String get emoji {
    switch (this) {
      case NotificationType.periodReminder:
        return '📅';
      case NotificationType.periodStarted:
        return '🔴';
      case NotificationType.symptomReminder:
        return '📝';
      case NotificationType.healthTip:
        return '💡';
      case NotificationType.cycleComplete:
        return '✅';
      case NotificationType.insightAlert:
        return '📊';
      case NotificationType.hydrationReminder:
        return '💧';
      case NotificationType.medicationReminder:
        return '💊';
      case NotificationType.doctorSuggestion:
        return '🩺';
      case NotificationType.general:
        return '🔔';
    }
  }
}
