import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool locationShared = true;
  bool personalAds = false;
  bool analytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Privacy', style: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Settings', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(),
            const SizedBox(height: 16),
            _buildToggleItem(
              title: 'Location Services',
              desc: 'Allow VoltNest to access your location for better charger recommendations.',
              value: locationShared,
              onChanged: (val) => setState(() => locationShared = val),
              index: 0,
            ),
            _buildToggleItem(
              title: 'Personalized Ads',
              desc: 'Receive ads tailored to your charging habits and preferences.',
              value: personalAds,
              onChanged: (val) => setState(() => personalAds = val),
              index: 1,
            ),
            _buildToggleItem(
              title: 'App Analytics',
              desc: 'Share anonymous usage data to help us improve the app experience.',
              value: analytics,
              onChanged: (val) => setState(() => analytics = val),
              index: 2,
            ),
            const SizedBox(height: 32),
            Text('Legal', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16),
            _buildLinkItem(context, 'Privacy Policy', 3, '/privacy-policy'),
            _buildLinkItem(context, 'Terms of Service', 4, '/terms-of-service'),
            _buildLinkItem(context, 'Data Deletion Request', 5, null, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String desc,
    required bool value,
    required ValueChanged<bool> onChanged,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.manrope(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,
                )),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.plusJakartaSans(
                  fontSize: 14, color: AppColors.textSecondary,
                )),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.black,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.surfaceVariantDark,
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 + index * 100).ms).slideX(begin: 0.1);
  }

  Widget _buildLinkItem(BuildContext context, String title, int index, String? route, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (route != null) {
              context.push(route);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: isDestructive ? Colors.red.withValues(alpha: 0.3) : AppColors.borderDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDestructive ? Colors.redAccent : Colors.white,
                )),
                Icon(Icons.chevron_right, color: isDestructive ? Colors.redAccent : AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (100 + index * 100).ms).slideX(begin: 0.1);
  }
}




