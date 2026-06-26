import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Title
                    Text(
                      "INDIA'S #1",
                      style: GoogleFonts.sora(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
                    Text(
                      'EV CHARGING APP',
                      style: GoogleFonts.sora(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(begin: -0.2),
                    const SizedBox(height: 16),
                    // Brand badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat())
                              .fadeIn()
                              .then()
                              .fadeOut()
                              .then()
                              .fadeIn(),
                          const SizedBox(width: 8),
                          Text(
                            'VoltNest',
                            style: GoogleFonts.sora(
                              fontSize: 20,
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 40),
                    // Login form
                    Text(
                      'Log in or sign up',
                      style: GoogleFonts.manrope(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 24),
                    // Phone input row
                    Row(
                      children: [
                        // Country code
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppColors.borderDark),
                          ),
                          child: Row(
                            children: [
                              const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                '+91',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.expand_more,
                                size: 18,
                                color:
                                    Colors.white.withValues(alpha: 0.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Phone number input
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                hintStyle: GoogleFonts.manrope(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                    const SizedBox(height: 16),
                    // Remember me
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Remember my login for faster sign-in',
                          style: GoogleFonts.manrope(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 700.ms),
                    const SizedBox(height: 24),
                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          final phone = _phoneController.text.isNotEmpty
                              ? '+91 ${_phoneController.text}'
                              : '+91 98765 43210';
                          context.push('/otp-verification', extra: phone);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideY(begin: 0.1),
                    const SizedBox(height: 24),
                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: AppColors.borderDark, height: 1)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: GoogleFonts.manrope(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                                color: AppColors.borderDark, height: 1)),
                      ],
                    ).animate().fadeIn(delay: 900.ms),
                    const SizedBox(height: 24),
                    // Social logins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(context, Icons.g_mobiledata, 'Google'),
                        const SizedBox(width: 24),
                        _socialButton(context, Icons.email_outlined, 'Email'),
                      ],
                    ).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 24),
                    // Terms
                    Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our\n',
                        style: GoogleFonts.manrope(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: GoogleFonts.manrope(
                              decoration: TextDecoration.underline,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const TextSpan(text: ' • '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.manrope(
                              decoration: TextDecoration.underline,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 1100.ms),
                  ],
                ),
              ),
            ),
            // Bottom indicator bar
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 16),
              child: Container(
                width: 128,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(BuildContext context, IconData icon, String label) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceDark,
        border: Border.all(color: AppColors.borderDark),
      ),
      child: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label Login coming soon!'),
              backgroundColor: AppColors.surfaceVariantDark,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: Icon(icon, color: AppColors.textSecondary),
      ),
    );
  }
}
