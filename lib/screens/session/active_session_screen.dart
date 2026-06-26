import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/services/ocpp_service.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late StreamSubscription<OcppTelemetry> _subscription;
  
  double _kwhDelivered = 0.0;
  double _cost = 0.0;
  int _durationSeconds = 0;
  double _powerKw = 0.0;
  double _voltage = 0.0;
  double _progress = 0.0;
  String _statusText = 'Starting...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Start IoT Simulation
    final service = OcppService();
    service.startSession();
    
    _subscription = service.telemetryStream.listen((data) {
      if (mounted) {
        setState(() {
          _kwhDelivered = data.kwhDelivered;
          _cost = data.cost;
          _durationSeconds = data.durationSeconds;
          _powerKw = data.powerKw;
          _voltage = data.voltage;
          _progress = data.progressPercentage;
          
          switch (data.status) {
            case ChargeStatus.preparing: _statusText = 'Preparing...'; break;
            case ChargeStatus.charging: _statusText = 'Charging in Progress'; break;
            case ChargeStatus.suspended: _statusText = 'Suspended'; break;
            case ChargeStatus.finished: _statusText = 'Charging Complete'; break;
            case ChargeStatus.faulted: _statusText = 'Hardware Fault'; break;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _subscription.cancel();
    OcppService().stopSession();
    super.dispose();
  }

  String get _formattedDuration {
    final m = (_durationSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_durationSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bolt, color: Color(0xFF00E676)),
                  ),
                  IconButton(
                    onPressed: () => context.go('/profile'),
                    icon: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1E1E1E),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                child: Column(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10, height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF00E676),
                            ),
                          ).animate(onPlay: (c) => c.repeat()).fadeIn().then().fadeOut().then().fadeIn(),
                          const SizedBox(width: 8),
                          Text(_statusText, style: GoogleFonts.plusJakartaSans(
                            fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF00E676),
                          )),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2),
                    const SizedBox(height: 8),
                    Text('Station #BLR-42A', style: GoogleFonts.manrope(
                      fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white,
                    )).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 32),
                    // Progress ring
                    _buildProgressRing(),
                    const SizedBox(height: 32),
                    // Stats grid
                    _buildStatsGrid(),
                    const SizedBox(height: 16),
                    // Charging curve
                    _buildChargingCurve(),
                    const SizedBox(height: 24),
                    // Action buttons
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing() {
    return SizedBox(
      width: 256, height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow background
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00E676).withValues(
                    alpha: 0.1 + sin(_pulseController.value * pi * 2) * 0.05,
                  ),
                ),
              );
            },
          ),
          // SVG-like progress ring
          CustomPaint(
            size: const Size(256, 256),
            painter: _ProgressRingPainter(progress: _progress),
          ),
          // Inner content
          Container(
            width: 192, height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF131313),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  blurRadius: 40,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: _kwhDelivered.toStringAsFixed(1),
                      style: GoogleFonts.manrope(
                        fontSize: 36, fontWeight: FontWeight.w800,
                        color: Colors.white, letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: 'kWh',
                      style: GoogleFonts.manrope(
                        fontSize: 18, fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ]),
                ),
                Text('DELIVERED', style: GoogleFonts.plusJakartaSans(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: const Color(0xFF00E676), letterSpacing: 2,
                )),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'icon': Icons.payments, 'color': Colors.blue.shade300, 'value': '₹${_cost.toStringAsFixed(0)}', 'label': 'Cost so far'},
      {'icon': Icons.schedule, 'color': Colors.orange.shade300, 'value': _formattedDuration, 'label': 'Duration'},
      {'icon': Icons.bolt, 'color': const Color(0xFF00E676), 'value': '${_powerKw.toStringAsFixed(1)} kW', 'label': 'Current Power'},
      {'icon': Icons.electric_meter, 'color': Colors.purple.shade300, 'value': '${_voltage.toStringAsFixed(1)} V', 'label': 'Voltage'},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: stats.asMap().entries.map((e) {
        final stat = e.value;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat['icon'] as IconData, color: stat['color'] as Color, size: 24),
              const SizedBox(height: 8),
              Text(stat['value'] as String, style: GoogleFonts.manrope(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
              )),
              Text(stat['label'] as String, style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey,
              )),
            ],
          ),
        ).animate().fadeIn(delay: (200 + e.key * 100).ms);
      }).toList(),
    );
  }

  Widget _buildChargingCurve() {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Charging Curve', style: GoogleFonts.plusJakartaSans(
                fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
              )),
              Text('Live', style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF00E676),
              )),
            ],
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: SizedBox(
              height: 80,
              child: CustomPaint(
                size: Size.infinite,
                painter: _ChargingCurvePainter(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity, height: 56,
          child: FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  title: Text('Stop Charging?', style: GoogleFonts.sora(color: Colors.white)),
                  content: Text('Are you sure you want to stop the charging session?', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('Cancel', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                    ),
                    FilledButton(
                      onPressed: () {
                        context.pop(); // close dialog
                        context.go('/payment-success'); // simulate going to receipt
                      },
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Stop Session'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.stop_circle, size: 24),
            label: Text('Stop Charging', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w600,
            )),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: const Color(0xFF131313),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity, height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connecting to Emergency Support...'),
                  backgroundColor: Color(0xFF1E1E1E),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.support_agent),
            label: Text('Emergency Support', style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w600,
            )),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress
    final progressPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, sweepAngle, false, glowPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, sweepAngle, false, progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ChargingCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00E676).withValues(alpha: 0.5),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.55),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.25),
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.8, size.height * 0.15),
      Offset(size.width * 0.9, size.height * 0.05),
      Offset(size.width, 0),
    ];

    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
