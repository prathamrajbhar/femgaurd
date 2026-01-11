import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Comprehensive PCOS/PCOD Hub Screen
/// Provides symptom tracking, risk assessment, educational resources, and lifestyle tips
class PCOSHubScreen extends StatefulWidget {
  const PCOSHubScreen({super.key});

  @override
  State<PCOSHubScreen> createState() => _PCOSHubScreenState();
}

class _PCOSHubScreenState extends State<PCOSHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Symptom checklist state
  final Map<String, bool> _symptoms = {
    'Irregular periods': false,
    'Heavy bleeding': false,
    'Missed periods (>3 months)': false,
    'Excess facial/body hair': false,
    'Severe acne': false,
    'Hair thinning/loss': false,
    'Weight gain (especially belly)': false,
    'Difficulty losing weight': false,
    'Dark skin patches': false,
    'Skin tags': false,
    'Mood swings': false,
    'Fatigue': false,
    'Sleep problems': false,
    'Headaches': false,
    'Pelvic pain': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _selectedSymptomCount => _symptoms.values.where((v) => v).length;
  
  String get _riskLevel {
    final count = _selectedSymptomCount;
    if (count <= 2) return 'Low';
    if (count <= 5) return 'Moderate';
    if (count <= 8) return 'Elevated';
    return 'High';
  }
  
  Color get _riskColor {
    switch (_riskLevel) {
      case 'Low': return Colors.green;
      case 'Moderate': return Colors.orange;
      case 'Elevated': return Colors.deepOrange;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildSymptomCheckerTab(),
                  _buildLifestyleTab(),
                  _buildResourcesTab(),
                ],
              ),
            ),
          ],
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
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.10),
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
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.primaryShadow(0.4),
            ),
            child: const Text('🎗️', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PCOS/PCOD Hub',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Awareness • Support • Resources',
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Symptoms'),
          Tab(text: 'Lifestyle'),
          Tab(text: 'Resources'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // What is PCOS/PCOD Card
          _buildInfoCard(
            title: 'Understanding PCOS & PCOD',
            icon: '📚',
            color: AppColors.primary,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildComparisonRow(
                  'PCOS',
                  'Polycystic Ovary Syndrome - A metabolic & hormonal disorder affecting 1 in 10 women',
                  AppColors.accent,
                ),
                const SizedBox(height: 12),
                _buildComparisonRow(
                  'PCOD',
                  'Polycystic Ovary Disease - Ovaries release immature eggs leading to hormonal imbalance',
                  AppColors.primary,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Both conditions are manageable with proper lifestyle changes and medical guidance.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Key Differences
          _buildInfoCard(
            title: 'Key Differences',
            icon: '⚖️',
            color: AppColors.secondary,
            content: Column(
              children: [
                _buildDifferenceRow('Severity', 'PCOD is milder', 'PCOS is more serious'),
                _buildDifferenceRow('Fertility', 'Usually conceive with help', 'May face more challenges'),
                _buildDifferenceRow('Symptoms', 'Fewer systemic effects', 'More metabolic impact'),
                _buildDifferenceRow('Treatment', 'Lifestyle changes often enough', 'May need medication'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick Stats
          _buildQuickStats(),
          const SizedBox(height: 16),
          
          // Common Symptoms Preview
          _buildInfoCard(
            title: 'Common Symptoms',
            icon: '🩺',
            color: Colors.teal,
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSymptomChip('Irregular periods'),
                _buildSymptomChip('Weight gain'),
                _buildSymptomChip('Acne'),
                _buildSymptomChip('Hair growth'),
                _buildSymptomChip('Hair loss'),
                _buildSymptomChip('Mood changes'),
                _buildSymptomChip('Fatigue'),
                _buildSymptomChip('Dark patches'),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSymptomCheckerTab() {
    return Column(
      children: [
        // Risk Assessment Card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _riskColor.withValues(alpha: 0.15),
                _riskColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _riskColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$_selectedSymptomCount',
                    style: TextStyle(
                      color: _riskColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptom Score',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$_riskLevel Risk',
                          style: TextStyle(
                            color: _riskColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _riskColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_selectedSymptomCount/15',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRiskMessage(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Disclaimer
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This is for awareness only. Please consult a doctor for diagnosis.',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Symptom Checklist
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: _symptoms.length,
            itemBuilder: (context, index) {
              final symptom = _symptoms.keys.elementAt(index);
              final isChecked = _symptoms[symptom]!;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isChecked 
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isChecked 
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.divider,
                  ),
                ),
                child: CheckboxListTile(
                  value: isChecked,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _symptoms[symptom] = value!);
                  },
                  title: Text(
                    symptom,
                    style: TextStyle(
                      fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  activeColor: AppColors.primary,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLifestyleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLifestyleSection(
            '🥗',
            'Diet Recommendations',
            Colors.green,
            [
              _LifestyleTip('Eat whole foods', 'Focus on fruits, vegetables, whole grains'),
              _LifestyleTip('Reduce refined carbs', 'Limit white bread, pasta, sugar'),
              _LifestyleTip('Include lean protein', 'Fish, chicken, beans, lentils'),
              _LifestyleTip('Anti-inflammatory foods', 'Turmeric, leafy greens, berries'),
              _LifestyleTip('Healthy fats', 'Omega-3 from fish, nuts, avocado'),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildLifestyleSection(
            '🏃‍♀️',
            'Exercise Tips',
            Colors.blue,
            [
              _LifestyleTip('30 min daily activity', 'Walking, swimming, cycling'),
              _LifestyleTip('Strength training', '2-3 times per week'),
              _LifestyleTip('HIIT workouts', 'Short bursts of intense exercise'),
              _LifestyleTip('Yoga & stretching', 'Reduces stress and improves flexibility'),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildLifestyleSection(
            '😴',
            'Sleep & Stress',
            Colors.purple,
            [
              _LifestyleTip('7-9 hours sleep', 'Consistent sleep schedule'),
              _LifestyleTip('Manage stress', 'Meditation, deep breathing'),
              _LifestyleTip('Limit screen time', 'Especially before bed'),
              _LifestyleTip('Self-care routine', 'Regular relaxation activities'),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildLifestyleSection(
            '🌿',
            'Natural Remedies',
            Colors.teal,
            [
              _LifestyleTip('Spearmint tea', 'May help reduce androgen levels'),
              _LifestyleTip('Cinnamon', 'May improve insulin sensitivity'),
              _LifestyleTip('Apple cider vinegar', 'May help with blood sugar'),
              _LifestyleTip('Inositol supplements', 'Consult doctor first'),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // When to See a Doctor
          _buildInfoCard(
            title: 'When to See a Doctor',
            icon: '🏥',
            color: Colors.red,
            content: Column(
              children: [
                _buildWarningSign('Missed 3+ periods in a row'),
                _buildWarningSign('Sudden weight gain or difficulty losing weight'),
                _buildWarningSign('Excess facial hair or severe acne'),
                _buildWarningSign('Trouble getting pregnant'),
                _buildWarningSign('Signs of diabetes (thirst, frequent urination)'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Tests to Ask About
          _buildInfoCard(
            title: 'Tests to Ask Your Doctor About',
            icon: '🔬',
            color: Colors.blue,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTestItem('Blood tests', 'Hormone levels, blood sugar, lipids'),
                _buildTestItem('Pelvic ultrasound', 'Check for cysts on ovaries'),
                _buildTestItem('HOMA-IR test', 'Insulin resistance check'),
                _buildTestItem('Thyroid function', 'Rule out thyroid issues'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Support Communities
          _buildInfoCard(
            title: 'You\'re Not Alone',
            icon: '💜',
            color: AppColors.primary,
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '1 in 10',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'women of reproductive age are affected by PCOS worldwide',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/community'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Join Our Community',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildInfoCard({
    required String title,
    required String icon,
    required Color color,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifferenceRow(String aspect, String pcod, String pcos) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              aspect,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(pcod, style: const TextStyle(fontSize: 11)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(pcos, style: const TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard('10%', 'Women affected', AppColors.accent),
        const SizedBox(width: 12),
        _buildStatCard('70%', 'Go undiagnosed', AppColors.statusOrange),
        const SizedBox(width: 12),
        _buildStatCard('50%', 'Have weight issues', AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomChip(String symptom) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
      ),
      child: Text(
        symptom,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLifestyleSection(
    String icon,
    String title,
    Color color,
    List<_LifestyleTip> tips,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        tip.description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWarningSign(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_rounded, color: Colors.red, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestItem(String test, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🔹', style: TextStyle(fontSize: 14, color: AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskMessage() {
    switch (_riskLevel) {
      case 'Low':
        return 'Few symptoms detected. Continue monitoring.';
      case 'Moderate':
        return 'Some symptoms present. Consider consulting a doctor.';
      case 'Elevated':
        return 'Multiple symptoms detected. Doctor visit recommended.';
      default:
        return 'Please consult a healthcare professional soon.';
    }
  }
}

class _LifestyleTip {
  final String title;
  final String description;
  _LifestyleTip(this.title, this.description);
}
