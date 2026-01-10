import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/health_status_badge.dart';

/// Risk awareness screen
class RiskAwarenessScreen extends StatelessWidget {
  const RiskAwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Awareness'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current status card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getGradientColors(appState.healthStatus),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Status',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getEmoji(appState.healthStatus),
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStatusLabel(appState.healthStatus),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStatusDescription(appState.healthStatus),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Alert counter
                Card(
                  color: AppColors.statusOrange.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.statusOrange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('🟠', style: TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Orange Alert Counter',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${appState.orangeAlertCount} / 10 triggers',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        // Progress indicator
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: appState.orangeAlertCount / 10,
                                backgroundColor: AppColors.divider,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  appState.orangeAlertCount >= 10
                                      ? AppColors.statusOrange
                                      : AppColors.statusYellow,
                                ),
                                strokeWidth: 5,
                              ),
                              Text(
                                '${appState.orangeAlertCount}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (appState.shouldShowDoctorSuggestion)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      color: AppColors.statusOrange,
                      child: ListTile(
                        leading: const Icon(Icons.local_hospital, color: Colors.white),
                        title: const Text(
                          'Consider Consulting a Doctor',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'View suggested healthcare providers',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                        ),
                        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
                        onTap: () => Navigator.pushNamed(context, '/doctors'),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Status levels explanation
                Text(
                  'Understanding Status Levels',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                
                _StatusExplanationCard(
                  status: 'green',
                  title: 'Normal',
                  description: 'Your symptoms and patterns are within typical ranges. Continue tracking for ongoing awareness.',
                  tips: [
                    'Keep logging regularly',
                    'Maintain healthy habits',
                    'Stay hydrated during your cycle',
                  ],
                ),
                const SizedBox(height: 12),
                
                _StatusExplanationCard(
                  status: 'yellow',
                  title: 'Monitor',
                  description: 'Some patterns may need attention. This is an awareness indicator, not a diagnosis.',
                  tips: [
                    'Pay attention to recurring symptoms',
                    'Consider lifestyle adjustments',
                    'Track more frequently',
                  ],
                ),
                const SizedBox(height: 12),
                
                _StatusExplanationCard(
                  status: 'orange',
                  title: 'Consider Consultation',
                  description: 'Based on your logged patterns, you may benefit from speaking with a healthcare professional.',
                  tips: [
                    'Document your symptoms',
                    'Prepare questions for your doctor',
                    'This is awareness, not a diagnosis',
                  ],
                ),
                const SizedBox(height: 24),
                
                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.secondary),
                      const SizedBox(height: 8),
                      Text(
                        'Important Reminder',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This app provides health awareness insights based on pattern recognition. It does not provide medical diagnoses. Always consult qualified healthcare professionals for medical concerns.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Color> _getGradientColors(String status) {
    switch (status) {
      case 'green':
        return [AppColors.statusGreen, AppColors.statusGreen.withValues(alpha: 0.7)];
      case 'yellow':
        return [AppColors.statusYellow, AppColors.statusYellow.withValues(alpha: 0.7)];
      case 'orange':
        return [AppColors.statusOrange, AppColors.statusOrange.withValues(alpha: 0.7)];
      default:
        return [AppColors.statusGreen, AppColors.statusGreen.withValues(alpha: 0.7)];
    }
  }

  String _getEmoji(String status) {
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

  String _getStatusLabel(String status) {
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

  String _getStatusDescription(String status) {
    switch (status) {
      case 'green':
        return 'Your health patterns look good. Keep up the great tracking!';
      case 'yellow':
        return 'Some patterns worth monitoring. Pay attention to recurring symptoms.';
      case 'orange':
        return 'Consider discussing your patterns with a healthcare professional.';
      default:
        return 'Your health patterns look good.';
    }
  }
}

/// Status explanation card widget
class _StatusExplanationCard extends StatelessWidget {
  final String status;
  final String title;
  final String description;
  final List<String> tips;

  const _StatusExplanationCard({
    required this.status,
    required this.title,
    required this.description,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HealthStatusBadge(status: status),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Tips:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(
                        child: Text(tip, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
