import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/partner_settings.dart';
import '../utils/app_theme.dart';

/// Partner awareness mode screen - educational view for partners
class PartnerModeScreen extends StatelessWidget {
  final String phase;
  final int daysUntilPeriod;
  final bool shareMood;

  const PartnerModeScreen({
    super.key,
    required this.phase,
    required this.daysUntilPeriod,
    this.shareMood = false,
  });

  @override
  Widget build(BuildContext context) {
    final phaseInfo = PartnerEducation.phaseInfo[phase.toLowerCase()] ?? 
        PartnerEducation.phaseInfo['menstrual']!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildPhaseCard(context, phaseInfo),
              const SizedBox(height: 24),
              _buildWhatHappensCard(context, phaseInfo),
              const SizedBox(height: 24),
              _buildHowSheMightFeelCard(context, phaseInfo),
              const SizedBox(height: 24),
              _buildHowToHelpCard(context, phaseInfo),
              const SizedBox(height: 24),
              _buildDisclaimerCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Partner View',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Understanding the menstrual cycle',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Text('💕', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }

  Widget _buildPhaseCard(BuildContext context, PartnerPhaseInfo phaseInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getPhaseGradient(phaseInfo.phase),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getPhaseGradient(phaseInfo.phase).first.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_getPhaseEmoji(phaseInfo.phase), style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phaseInfo.phase,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      phaseInfo.duration,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (daysUntilPeriod > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$daysUntilPeriod days until next period',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhatHappensCard(BuildContext context, PartnerPhaseInfo phaseInfo) {
    return _buildInfoCard(
      context,
      icon: '📚',
      title: 'What Happens',
      content: phaseInfo.whatHappens,
    );
  }

  Widget _buildHowSheMightFeelCard(BuildContext context, PartnerPhaseInfo phaseInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💭', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'How She Might Feel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...phaseInfo.howSheMightFeel.map((feeling) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feeling,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildHowToHelpCard(BuildContext context, PartnerPhaseInfo phaseInfo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💚', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                'How You Can Help',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...phaseInfo.howYouCanHelp.map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✓', style: TextStyle(color: Colors.green)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ℹ️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About This View',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This is educational information only. Every person\'s experience is different. '
                  'The best way to support your partner is to communicate openly and ask how they\'re feeling.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getPhaseGradient(String phase) {
    if (phase.contains('Menstrual')) {
      return [const Color(0xFFE91E63), const Color(0xFFC2185B)];
    } else if (phase.contains('Follicular')) {
      return [const Color(0xFF4CAF50), const Color(0xFF388E3C)];
    } else if (phase.contains('Ovulation')) {
      return [const Color(0xFFFF9800), const Color(0xFFF57C00)];
    } else {
      return [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)];
    }
  }

  String _getPhaseEmoji(String phase) {
    if (phase.contains('Menstrual')) return '🩸';
    if (phase.contains('Follicular')) return '🌱';
    if (phase.contains('Ovulation')) return '🌸';
    return '🌙';
  }
}
