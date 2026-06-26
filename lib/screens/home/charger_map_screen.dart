import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnest_app/core/theme/app_theme.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class ChargerMapScreen extends StatefulWidget {
  const ChargerMapScreen({super.key});

  @override
  State<ChargerMapScreen> createState() => _ChargerMapScreenState();
}

class _ChargerMapScreenState extends State<ChargerMapScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController(text: 'Current Location');
  int _selectedFilter = 0;
  final List<String> _filters = ['7kW+', 'Type-2', 'Available', 'Free Parking'];

  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return;
    } 

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        children: [
          // Map background
          Positioned.fill(child: _buildFlutterMap()),
          // Top app bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
          // Search and filters
          Positioned(
            top: MediaQuery.of(context).padding.top + 72,
            left: 16,
            right: 16,
            child: _buildSearchAndFilters(),
          ),
          // Filter FAB
          Positioned(
            bottom: 210,
            right: 16,
            child: _buildFilterFab(),
          ),
          // Bottom charger card
          Positioned(
            bottom: 8,
            left: 16,
            right: 16,
            child: _buildChargerCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlutterMap() {
    final center = _currentPosition ?? const LatLng(18.5204, 73.8567);
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: center,
              width: 24,
              height: 24,
              child: _buildPulsingPin(true),
            ),
            Marker(
              point: LatLng(center.latitude + 0.005, center.longitude + 0.005),
              width: 12,
              height: 12,
              child: _buildPulsingPin(false),
            ),
            Marker(
              point: LatLng(center.latitude - 0.005, center.longitude - 0.005),
              width: 12,
              height: 12,
              child: _buildPulsingPin(false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPulsingPin(bool isActive) {
    if (!isActive) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1C1B1B),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
      );
    }
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scaleXY(begin: 0.8, end: 1.3, duration: 1500.ms)
              .fadeOut(begin: 0.6, duration: 1500.ms),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(
                  color: const Color(0xFF131313), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF131313).withValues(alpha: 0.8),
        border: Border(
          bottom:
              BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.near_me, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '70/549',
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.expand_more,
                      color: AppColors.textSecondary, size: 20),
                ],
              ),
              Text(
                'Maharshi Nagar, Pune, Maharashtra, India',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.person, color: Color(0xFF131313)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.3);
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Search bar
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1B1B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.search,
                  color: Colors.white.withValues(alpha: 0.5)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style:
                      GoogleFonts.plusJakartaSans(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search destination or charger ID',
                    hintStyle: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: const Icon(Icons.my_location,
                    color: AppColors.primary, size: 16),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
        const SizedBox(height: 8),
        // Filter chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedFilter == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : const Color(0xFF1C1B1B),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index == 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Icons.bolt,
                              size: 16,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white),
                        ),
                      if (index == 2)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Icons.check_circle,
                              size: 16, color: AppColors.primary),
                        ),
                      Text(
                        _filters[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildFilterFab() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1C1B1B),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Icon(Icons.tune, color: Colors.white),
    ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.5, 0.5));
  }

  Widget _buildChargerCard() {
    return GestureDetector(
      onTap: () => context.push('/charger-details'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available badge
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
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
                          const SizedBox(width: 6),
                          Text(
                            'AVAILABLE NOW',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tesla Gen 3 Wallbox',
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.straighten,
                              size: 16,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '0.8km away',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color:
                                  Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Icon(Icons.ev_station,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Charging Rate',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: '₹12'),
                          TextSpan(
                            text: '/kWh',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () => context.push('/charger-details'),
                  icon: const Icon(Icons.bolt, size: 20),
                  label: Text(
                    'Start Nav',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3);
  }
}
