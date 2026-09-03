import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

import 'package:vnest_app/core/models/booking_model.dart';
import 'package:vnest_app/core/providers/auth_provider.dart';
import 'package:vnest_app/core/services/session_service.dart';

class ArrivedMapScreen extends StatefulWidget {
  final BookingModel booking;
  const ArrivedMapScreen({super.key, required this.booking});

  @override
  State<ArrivedMapScreen> createState() => _ArrivedMapScreenState();
}

class _ArrivedMapScreenState extends State<ArrivedMapScreen> {
  int _seconds = 320; // 5:20
  bool _isUnlocked = false;
  bool _isLoading = false;
  late final BookingModel _booking;
  final _sessionService = SessionService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '00:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Map area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Map background
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F4),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF1F3F4),
                        AppColors.primaryDark.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _MapMeshPainter(),
                  ),
                ),
                // Navigation header
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                      )],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on, color: Color(0xFF004B1E)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Destination', style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w700,
                                color: AppColors.textDarkSecondary,
                              )),
                              Text(_booking.chargerName, style: GoogleFonts.manrope(
                                fontSize: 18, fontWeight: FontWeight.w600,
                                color: AppColors.textDarkPrimary,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.3),
                ),
                // Current location pin
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark.withValues(alpha: 0.2),
                        ),
                      ).animate(onPlay: (c) => c.repeat()).custom(
                        duration: 2.seconds,
                        builder: (_, v, child) => Transform.scale(
                          scale: 1.0 + v * 0.5,
                          child: Opacity(opacity: 1.0 - v * 0.8, child: child),
                        ),
                      ),
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                          )],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom sheet
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 40, offset: const Offset(0, -8),
              )],
              border: Border(top: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pull bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      // Arrived header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Arrived in', style: GoogleFonts.manrope(
                                fontSize: 24, fontWeight: FontWeight.w700,
                                color: AppColors.textDarkPrimary,
                              )),
                              Text('Your journey is complete', style: GoogleFonts.plusJakartaSans(
                                fontSize: 12, color: AppColors.textDarkSecondary,
                              )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_formattedTime, style: GoogleFonts.manrope(
                                fontSize: 22, fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              )),
                              Text('ELAPSED TIME', style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, fontWeight: FontWeight.w700,
                                color: AppColors.outline,
                              )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Host profile
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppColors.surfaceContainerLight,
                                  child: const Icon(Icons.person, color: AppColors.textDarkSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Host', style: GoogleFonts.manrope(
                                    fontSize: 18, fontWeight: FontWeight.w600,
                                    color: AppColors.textDarkPrimary,
                                  )),
                                  Text('Host ID: ${_booking.hostId.substring(0, 5).toUpperCase()}', style: GoogleFonts.manrope(
                                    fontSize: 13, color: cs.onSurfaceVariant,
                                  )),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.call),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceContainerLight,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chat),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceContainerLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Payment summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inverseSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.credit_card, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('•••• 7493', style: GoogleFonts.manrope(
                                      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white,
                                    )),
                                    Text('Credit card', style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12, color: Colors.white.withValues(alpha: 0.7),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_booking.chargerName, style: GoogleFonts.sora(
                                  fontSize: 22, fontWeight: FontWeight.w700, color: cs.onSurface,
                                )),
                                Text('Total Charge', style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10, fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.5),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Start session button
                      SizedBox(
                        width: double.infinity, height: 56,
                        child: FilledButton(
                          onPressed: _isLoading ? null : () async {
                            if (!_isUnlocked) {
                              setState(() => _isUnlocked = true);
                              return;
                            }
                            
                            setState(() => _isLoading = true);
                            try {
                              final user = AuthProvider().currentUser;
                              if (user == null) throw Exception('User not logged in');

                              final session = await _sessionService.startSession(
                                bookingId: _booking.id,
                                userId: user.id,
                                chargerId: _booking.chargerId,
                              );

                              if (mounted) {
                                context.push('/active-session', extra: session);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString()), backgroundColor: cs.error),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(_isUnlocked ? 'Plug In to Start' : 'Unlock Charger', style: GoogleFonts.manrope(
                            fontSize: 16, fontWeight: FontWeight.w700,
                          )),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                    ],
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

class _MapMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6BFF8F).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 20) {
      for (double y = 0; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
    for (double x = 10; x < size.width; x += 20) {
      for (double y = 10; y < size.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
