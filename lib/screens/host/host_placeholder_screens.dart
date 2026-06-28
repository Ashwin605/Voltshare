import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class HostChargersScreen extends StatelessWidget {
  const HostChargersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.ev_station,
                  color: cs.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'My Chargers',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your charger listings',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HostEarningsScreen extends StatelessWidget {
  const HostEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.attach_money,
                  color: cs.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Earnings',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your revenue and payouts',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HostSettingsScreen extends StatelessWidget {
  const HostSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings,
                  color: cs.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Settings',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your host preferences',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
