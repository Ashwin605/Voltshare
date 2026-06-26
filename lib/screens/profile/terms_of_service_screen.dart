import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
        title: Text('Terms of Service', style: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last updated: June 2026', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.textSecondary,
            )).animate().fadeIn(),
            const SizedBox(height: 24),
            Text('1. Acceptance of Terms', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1),
            const SizedBox(height: 8),
            Text('By accessing or using the VoltNest app, you agree to be bound by these Terms of Service. If you disagree, do not use the application.', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.textSecondary, height: 1.5,
            )).animate().fadeIn(delay: 150.ms).slideX(begin: 0.1),
            const SizedBox(height: 24),
            Text('2. User Responsibilities', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
            const SizedBox(height: 8),
            Text('You are responsible for maintaining the security of your account and for all activities that occur under the account. You must notify us immediately of any unauthorized uses.', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.textSecondary, height: 1.5,
            )).animate().fadeIn(delay: 250.ms).slideX(begin: 0.1),
            const SizedBox(height: 24),
            Text('3. Charging Services', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
            const SizedBox(height: 8),
            Text('VoltNest connects you with EV charging stations. We do not own or operate all stations, and availability or charging speeds may vary based on third-party operators.', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.textSecondary, height: 1.5,
            )).animate().fadeIn(delay: 350.ms).slideX(begin: 0.1),
            const SizedBox(height: 24),
            Text('4. Payments', style: GoogleFonts.manrope(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,
            )).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
            const SizedBox(height: 8),
            Text('All payments are processed securely. By using the app to charge, you authorize us to charge your selected payment method for the consumed energy and any applicable idle fees.', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.textSecondary, height: 1.5,
            )).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
