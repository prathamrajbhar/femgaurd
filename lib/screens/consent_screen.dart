import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

/// Consent & Disclaimer screen
class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _hasAgreed = false;

  void _continue() {
    if (_hasAgreed) {
      context.read<AppState>().acceptConsent();
      Navigator.of(context).pushReplacementNamed('/theme-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Privacy'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Disclaimer content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            color: AppColors.secondary,
                            size: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Health Awareness',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Not a medical diagnosis tool',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Disclaimer text
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          AppConstants.disclaimerText,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Benefits cards
                    _BenefitCard(
                      icon: Icons.lock_outline,
                      title: 'Your Data, Your Control',
                      description: 'All data stays on your device. No external sharing.',
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.insights,
                      title: 'Pattern Awareness',
                      description: 'Observe trends and patterns in your cycle and health.',
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.favorite_border,
                      title: 'Self-Care Support',
                      description: 'Tips and insights to support your well-being journey.',
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section with checkbox and button
            Container(
              padding: const EdgeInsets.all(24),
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
                  // Checkbox
                  InkWell(
                    onTap: () => setState(() => _hasAgreed = !_hasAgreed),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _hasAgreed,
                            onChanged: (value) {
                              setState(() => _hasAgreed = value ?? false);
                            },
                          ),
                          Expanded(
                            child: Text(
                              'I understand and agree to the terms above',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Continue button
                  CustomButton(
                    text: 'Continue',
                    onPressed: _hasAgreed ? _continue : () {},
                    icon: Icons.arrow_forward,
                  ),
                  if (!_hasAgreed)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please agree to continue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
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
}

/// Benefit card widget
class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.accent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
