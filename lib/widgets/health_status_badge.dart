import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Health status badge widget (🟢 / 🟡 / 🟠)
class HealthStatusBadge extends StatelessWidget {
  final String status; // 'green', 'yellow', 'orange'
  final bool showLabel;
  final double size;

  const HealthStatusBadge({
    super.key,
    required this.status,
    this.showLabel = true,
    this.size = 16,
  });

  Color get _color {
    switch (status) {
      case 'green':
        return AppColors.statusGreen;
      case 'yellow':
        return AppColors.statusYellow;
      case 'orange':
        return AppColors.statusOrange;
      default:
        return AppColors.statusGreen;
    }
  }

  String get _label {
    switch (status) {
      case 'green':
        return 'Normal';
      case 'yellow':
        return 'Monitor';
      case 'orange':
        return 'Consider Consultation';
      default:
        return 'Normal';
    }
  }

  String get _emoji {
    switch (status) {
      case 'green':
        return '🟢';
      case 'yellow':
        return '🟡';
      case 'orange':
        return '🟠';
      default:
        return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 12 : 8,
        vertical: showLabel ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_emoji, style: TextStyle(fontSize: size)),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              _label,
              style: TextStyle(
                color: _color.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                fontSize: size * 0.85,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Risk level card for risk awareness screen
class RiskLevelCard extends StatelessWidget {
  final String status;
  final String title;
  final String description;
  final int count;

  const RiskLevelCard({
    super.key,
    required this.status,
    required this.title,
    required this.description,
    this.count = 0,
  });

  Color get _color {
    switch (status) {
      case 'green':
        return AppColors.statusGreen;
      case 'yellow':
        return AppColors.statusYellow;
      case 'orange':
        return AppColors.statusOrange;
      default:
        return AppColors.statusGreen;
    }
  }

  String get _emoji {
    switch (status) {
      case 'green':
        return '🟢';
      case 'yellow':
        return '🟡';
      case 'orange':
        return '🟠';
      default:
        return '🟢';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (count > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
