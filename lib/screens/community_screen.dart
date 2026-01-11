import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/community_post.dart';
import '../utils/app_theme.dart';

/// Anonymous community screen for emotional support
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CommunityTopic _selectedTopic = CommunityTopic.general;
  
  // Demo posts
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      anonymousName: 'Kind Butterfly',
      content: 'Just had the worst cramps today. Anyone else dealing with this? 😔',
      topic: CommunityTopic.periodTalk,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      supportCount: 24,
      replyCount: 8,
    ),
    CommunityPost(
      id: '2',
      anonymousName: 'Gentle Star',
      content: 'Finally got my PCOS diagnosis after years of irregular periods. Feeling relieved but also overwhelmed. Any advice?',
      topic: CommunityTopic.pcosPcod,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      supportCount: 47,
      replyCount: 15,
    ),
    CommunityPost(
      id: '3',
      anonymousName: 'Warm Sunflower',
      content: 'Sharing some positivity! After tracking for 3 months, my cycles are finally becoming regular. Hang in there everyone! 💪',
      topic: CommunityTopic.general,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      supportCount: 89,
      replyCount: 12,
    ),
    CommunityPost(
      id: '4',
      anonymousName: 'Bright Moon',
      content: 'Does anyone else feel extra emotional during the luteal phase? I cry at everything 😅',
      topic: CommunityTopic.mentalHealth,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      supportCount: 156,
      replyCount: 34,
    ),
    CommunityPost(
      id: '5',
      anonymousName: 'Calm Wave',
      content: 'Found that yoga really helps with my period pain. Try child\'s pose and cat-cow stretches!',
      topic: CommunityTopic.wellness,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      supportCount: 203,
      replyCount: 28,
    ),
    CommunityPost(
      id: '6',
      anonymousName: 'Sweet Pearl',
      content: 'Just started trying to conceive. The two-week wait is so stressful! 🤞',
      topic: CommunityTopic.pregnancy,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      supportCount: 67,
      replyCount: 19,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: CommunityTopic.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _selectedTopic = CommunityTopic.values[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CommunityPost> get _filteredPosts {
    if (_selectedTopic == CommunityTopic.general) {
      return _posts;
    }
    return _posts.where((p) => p.topic == _selectedTopic).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildGuidelinesCard(),
            _buildTopicTabs(),
            Expanded(
              child: _filteredPosts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) => _PostCard(
                        post: _filteredPosts[index],
                        onSupport: () => _handleSupport(_filteredPosts[index]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showCreatePostDialog,
          backgroundColor: AppColors.accent,
          elevation: 0,
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          label: const Text('Share', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.softShadow,
              ),
              child: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text('💬', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Anonymous • Supportive • Safe',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'All posts are anonymous. Be kind, supportive, and never diagnose.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicTabs() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: CommunityTopic.values.length,
        itemBuilder: (context, index) {
          final topic = CommunityTopic.values[index];
          final isSelected = _selectedTopic == topic;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTopic = topic);
                _tabController.animateTo(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(topic.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      topic.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_selectedTopic.icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No posts in ${_selectedTopic.displayName}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share!',
            style: TextStyle(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSupport(CommunityPost post) {
    HapticFeedback.mediumImpact();
    setState(() {
      final index = _posts.indexOf(post);
      if (index != -1) {
        _posts[index] = post.copyWith(supportCount: post.supportCount + 1);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('❤️ Support sent'),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showCreatePostDialog() {
    final controller = TextEditingController();
    CommunityTopic selectedTopic = _selectedTopic;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
            20, 20, 20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('✏️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Share Anonymously',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.textLight, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Posting as: ${AnonymousNameGenerator.generate()}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(color: AppColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Topic',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CommunityTopic.values.map((topic) {
                  final isSelected = selectedTopic == topic;
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedTopic = topic),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${topic.icon} ${topic.displayName}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        _posts.insert(0, CommunityPost(
                          id: DateTime.now().toString(),
                          anonymousName: AnonymousNameGenerator.generate(),
                          content: controller.text.trim(),
                          topic: selectedTopic,
                          createdAt: DateTime.now(),
                          isFromCurrentUser: true,
                        ));
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('✨ Posted successfully!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual post card
class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onSupport;

  const _PostCard({required this.post, required this.onSupport});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: post.isFromCurrentUser
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.4), width: 2)
            : Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: post.isFromCurrentUser 
                ? AppColors.accent.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(post.topic.icon, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.anonymousName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (post.isFromCurrentUser) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTime(post.createdAt),
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post.topic.displayName,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: onSupport,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('❤️', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        '${post.supportCount}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('💬', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      '${post.replyCount}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
