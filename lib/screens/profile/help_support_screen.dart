import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';
  
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      {'icon': Icons.chat_bubble_outline, 'title': 'Live Chat', 'desc': 'Chat with our support team'},
      {'icon': Icons.email_outlined, 'title': 'Email Support', 'desc': 'support@voltnest.com'},
      {'icon': Icons.help_outline, 'title': 'FAQ', 'desc': 'Find answers to common questions'},
      {'icon': Icons.report_problem_outlined, 'title': 'Report an Issue', 'desc': 'Report a bug or problem'},
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Help & Support', style: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(                                  
                  colors: [Color(0xFF131313), Color(0xFF1A1A1A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('How can we help you?', style: GoogleFonts.sora(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white,
                  )),
                  const SizedBox(height: 8),
                  Text('We are here to assist you 24/7', style: GoogleFonts.plusJakartaSans(
                    fontSize: 14, color: AppColors.textSecondary,
                  )),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1),
            const SizedBox(height: 24),
            ...options.asMap().entries.map((e) {
              final option = e.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: const Color(0xFF131313),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.surfaceDark,
                          title: Text(option['title'] as String, style: const TextStyle(color: Colors.white)),
                          content: Text('Opening ${option['title']}...', style: const TextStyle(color: AppColors.textSecondary)),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderDark),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(option['icon'] as IconData, color: Colors.white, size: 28),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(option['title'] as String, style: GoogleFonts.manrope(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
                                )),
                                const SizedBox(height: 4),
                                Text(option['desc'] as String, style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14, color: AppColors.textSecondary,
                                )),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (200 + e.key * 100).ms).slideX(begin: 0.1);
            }),
          ],
        ),
      ),
    );
  }
}