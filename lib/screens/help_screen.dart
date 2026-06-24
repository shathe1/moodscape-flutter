import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How does mood-based recommendation work?',
      'answer':
          'MoodScape matches your selected mood with nearby places and activities tagged with similar emotional themes.'
    },
    {
      'question': 'Can I change my mood throughout the day?',
      'answer': 'Yes — tap any mood card on the Home screen at any time to get a fresh set of recommendations.'
    },
    {
      'question': 'How do I save a place for later?',
      'answer': 'Tap the heart icon on any recommendation card. Saved places appear under the Saved tab.'
    },
    {
      'question': 'Is my location data private?',
      'answer': 'Location is only used to personalise nearby suggestions and is never shared with third parties.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, size: 18, color: AppColors.textMuted),
                SizedBox(width: 8),
                Text('Search for help…', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Frequently asked questions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          ..._faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                title: Text(faq['question']!,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Text(faq['answer']!, style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Still need help?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF9B79FF)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contact our support team',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('We typically respond within 24 hours.',
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening support@moodscape.app …')),
                      );
                    },
                    icon: const Icon(Icons.email_outlined, size: 16),
                    label: const Text('Email support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}