import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Notifications and alerts screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      id: '1',
      title: 'Period Starting Soon',
      message: 'Your period is expected to start in 3 days. Stock up on essentials!',
      icon: Icons.event_rounded,
      color: Color(0xFFE91E63),
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    _NotificationItem(
      id: '2',
      title: 'Log Your Symptoms',
      message: 'Don\'t forget to log how you\'re feeling today for better insights.',
      icon: Icons.add_circle_outline_rounded,
      color: Color(0xFF4CAF50),
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    _NotificationItem(
      id: '3',
      title: 'Health Tip',
      message: 'Staying hydrated during your cycle can help reduce bloating and fatigue.',
      icon: Icons.lightbulb_outline_rounded,
      color: Color(0xFFFF9800),
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    _NotificationItem(
      id: '4',
      title: 'Cycle Completed',
      message: 'Your last cycle was 28 days. This is within the normal range!',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF2196F3),
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    _NotificationItem(
      id: '5',
      title: 'Symptom Pattern Detected',
      message: 'You tend to experience headaches around day 14 of your cycle.',
      icon: Icons.insights_rounded,
      color: Color(0xFF9C27B0),
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: AppColors.statusOrange),
            const SizedBox(width: 10),
            const Text('Clear All?'),
          ],
        ),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusOrange,
            ),
            onPressed: () {
              setState(() => _notifications.clear());
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    
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
        title: Row(
          children: [
            Text('Notifications'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_notifications.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.done_all_rounded, color: AppColors.textSecondary),
              onPressed: _markAllAsRead,
              tooltip: 'Mark all as read',
            ),
            IconButton(
              icon: Icon(Icons.delete_sweep_rounded, color: AppColors.textSecondary),
              onPressed: _clearAll,
              tooltip: 'Clear all',
            ),
          ],
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () => _markAsRead(notification.id),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

/// Notification data class
class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final DateTime time;
  final bool isRead;

  _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.time,
    this.isRead = false,
  });

  _NotificationItem copyWith({bool? isRead}) {
    return _NotificationItem(
      id: id,
      title: title,
      message: message,
      icon: icon,
      color: color,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Notification card widget
class _NotificationCard extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.surface : AppColors.primaryLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: notification.isRead 
              ? null 
              : Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(notification.icon, color: notification.color, size: 22),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification.time),
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
