import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';


class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  
  bool _isLoading = true;
  String _address = 'Loading address...';
  bool _isLoadingAddress = false;
  Timer? _debounceTimer;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchInitialLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isLoading && !_isDialogOpen) {
      _fetchInitialLocation();
    }
  }

  Future<void> _fetchInitialLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showPermissionDialog(
          title: 'Location Services Disabled',
          message: 'Please enable location services on your device to choose and share your location.',
          onOpenSettings: () => Geolocator.openLocationSettings(),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDialog(
            title: 'Permission Denied',
            message: 'Location permissions are required to choose and share your location. Please grant permission.',
            onOpenSettings: () => Geolocator.openAppSettings(),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog(
          title: 'Permission Denied Forever',
          message: 'Location permissions are permanently denied. Please enable them in your app settings to share location.',
          onOpenSettings: () => Geolocator.openAppSettings(),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = position.latitude;
      double lng = position.longitude;

      // Check if it is the default emulator coordinates (Mountain View, CA)
      if ((lat - 37.421998).abs() < 0.005 && (lng - -122.084000).abs() < 0.005) {
        final ipLoc = await _getIpLocation();
        if (ipLoc != null) {
          lat = ipLoc['latitude']!;
          lng = ipLoc['longitude']!;
        }
      }

      final startPoint = LatLng(lat, lng);
      if (mounted) {
        setState(() {
          _currentLocation = startPoint;
          _selectedLocation = startPoint;
          _isLoading = false;
        });
      }

      // Animate map to the user's location and start reverse geocoding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(startPoint, 16.0);
          _reverseGeocode(startPoint);
        }
      });
    } catch (e) {
      debugPrint('Error fetching initial location: $e');
      _showError('Could not fetch location. Using fallback location.');
      // Use Phnom Penh as absolute fallback coordinates if error occurs
      final fallbackPt = LatLng(11.5564, 104.9282);
      if (mounted) {
        setState(() {
          _currentLocation = fallbackPt;
          _selectedLocation = fallbackPt;
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(fallbackPt, 16.0);
          _reverseGeocode(fallbackPt);
        });
      }
    }
  }

  Future<Map<String, double>?> _getIpLocation() async {
    final dio = Dio();
    try {
      final response = await dio.get('https://ipapi.co/json/');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map) {
          final double? lat = (data['latitude'] as num?)?.toDouble();
          final double? lng = (data['longitude'] as num?)?.toDouble();
          if (lat != null && lng != null) {
            return {'latitude': lat, 'longitude': lng};
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching from ipapi.co: $e');
    }

    try {
      final response = await dio.get('https://ipinfo.io/json');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map) {
          final String? loc = data['loc'] as String?;
          if (loc != null) {
            final parts = loc.split(',');
            if (parts.length == 2) {
              final double? lat = double.tryParse(parts[0]);
              final double? lng = double.tryParse(parts[1]);
              if (lat != null && lng != null) {
                return {'latitude': lat, 'longitude': lng};
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching from ipinfo.io: $e');
    }
    return null;
  }

  Future<void> _reverseGeocode(LatLng point) async {
    if (!mounted) return;
    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': point.latitude,
          'lon': point.longitude,
          'accept-language': 'en,kh',
        },
        options: Options(
          headers: {
            'User-Agent': 'demo_2_flutter_app',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map) {
          String resolvedAddr = "";
          if (data['address'] != null) {
            final addr = data['address'] as Map;
            final List<String> parts = [];
            
            final place = addr['amenity'] ?? addr['building'] ?? addr['shop'] ?? addr['tourism'] ?? addr['historic'] ?? addr['road'];
            if (place != null) {
              parts.add(place.toString());
            }

            final suburb = addr['suburb'] ?? addr['neighbourhood'] ?? addr['village'] ?? addr['quarter'];
            if (suburb != null) {
              parts.add(suburb.toString());
            }

            final city = addr['city'] ?? addr['town'] ?? addr['county'];
            if (city != null) {
              parts.add(city.toString());
            }

            final country = addr['country'];
            if (country != null) {
              parts.add(country.toString());
            }

            resolvedAddr = parts.join(', ');
          }

          if (resolvedAddr.isEmpty) {
            resolvedAddr = data['display_name'] ?? 'Unknown Address';
          }

          if (mounted) {
            setState(() {
              _address = resolvedAddr;
              _isLoadingAddress = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Error reverse-geocoding: $e');
    }

    if (mounted) {
      setState(() {
        _address = '${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
        _isLoadingAddress = false;
      });
    }
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    setState(() {
      _selectedLocation = camera.center;
    });

    if (hasGesture) {
      setState(() {
        _isLoadingAddress = true;
        _address = 'Loading address...';
      });
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 800), () {
        _reverseGeocode(camera.center);
      });
    }
  }

  String _getDistanceText() {
    if (_currentLocation == null || _selectedLocation == null) return '';
    final double distanceInMeters = Geolocator.distanceBetween(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      _selectedLocation!.latitude,
      _selectedLocation!.longitude,
    );
    final double miles = distanceInMeters * 0.000621371;
    if (miles < 0.05) {
      return '0.0 mi';
    }
    return '${miles.toStringAsFixed(1)} mi';
  }

  void _showError(String message) {
    if (!mounted) return;
    Get.snackbar(
      'Location Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  void _showPermissionDialog({
    required String title,
    required String message,
    required VoidCallback onOpenSettings,
  }) {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogOpen = false;
              Get.back(); // Pop dialog
              Get.back(); // Return to chat detail page
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _isDialogOpen = false;
              Get.back(); // Pop dialog
              onOpenSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2046E8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Header Colors
    final Color headerBg = isDark ? const Color(0xFF131A26) : const Color(0xFFFFFFFF);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final Color closeBtnBg = isDark ? const Color(0xFF2E3540) : const Color(0xFFF2F5FC);
    final Color closeIconColor = isDark ? Colors.white : const Color(0xFF6B7280);

    // Bottom Card Colors
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color addressTextColor = isDark ? Colors.white : const Color(0xFF111827);
    final Color subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final Color sendBtnColor = const Color(0xFF2046E8);

    // CartoDB Tile Template - responsive theme
    final String mapTileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF2F5FC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Premium Header ──────────────────────────────────────────────
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: headerBg,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? const Color(0xFF243347) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Blue location icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2046E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.near_me_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title text
                  Text(
                    'Location',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  // Close button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: closeBtnBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: closeIconColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Map / Body ──────────────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2046E8),
                      ),
                    )
                  else ...[
                    // Map Layout
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation ?? LatLng(11.5564, 104.9282),
                        initialZoom: 16.0,
                        maxZoom: 19.0,
                        minZoom: 3.0,
                        onPositionChanged: _onMapPositionChanged,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: mapTileUrl,
                          userAgentPackageName: 'com.example.demo_2',
                        ),
                        // Current Location Marker (Blue Dot)
                        if (_currentLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentLocation!,
                                width: 22,
                                height: 22,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2046E8),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Static Center Selector Pin
                    Center(
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.black,
                              size: 42,
                            ),
                            Positioned(
                              top: 10,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Target Centering Button (Bottom Right)
                    Positioned(
                      bottom: 175,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (_currentLocation != null) {
                            _mapController.move(_currentLocation!, 16.0);
                            _reverseGeocode(_currentLocation!);
                            setState(() {
                              _selectedLocation = _currentLocation;
                            });
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.near_me_rounded,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                    // ── Bottom Detail Card ──────────────────────────────────
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                // Black Pin Circle
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Address details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: addressTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _isLoadingAddress ? 'Updating distance...' : _getDistanceText(),
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
                            // Send Location button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _selectedLocation == null || _isLoadingAddress
                                    ? null
                                    : () {
                                        Get.back(result: {
                                          'latitude': _selectedLocation!.latitude,
                                          'longitude': _selectedLocation!.longitude,
                                          'address': _address,
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: sendBtnColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  disabledBackgroundColor: sendBtnColor.withValues(alpha: 0.5),
                                ),
                                child: const Text(
                                  'SEND LOCATION',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
