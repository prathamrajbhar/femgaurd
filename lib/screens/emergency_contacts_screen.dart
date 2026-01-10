import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

/// Emergency contacts screen for quick access to health resources
class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<_EmergencyContact> _emergencyContacts = [
    _EmergencyContact(
      name: 'Emergency Services',
      number: '112',
      description: 'National emergency number',
      icon: Icons.emergency_rounded,
      color: Color(0xFFE53935),
      isEmergency: true,
    ),
    _EmergencyContact(
      name: 'Women\'s Helpline',
      number: '181',
      description: '24/7 women support helpline',
      icon: Icons.support_agent_rounded,
      color: Color(0xFF9C27B0),
      isEmergency: true,
    ),
    _EmergencyContact(
      name: 'Health Helpline',
      number: '104',
      description: 'Medical advice and information',
      icon: Icons.local_hospital_rounded,
      color: Color(0xFF2196F3),
      isEmergency: false,
    ),
  ];

  final List<_PersonalContact> _personalContacts = [
    _PersonalContact(
      name: 'Dr. Sarah Johnson',
      role: 'Gynecologist',
      phone: '+91 98765 43210',
      initials: 'SJ',
    ),
    _PersonalContact(
      name: 'Mom',
      role: 'Family',
      phone: '+91 98765 12345',
      initials: 'M',
    ),
  ];

  void _callNumber(String number, String name) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.phone_rounded, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(child: Text('Call $name?')),
          ],
        ),
        content: Text('This would call $number in a real app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $name...'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.statusGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            icon: const Icon(Icons.call_rounded),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final roleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.person_add_rounded, color: AppColors.primary),
            const SizedBox(width: 10),
            const Text('Add Contact'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Role (e.g., Doctor, Family)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                setState(() {
                  _personalContacts.add(_PersonalContact(
                    name: nameController.text,
                    role: roleController.text.isEmpty ? 'Contact' : roleController.text,
                    phone: phoneController.text,
                    initials: nameController.text.substring(0, 1).toUpperCase(),
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Contact added!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.statusGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
        title: const Text('Emergency Contacts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.statusOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.statusOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.statusOrange, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'In case of emergency',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Please call emergency services immediately if you need urgent help.',
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
            ),
            const SizedBox(height: 28),
            
            // Emergency contacts section
            _SectionHeader(title: 'Emergency Numbers'),
            const SizedBox(height: 14),
            
            ...List.generate(_emergencyContacts.length, (index) {
              final contact = _emergencyContacts[index];
              return _EmergencyContactCard(
                contact: contact,
                onCall: () => _callNumber(contact.number, contact.name),
              );
            }),
            const SizedBox(height: 28),
            
            // Personal contacts section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(title: 'Personal Contacts'),
                TextButton.icon(
                  onPressed: _showAddContactDialog,
                  icon: Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
                  label: Text(
                    'Add',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            
            if (_personalContacts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textLight),
                    const SizedBox(height: 12),
                    Text(
                      'No personal contacts yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add your doctor or family members',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(_personalContacts.length, (index) {
                final contact = _personalContacts[index];
                return _PersonalContactCard(
                  contact: contact,
                  onCall: () => _callNumber(contact.phone, contact.name),
                  onDelete: () {
                    setState(() => _personalContacts.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Contact removed'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Add Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

/// Emergency contact model
class _EmergencyContact {
  final String name;
  final String number;
  final String description;
  final IconData icon;
  final Color color;
  final bool isEmergency;

  _EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.icon,
    required this.color,
    this.isEmergency = false,
  });
}

/// Personal contact model
class _PersonalContact {
  final String name;
  final String role;
  final String phone;
  final String initials;

  _PersonalContact({
    required this.name,
    required this.role,
    required this.phone,
    required this.initials,
  });
}

/// Emergency contact card widget
class _EmergencyContactCard extends StatelessWidget {
  final _EmergencyContact contact;
  final VoidCallback onCall;

  const _EmergencyContactCard({required this.contact, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.softShadow,
        border: contact.isEmergency 
            ? Border.all(color: contact.color.withValues(alpha: 0.3)) 
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: contact.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(contact.icon, color: contact.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contact.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (contact.isEmergency) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: contact.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  contact.description,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.number,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCall,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.statusGreen,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.call_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

/// Personal contact card widget
class _PersonalContactCard extends StatelessWidget {
  final _PersonalContact contact;
  final VoidCallback onCall;
  final VoidCallback onDelete;

  const _PersonalContactCard({
    required this.contact,
    required this.onCall,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.role,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.phone,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline_rounded, color: AppColors.textLight),
          ),
          GestureDetector(
            onTap: onCall,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.statusGreen,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
