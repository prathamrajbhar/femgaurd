import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Help and FAQ screen
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<_FAQItem> _faqs = [
    _FAQItem(
      question: 'How does FemGuard track my cycle?',
      answer: 'FemGuard uses the dates you log to calculate your cycle patterns. When you mark the start of your period, the app calculates your cycle length and predicts future periods based on your average cycle duration.',
    ),
    _FAQItem(
      question: 'Is my data private and secure?',
      answer: 'Yes! All your data is stored locally on your device. We do not collect, share, or upload any of your personal health information to external servers. Your data stays with you.',
    ),
    _FAQItem(
      question: 'What is the health status indicator?',
      answer: 'The health status (green, yellow, orange) is based on the symptoms you log. It\'s an awareness tool to help you notice patterns, not a medical diagnosis. Green means your symptoms are within normal range, yellow suggests monitoring, and orange indicates you might want to speak with a healthcare provider.',
    ),
    _FAQItem(
      question: 'How accurate are the predictions?',
      answer: 'Predictions improve over time as you log more data. The app uses your historical cycle lengths to estimate future periods. Factors like stress, diet, and health can affect your actual cycle, so predictions are estimates.',
    ),
    _FAQItem(
      question: 'What is the fertile window?',
      answer: 'The fertile window is the time during your cycle when conception is most likely to occur. It\'s typically around 5 days before ovulation and the day of ovulation itself. This is estimated based on your cycle length.',
    ),
    _FAQItem(
      question: 'Can I use this app for birth control?',
      answer: 'No. FemGuard is an awareness and tracking tool only. It should NOT be used as a method of birth control. The predictions are estimates and not reliable enough for contraceptive purposes.',
    ),
    _FAQItem(
      question: 'How do I log symptoms?',
      answer: 'Tap the "Log Symptoms" button on the home screen or navigate to the symptom logging section. You can record physical symptoms, mood, energy levels, and more. Regular logging helps the app provide better insights.',
    ),
    _FAQItem(
      question: 'What should I do if I see an orange status?',
      answer: 'An orange status suggests your recent symptoms may warrant attention. This is not a diagnosis but an awareness prompt. Consider speaking with a healthcare provider about your symptoms.',
    ),
    _FAQItem(
      question: 'How do I change my cycle length?',
      answer: 'Go to Profile & Settings → Edit Profile. You can adjust your average cycle length, age, and other profile information there.',
    ),
    _FAQItem(
      question: 'Can I export my data?',
      answer: 'Yes! Go to Profile & Settings → Privacy & Data → Export Data to download all your logged information.',
    ),
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Help & FAQ'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                boxShadow: AppColors.primaryShadow(0.35),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How can we help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find answers to common questions below',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            
            // FAQ section
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            
            // FAQ list
            ...List.generate(_faqs.length, (index) {
              final faq = _faqs[index];
              final isExpanded = _expandedIndex == index;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: isExpanded ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
                  boxShadow: AppColors.softShadow,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedIndex = expanded ? index : -1;
                      });
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isExpanded 
                            ? AppColors.primary.withValues(alpha: 0.15) 
                            : AppColors.primaryLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: isExpanded ? AppColors.primary : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      faq.question,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    trailing: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isExpanded ? AppColors.primary : AppColors.textLight,
                      ),
                    ),
                    children: [
                      Text(
                        faq.answer,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // Contact section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.mail_outline_rounded, color: AppColors.accent, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact our support team',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Email: support@herhealth.app'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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

/// FAQ item model
class _FAQItem {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});
}
