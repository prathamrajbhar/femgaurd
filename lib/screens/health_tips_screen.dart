import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Health tips and articles screen with educational content
class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<_HealthArticle> _articles = [
    _HealthArticle(
      id: '1',
      title: 'Understanding Your Menstrual Cycle',
      summary: 'Learn about the four phases of your cycle and what happens in your body during each one.',
      category: 'Education',
      readTime: '5 min',
      emoji: '📚',
      color: Color(0xFFE91E63),
    ),
    _HealthArticle(
      id: '2',
      title: 'Managing Period Pain Naturally',
      summary: 'Discover natural remedies and lifestyle changes that can help reduce menstrual cramps.',
      category: 'Wellness',
      readTime: '4 min',
      emoji: '🌿',
      color: Color(0xFF4CAF50),
    ),
    _HealthArticle(
      id: '3',
      title: 'Nutrition During Your Cycle',
      summary: 'What to eat during each phase of your cycle to support your energy and mood.',
      category: 'Nutrition',
      readTime: '6 min',
      emoji: '🥗',
      color: Color(0xFFFF9800),
    ),
    _HealthArticle(
      id: '4',
      title: 'Exercise and Your Period',
      summary: 'The best types of exercise for each phase of your menstrual cycle.',
      category: 'Fitness',
      readTime: '4 min',
      emoji: '💪',
      color: Color(0xFF2196F3),
    ),
    _HealthArticle(
      id: '5',
      title: 'Hormones and Mood Changes',
      summary: 'Understanding how hormonal fluctuations affect your emotions throughout the month.',
      category: 'Education',
      readTime: '5 min',
      emoji: '🧠',
      color: Color(0xFF9C27B0),
    ),
    _HealthArticle(
      id: '6',
      title: 'Sleep Quality and Your Cycle',
      summary: 'How your menstrual cycle affects sleep and tips for better rest.',
      category: 'Wellness',
      readTime: '4 min',
      emoji: '😴',
      color: Color(0xFF3F51B5),
    ),
  ];

  final List<_QuickTip> _quickTips = [
    _QuickTip(
      tip: 'Stay hydrated! Drinking water helps reduce bloating.',
      icon: Icons.water_drop_rounded,
    ),
    _QuickTip(
      tip: 'Gentle yoga can help relieve menstrual cramps.',
      icon: Icons.self_improvement_rounded,
    ),
    _QuickTip(
      tip: 'Iron-rich foods can help counter energy dips during your period.',
      icon: Icons.restaurant_rounded,
    ),
    _QuickTip(
      tip: 'Heat pads can provide soothing relief for cramps.',
      icon: Icons.thermostat_rounded,
    ),
    _QuickTip(
      tip: 'Track your symptoms to identify patterns over time.',
      icon: Icons.insights_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: const Text('Health Tips'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Quick Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArticlesTab(),
          _buildQuickTipsTab(),
        ],
      ),
    );
  }

  Widget _buildArticlesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return _ArticleCard(article: article);
      },
    );
  }

  Widget _buildQuickTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured tip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppColors.primaryShadow(0.35),
            ),
            child: Column(
              children: [
                const Text('💡', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 16),
                const Text(
                  'Tip of the Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Regular exercise can help regulate your cycle and reduce PMS symptoms.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          
          Text(
            'More Tips',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(_quickTips.length, (index) {
            final tip = _quickTips[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppColors.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(tip.icon, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      tip.tip,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Health article model
class _HealthArticle {
  final String id;
  final String title;
  final String summary;
  final String category;
  final String readTime;
  final String emoji;
  final Color color;

  _HealthArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.readTime,
    required this.emoji,
    required this.color,
  });
}

/// Quick tip model
class _QuickTip {
  final String tip;
  final IconData icon;

  _QuickTip({required this.tip, required this.icon});
}

/// Article card widget
class _ArticleCard extends StatelessWidget {
  final _HealthArticle article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showArticleDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.softShadow,
          border: Border.all(color: article.color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            // Emoji container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: article.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Center(
                child: Text(article.emoji, style: const TextStyle(fontSize: 28)),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: article.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyle(
                            color: article.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.schedule_rounded, size: 12, color: AppColors.textLight),
                      const SizedBox(width: 3),
                      Text(
                        article.readTime,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  void _showArticleDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: article.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: Center(
                          child: Text(article.emoji, style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: article.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category,
                          style: TextStyle(
                            color: article.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    // Content placeholder
                    Text(
                      article.summary,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This is a demo article. In a full implementation, this would contain detailed educational content about ${article.title.toLowerCase()}.\n\nThe content would cover:\n\n• Key concepts and explanations\n• Practical tips and advice\n• Scientific background\n• Lifestyle recommendations\n\nAlways consult with a healthcare professional for personalized medical advice.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                        ),
                        child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
