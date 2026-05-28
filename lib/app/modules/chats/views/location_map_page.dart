import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/theme_extensions.dart';

class LocationMapPage extends StatefulWidget {
  const LocationMapPage({super.key});

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  bool _isSatelliteMode = true; // Default to Satellite view

  @override
  Widget build(BuildContext context) {
    // Retrieve coordinates from arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    final double latitude = args['latitude'] ?? 10.790;
    final double longitude = args['longitude'] ?? 104.562;
    final String locationTitle = args['title'] ?? 'Shared Location';

    final Color primaryColor = AppColors.primary;
    final Color cardBg = AppColors.card;
    final Color textColor = AppColors.text;
    final Color subtitleColor = AppColors.subtitle;

    final LatLng locationPoint = LatLng(latitude, longitude);

    // Google Maps Tile Templates
    // lyrs=y: Hybrid (Satellite + Roads + Labels)
    // lyrs=m: Standard Roadmap
    final String tileUrl = _isSatelliteMode
        ? 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
        : 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
          ),
        ),
        titleSpacing: 8,
        title: Text(
          'Location Viewer',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // ── Flutter Map (Google Tiles) ────────────────────────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: locationPoint,
              initialZoom: 16.0,
              maxZoom: 20.0,
              minZoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.example.demo_2',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: locationPoint,
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ripple outer effect
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Inner Pin
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.redAccent,
                          size: 38,
                        ),
                        // Dot inside Pin
                        Positioned(
                          top: 13,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
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

          // ── Map Layer Switcher Button (Top Right) ──────────────────────────
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSatelliteMode = !_isSatelliteMode;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isSatelliteMode ? Icons.map_rounded : Icons.satellite_alt_rounded,
                  color: primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),

          // ── Floating Location Detail Card at the bottom ────────────────────
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.my_location_rounded,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationTitle,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Latitude: ${latitude.toStringAsFixed(6)}, Longitude: ${longitude.toStringAsFixed(6)}',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Close Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
