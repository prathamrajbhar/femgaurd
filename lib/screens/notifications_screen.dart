import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';

/// Notifications and alerts screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().refreshNotifications();
    });
  }

  void _markAsRead(String id) {
    context.read<AppState>().markNotificationAsRead(id);
    HapticFeedback.lightImpact();
  }

  void _markAllAsRead() {
    context.read<AppState>().markAllNotificationsAsRead();
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

  void _deleteNotification(String id) {
    context.read<AppState>().deleteNotification(id);
    HapticFeedback.lightImpact();
  }

  void _clearAll() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: colorScheme.error),
            const SizedBox(width: 10),
            const Text('Clear All?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear all notifications?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () {
              context.read<AppState>().clearAllNotifications();
              Navigator.pop(dialogContext);
              HapticFeedback.mediumImpact();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    _markAsRead(notification.id);

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.periodReminder:
      case NotificationType.periodStarted:
        Navigator.pushNamed(context, '/cycle-tracking');
        break;
      case NotificationType.symptomReminder:
        Navigator.pushNamed(context, '/symptom-logging');
        break;
      case NotificationType.healthTip:
        Navigator.pushNamed(context, '/health-tips');
        break;
      case NotificationType.insightAlert:
        Navigator.pushNamed(context, '/insights');
        break;
      case NotificationType.doctorSuggestion:
        Navigator.pushNamed(context, '/doctors');
        break;
      case NotificationType.cycleComplete:
        Navigator.pushNamed(context, '/cycle-history');
        break;
      default:
        // Just mark as read, no navigation
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorScheme.onSurface,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<AppState>(
          builder: (context, appState, child) {
            final unreadCount = appState.unreadNotificationCount;
            return Row(
              children: [
                Text(
                  'Notifications',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              if (appState.notifications.isEmpty)
                return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.done_all_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: _markAllAsRead,
                    tooltip: 'Mark all as read',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_sweep_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: _clearAll,
                    tooltip: 'Clear all',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final notifications = appState.notifications;

          if (notifications.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              appState.refreshNotifications();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(notification),
                  onDismiss: () => _deleteNotification(notification.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              context.read<AppState>().refreshNotifications();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

/// Notification card widget
class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeColor = _getTypeColor(notification.type, colorScheme);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_rounded, color: colorScheme.onError),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? colorScheme.surface
                : colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: notification.isRead
                ? Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  )
                : Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
            boxShadow: AppColors.softShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  notification.type.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
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
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification.type.displayName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(notification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case NotificationType.periodReminder:
      case NotificationType.periodStarted:
        return colorScheme.error;
      case NotificationType.symptomReminder:
        return colorScheme.primary;
      case NotificationType.healthTip:
        return colorScheme.tertiary;
      case NotificationType.cycleComplete:
        return AppColors.statusGreen;
      case NotificationType.insightAlert:
        return colorScheme.secondary;
      case NotificationType.hydrationReminder:
        return Colors.blue;
      case NotificationType.medicationReminder:
        return colorScheme.primary;
      case NotificationType.doctorSuggestion:
        return AppColors.statusOrange;
      case NotificationType.general:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
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
