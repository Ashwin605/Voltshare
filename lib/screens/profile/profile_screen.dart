import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _walletBalance = 2480.0;

  void _showWalletDialog(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final amountController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.sora(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,
              )),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 24),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(color: Colors.white, fontSize: 24),
                  hintText: '0.00',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 24),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderDark)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (amount > 0) {
                      setState(() {
                        if (title == 'Top up Wallet') {
                          _walletBalance += amount;
                        } else if (title == 'Withdraw') {
                          if (_walletBalance >= amount) {
                            _walletBalance -= amount;
                          }
                        }
                      });
                    }
                    context.pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => context.push('/privacy'),
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  children: [
                    // Avatar
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    // Wallet
                    _buildWalletCard(),
                    const SizedBox(height: 24),
                    // Impact stats
                    _buildImpactRow(),
                    const SizedBox(height: 24),
                    // Settings list
                    _buildSettingsList(context),
                    const SizedBox(height: 24),
                    // Footer
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar with glow ring
        Container(
          width: 100, height: 100,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
            )],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundDark,
              border: Border.all(color: AppColors.backgroundDark, width: 3),
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceDark,
              child: const Icon(Icons.person, color: AppColors.textSecondary, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Maya Sharma', style: GoogleFonts.sora(
              fontSize: 28, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: -0.5,
            )),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: AppColors.primary, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantDark,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text('DRIVER · HOST', style: GoogleFonts.plusJakartaSans(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: AppColors.textSecondary, letterSpacing: 2,
          )),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1CB864), Color(0xFF0A6634)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.2),
          blurRadius: 10,
        )],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -40, right: -40,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('WALLET BALANCE', style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.8), letterSpacing: 1,
                  )),
                  Icon(Icons.account_balance_wallet, color: Colors.black.withValues(alpha: 0.8)),
                ],
              ),
              const SizedBox(height: 8),
              Text('₹${_walletBalance.toStringAsFixed(0)}', style: GoogleFonts.sora(
                fontSize: 56, fontWeight: FontWeight.w800,
                color: Colors.black, letterSpacing: -2,
              )),
              const SizedBox(height: 16),
              // Buttons
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showWalletDialog('Top up Wallet'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Top up'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showWalletDialog('Withdraw'),
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        label: const Text('Withdraw'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildImpactRow() {
    final stats = [
      {'icon': Icons.bolt, 'value': '142', 'label': 'kWh Charged'},
      {'icon': Icons.eco, 'value': '41', 'label': 'kg CO₂ Saved'},
      {'icon': Icons.star, 'value': '4.9', 'label': 'Rating'},
    ];

    return Row(
      children: stats.asMap().entries.map((e) {
        final stat = e.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: e.key < 2 ? 12 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              children: [
                Icon(stat['icon'] as IconData, color: AppColors.primary, size: 28),
                const SizedBox(height: 8),
                Text(stat['value'] as String, style: GoogleFonts.sora(
                  fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white,
                )),
                const SizedBox(height: 4),
                Text(stat['label'] as String, style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSettingsList(BuildContext context) {
    final settings = [
      {'icon': Icons.directions_car, 'label': 'Launch Car Display Demo', 'route': '/carplay'},
      {'icon': Icons.monitor_heart, 'label': 'Host Telemetry Dashboard', 'route': '/host-telemetry'},
      {'icon': Icons.credit_card, 'label': 'Payment Methods', 'route': '/payment-methods'},
      {'icon': Icons.notifications, 'label': 'Notifications', 'route': '/notifications'},
      {'icon': Icons.help, 'label': 'Help & Support', 'route': '/help-support'},
      {'icon': Icons.lock, 'label': 'Privacy', 'route': '/privacy'},
    ];

    return Column(
      children: settings.asMap().entries.map((e) {
        final setting = e.value;
        final route = setting['route'] as String;
        final isHighlighted = route == '/carplay' || route == '/host-telemetry';
        final highlightColor = route == '/host-telemetry' ? AppColors.warning : AppColors.primary;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: isHighlighted ? highlightColor.withValues(alpha: 0.1) : const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {
                if (route.isNotEmpty) {
                  context.push(route);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHighlighted ? highlightColor.withValues(alpha: 0.3) : AppColors.borderDark
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isHighlighted ? highlightColor : AppColors.surfaceVariantDark,
                      ),
                      child: Icon(setting['icon'] as IconData, color: isHighlighted ? Colors.black : Colors.white, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(setting['label'] as String, style: GoogleFonts.manrope(
                        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
                      )),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (500 + e.key * 80).ms).slideX(begin: 0.05);
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text('Sign out', style: GoogleFonts.manrope(
            color: AppColors.textSecondary, fontWeight: FontWeight.w500,
          )),
        ),
        const SizedBox(height: 8),
        Text('v0.9.2 · VOLTNEST', style: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.textMuted.withValues(alpha: 0.5), letterSpacing: 2,
        )),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }
}
