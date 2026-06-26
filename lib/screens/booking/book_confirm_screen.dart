import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vnest_app/core/models/pricing_models.dart';
import 'package:vnest_app/core/services/pricing_engine.dart';
import 'package:vnest_app/core/theme/app_theme.dart';

class BookConfirmScreen extends StatefulWidget {
  const BookConfirmScreen({super.key});

  @override
  State<BookConfirmScreen> createState() => _BookConfirmScreenState();
}

class _BookConfirmScreenState extends State<BookConfirmScreen> {
  String _selectedPayment = 'upi';
  final _pricingEngine = PricingEngine();
  PricingQuote? _quote;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPricing();
  }

  Future<void> _loadPricing() async {
    try {
      final quote = await _pricingEngine.getQuote(DemoChargers.voltChargeHub);
      if (mounted) setState(() { _quote = quote; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _pricingEngine.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.8),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceDark,
              border: Border.all(color: AppColors.borderDark),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          'REVIEW BOOKING',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            child: Column(
              children: [
                // Summary card
                _buildSummaryCard(),
                const SizedBox(height: 24),
                // Cost breakdown
                _buildCostBreakdown(),
                const SizedBox(height: 24),
                // Payment methods
                _buildPaymentMethods(),
              ],
            ),
          ),
          // Bottom CTA
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomCta(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDark),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VoltCharge Fast Hub', style: GoogleFonts.sora(
                      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
                    )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          child: const Icon(Icons.person, size: 12, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text('HOST: AMAN S.', style: GoogleFonts.jetBrainsMono(
                          fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: const Icon(Icons.ev_station, color: AppColors.primary, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Bento grid
          Row(
            children: [
              // Time slot
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RESERVED SLOT', style: GoogleFonts.jetBrainsMono(
                        fontSize: 10, color: AppColors.textSecondary,
                      )),
                      const SizedBox(height: 8),
                      Text('Today, 14:00 - 15:00', style: GoogleFonts.sora(
                        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
                      )),
                      const SizedBox(height: 4),
                      Text('1 hour duration', style: GoogleFonts.manrope(
                        fontSize: 12, color: AppColors.textSecondary,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Location
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LOCATION', style: GoogleFonts.jetBrainsMono(
                        fontSize: 10, color: AppColors.textSecondary,
                      )),
                      Text('70/549, Maharshi Nagar, Pune', style: GoogleFonts.sora(
                        fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildCostBreakdown() {
    final quote = _quote;
    final currency = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PRICING SUMMARY', style: GoogleFonts.jetBrainsMono(
            fontSize: 10, color: AppColors.textSecondary, letterSpacing: 2,
          )),
          const SizedBox(height: 16),
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              ),
            )
          else if (quote != null) ...[
            _costRow(
              'Base rate (₹${quote.baseRatePerKwh.toStringAsFixed(0)}/kWh)',
              currency.format(quote.baseCost),
              null,
            ),
            const SizedBox(height: 16),
            if (quote.hasSurge)
              _costRow(
                'Demand surcharge',
                '+${currency.format(quote.surcharge)}',
                AppColors.warning,
                badge: 'x${quote.surgeMultiplier}',
              ),
            if (quote.hasSurge) const SizedBox(height: 16),
            _buildDemandRow(quote),
            const SizedBox(height: 16),
            _costRow(
              'Estimated Energy',
              '${quote.estimatedKwh} kWh',
              AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.borderDark),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('TOTAL TO PAY', style: GoogleFonts.jetBrainsMono(
                  fontSize: 12, color: AppColors.textSecondary,
                )),
                Text(currency.format(quote.totalCost), style: GoogleFonts.sora(
                  fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary,
                  letterSpacing: -1,
                )),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildDemandRow(PricingQuote quote) {
    final color = switch (quote.demandLevel) {
      DemandLevel.high => AppColors.warning,
      DemandLevel.medium => AppColors.primary,
      DemandLevel.low => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_graph, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ML Predicted Demand: ${quote.demandLabel}',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Text(
            quote.source == PricingSource.ml ? 'ML' : 'Fallback',
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value, Color? valueColor, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(label, style: GoogleFonts.manrope(
              fontSize: 14, color: AppColors.textSecondary,
            )),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge, style: GoogleFonts.jetBrainsMono(
                  fontSize: 10, color: AppColors.warning,
                )),
              ),
            ],
          ],
        ),
        Text(value, style: GoogleFonts.sora(
          fontSize: 14, fontWeight: FontWeight.w700,
          color: valueColor ?? Colors.white,
        )),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SELECT PAYMENT METHOD', style: GoogleFonts.jetBrainsMono(
          fontSize: 10, color: AppColors.textSecondary, letterSpacing: 2,
        )),
        const SizedBox(height: 12),
        _paymentOption('upi', Icons.qr_code_scanner, 'UPI / QR', 'GPay, PhonePe, Paytm', true),
        const SizedBox(height: 12),
        _paymentOption('card', Icons.credit_card, 'Credit/Debit Card', 'Visa, Mastercard, RuPay', true),
        const SizedBox(height: 12),
        _paymentOption('wallet', Icons.account_balance_wallet, 'Volt Wallet', 'Balance: ₹12.00 (Insufficient)', false),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _paymentOption(String value, IconData icon, String title, String subtitle, bool enabled) {
    final isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: enabled ? () => setState(() => _selectedPayment = value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: enabled ? AppColors.surfaceDark : AppColors.surfaceDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariantDark,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.borderDark,
                ),
              ),
              child: Icon(icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.sora(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: enabled ? Colors.white : AppColors.textMuted,
                  )),
                  Text(subtitle, style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: !enabled && value == 'wallet'
                        ? AppColors.warning
                        : AppColors.textSecondary,
                  )),
                ],
              ),
            ),
            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderDark,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12, height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCta() {
    final total = _quote != null
        ? NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2)
            .format(_quote!.totalCost)
        : '—';

    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: FilledButton.icon(
          onPressed: _loading || _quote == null ? null : () => context.push('/payment-success'),
          icon: const Icon(Icons.lock, size: 20),
          label: Text('CONFIRM & PAY $total', style: GoogleFonts.sora(
            fontSize: 16, fontWeight: FontWeight.w800,
          )),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}
