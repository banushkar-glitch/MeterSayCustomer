import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metersay_app/rides/mapscreen.dart';
import 'package:metersay_app/rides/rideraccepted.dart';
import 'package:metersay_app/services/location_service.dart';
import 'package:metersay_app/services/ride_service.dart';

class LocatingDriverScreen extends StatefulWidget {
  final int? rideId;
  final String? pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? dropAddress;
  final double? dropLatitude;
  final double? dropLongitude;
  final int? nearbyDriversCount;
  final double? initialSearchRadius;

  const LocatingDriverScreen({
    super.key,
    this.rideId,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropAddress,
    this.dropLatitude,
    this.dropLongitude,
    this.nearbyDriversCount,
    this.initialSearchRadius,
  });

  @override
  State<LocatingDriverScreen> createState() => _LocatingDriverScreenState();
}

class _LocatingDriverScreenState extends State<LocatingDriverScreen>
    with SingleTickerProviderStateMixin {
  final RideService _rideService = RideService();
  GoogleMapController? _googleMapController;
  BitmapDescriptor _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _destinationMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

  int? _rideId;
  String _pickupAddress = 'Current location';
  String _dropAddress = 'Destination';
  double _pickupLat = 18.5204;
  double _pickupLng = 73.8567;
  double? _dropLat;
  double? _dropLng;

  double _searchRadiusMeters = 500.0;
  String _statusMessage = 'Searching for nearby auto drivers within 500m...';
  bool _isSearching = true;
  bool _isCancelling = false;
  int _elapsedSeconds = 0;

  Timer? _pollingTimer;
  Timer? _clockTimer;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _rideId = widget.rideId;
    _pickupAddress = widget.pickupAddress ?? 'Current location';
    _dropAddress = widget.dropAddress ?? 'Destination';
    _pickupLat = widget.pickupLatitude ?? 18.5204;
    _pickupLng = widget.pickupLongitude ?? 73.8567;
    _dropLat = widget.dropLatitude;
    _dropLng = widget.dropLongitude;
    _searchRadiusMeters = widget.initialSearchRadius ?? 500.0;
    _statusMessage = _searchRadiusMeters <= 500.0
        ? 'Searching for nearby auto drivers within 500m...'
        : 'Searching for nearby auto drivers within 1 km...';

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _loadMarkerIcons();
    _initRideAndStartPolling();
  }

  Future<void> _loadMarkerIcons() async {
    final pickup = await LocationService.getPickupMarkerIcon();
    final dest = await LocationService.getDestinationMarkerIcon();
    if (!mounted) return;
    setState(() {
      _pickupMarkerIcon = pickup;
      _destinationMarkerIcon = dest;
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _clockTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _initRideAndStartPolling() async {
    // If rideId was not passed, retrieve the active ride from backend
    if (_rideId == null) {
      final active = await _rideService.getActiveRide();
      if (active['success'] == true && active['hasActiveRide'] == true) {
        final data = active['data'];
        if (mounted) {
          setState(() {
            _rideId = data['rideId'];
            _pickupAddress = data['pickupAddress'] ?? _pickupAddress;
            _dropAddress = data['dropAddress'] ?? _dropAddress;
            _pickupLat = (data['pickupLatitude'] as num?)?.toDouble() ?? _pickupLat;
            _pickupLng = (data['pickupLongitude'] as num?)?.toDouble() ?? _pickupLng;
            _dropLat = (data['dropLatitude'] as num?)?.toDouble();
            _dropLng = (data['dropLongitude'] as num?)?.toDouble();
            if (data['searchRadiusMeters'] != null) {
              _searchRadiusMeters = (data['searchRadiusMeters'] as num).toDouble();
            }
          });
        }
      }
    }

    // Start 1-second clock for search status updates and timeout
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
        if (_elapsedSeconds >= 60 && _isSearching) {
          _isSearching = false;
          _statusMessage = 'No nearby auto drivers available. Please try again later.';
          _progressController.stop();
        } else if (_isSearching) {
          if (_searchRadiusMeters >= 1000) {
            _statusMessage = _elapsedSeconds > 35
                ? 'Still searching nearby auto drivers within 1 km...'
                : 'Search expanded to 1 km. Contacting drivers...';
          } else {
            _statusMessage = _elapsedSeconds > 10
                ? 'Searching for available auto drivers within 500m...'
                : 'Searching for nearby auto drivers within 500m...';
          }
        }
      });
    });

    // Start periodic polling every 3 seconds to check for driver assignment
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted || !_isSearching) return;

      Map<String, dynamic> response;
      if (_rideId != null) {
        response = await _rideService.getRideDetails(_rideId!);
      } else {
        response = await _rideService.getActiveRide();
      }

      if (!mounted) return;

      if (response['success'] == true) {
        final data = response['data'] ?? {};
        final String? status = data['status'];

        final double? backendRadius = (data['searchRadiusMeters'] as num?)?.toDouble();
        if (backendRadius != null && backendRadius != _searchRadiusMeters) {
          setState(() {
            _searchRadiusMeters = backendRadius;
            if (_searchRadiusMeters >= 1000) {
              _statusMessage = 'Search expanded to 1 km. Contacting drivers...';
            }
          });
          if (_googleMapController != null && _searchRadiusMeters >= 1000) {
            _googleMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(_pickupLat, _pickupLng),
                  zoom: 14.5,
                ),
              ),
            );
          }
        }

        if (status == 'DRIVER_ACCEPTED' ||
            status == 'ACCEPTED' ||
            status == 'DRIVER_ASSIGNED' ||
            status == 'DRIVER_ARRIVING' ||
            status == 'DRIVER_ARRIVED') {
          // Driver found and assigned!
          _pollingTimer?.cancel();
          _clockTimer?.cancel();
          _progressController.stop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Auto driver assigned: ${data['driverName'] ?? 'Driver'}!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RiderAccepted(
                rideId: data['rideId'],
                driverName: data['driverName'],
                driverPhoneNumber: data['driverPhoneNumber'],
                autoNumber: data['autoNumber'],
                autoModel: data['autoModel'],
                otp: (status == 'DRIVER_ARRIVED') ? data['otp']?.toString() : null,
                driverLatitude: (data['driverLatitude'] as num?)?.toDouble(),
                driverLongitude: (data['driverLongitude'] as num?)?.toDouble(),
                pickupAddress: data['pickupAddress'] ?? _pickupAddress,
                pickupLatitude: (data['pickupLatitude'] as num?)?.toDouble() ?? _pickupLat,
                pickupLongitude: (data['pickupLongitude'] as num?)?.toDouble() ?? _pickupLng,
                dropAddress: data['dropAddress'] ?? _dropAddress,
                dropLatitude: (data['dropLatitude'] as num?)?.toDouble() ?? _dropLat,
                dropLongitude: (data['dropLongitude'] as num?)?.toDouble() ?? _dropLng,
              ),
            ),
          );
        } else if (status == 'CANCELLED') {
          _pollingTimer?.cancel();
          _clockTimer?.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MappingScreen()),
            (route) => false,
          );
        }
      }
    });
  }

  void _confirmCancelRide() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Cancel Ride Search',
            style: TextStyle(
              fontFamily: 'Geologica',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel searching for nearby auto drivers?',
            style: TextStyle(fontFamily: 'Inria Serif'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Keep Searching', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performCancelRide();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel Ride', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performCancelRide() async {
    setState(() {
      _isCancelling = true;
    });

    _pollingTimer?.cancel();
    _clockTimer?.cancel();

    if (_rideId != null) {
      await _rideService.cancelRide(_rideId!, reason: 'Cancelled during driver search');
    } else {
      final active = await _rideService.getActiveRide();
      if (active['success'] == true && active['hasActiveRide'] == true) {
        final id = active['data']['rideId'];
        if (id != null) {
          final int rId = id is int ? id : int.tryParse(id.toString()) ?? 0;
          if (rId > 0) {
            await _rideService.cancelRide(rId, reason: 'Cancelled during driver search');
          }
        }
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ride search has been cancelled.'),
        backgroundColor: Colors.black87,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MappingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final bool isDesktop = screenWidth >= 900;
    final bool isTablet = screenWidth >= 600 && screenWidth < 900;
    final double contentMaxWidth = isDesktop
        ? 500
        : isTablet
            ? 480
            : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ==================================================
            // INTERACTIVE MAP
            // ==================================================
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: contentMaxWidth,
                  child: _buildMap(contentMaxWidth, screenHeight),
                ),
              ),
            ),

            // ==================================================
            // HEADER
            // ==================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(screenWidth),
            ),

            // ==================================================
            // DRIVER LOCATING BOTTOM SHEET
            // ==================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: (screenHeight * 0.094).clamp(80.0, 100.0),
              child: Center(
                child: SizedBox(
                  width: contentMaxWidth,
                  child: _buildDriverSheet(contentMaxWidth, screenHeight),
                ),
              ),
            ),

            // ==================================================
            // FOOTER
            // ==================================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildFooter(screenWidth, screenHeight),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INTERACTIVE LIVE MAP WITH 1 KM SEARCH RADIUS
  // ============================================================
  Widget _buildMap(double screenWidth, double screenHeight) {
    final LatLng pickupLatLng = LatLng(_pickupLat, _pickupLng);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: pickupLatLng,
        zoom: 15.0,
      ),
      onMapCreated: (controller) {
        _googleMapController = controller;
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      circles: {
        Circle(
          circleId: const CircleId('driver_search_radius'),
          center: pickupLatLng,
          radius: _searchRadiusMeters,
          fillColor: const Color(0x22FFD329),
          strokeColor: const Color(0xFFFFD329),
          strokeWidth: 2,
        ),
      },
      markers: {
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLatLng,
          icon: _pickupMarkerIcon,
          anchor: const Offset(0.5, 1.0),
          infoWindow: InfoWindow(title: 'Pickup: $_pickupAddress'),
        ),
        if (_dropLat != null && _dropLng != null)
          Marker(
            markerId: const MarkerId('drop'),
            position: LatLng(_dropLat!, _dropLng!),
            icon: _destinationMarkerIcon,
            anchor: const Offset(0.5, 1.0),
            infoWindow: InfoWindow(title: 'Drop: $_dropAddress'),
          ),
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader(double screenWidth) {
    final bool isDesktop = screenWidth >= 700;
    final double headerHeight = isDesktop ? 80 : 80;
    final double titleSize = isDesktop ? 28 : 20;

    return Container(
      width: double.infinity,
      height: headerHeight,
      color: const Color(0xFFFFD329),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: isDesktop ? 25 : 20),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF1D1B20),
                  size: isDesktop ? 30 : 28,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Locating Driver',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: isDesktop ? 25 : 20),
              child: IconButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.notifications_none,
                  color: const Color(0xFF1D1B20),
                  size: isDesktop ? 28 : 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRIVER LOCATING BOTTOM SHEET
  // ============================================================
  Widget _buildDriverSheet(double screenWidth, double screenHeight) {
    final bool isDesktop = screenWidth >= 700;
    final double sheetHeight = screenHeight * 0.320;
    final double horizontalPadding =
        isDesktop ? screenWidth * 0.025 : screenWidth * 0.020;

    return Container(
      width: double.infinity,
      height: sheetHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: screenHeight * 0.006,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isDesktop ? 30 : 24),
          topRight: Radius.circular(isDesktop ? 30 : 24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: isDesktop ? 100 : screenWidth * 0.13,
              height: isDesktop ? 6 : 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(height: screenHeight * 0.008),

            // Title
            Text(
              _isSearching ? 'Locating your auto driver' : 'Driver Search Status',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: isDesktop ? 20 : (screenWidth * 0.040).clamp(15.0, 19.0),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),

            // Subtitle / Status message
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inria Serif',
                fontSize: isDesktop ? 18 : (screenWidth * 0.042).clamp(15.0, 18.0),
                fontWeight: FontWeight.w400,
                color: _statusMessage.contains('No nearby') ? Colors.red : Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Searching Progress Bar
            _buildProgressBar(screenWidth, isDesktop),
            SizedBox(height: screenHeight * 0.020),

            // Location Card
            _buildLocationCard(screenWidth, screenHeight, isDesktop),
            SizedBox(height: screenHeight * 0.015),

            // Cancel / Retry Button
            _buildCancelButton(screenWidth, isDesktop),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATED SEARCHING PROGRESS BAR
  // ============================================================
  Widget _buildProgressBar(double screenWidth, bool isDesktop) {
    final double barHeight = isDesktop ? 8 : 6;

    if (!_isSearching) {
      return Container(
        width: double.infinity,
        height: barHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        final double value = _progressController.value;
        return Container(
          width: double.infinity,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (0.3 + (value * 0.7)).clamp(0.0, 1.0),
            child: Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD329),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LOCATION CARD
  // ============================================================
  Widget _buildLocationCard(
    double screenWidth,
    double screenHeight,
    bool isDesktop,
  ) {
    final double iconSize =
        isDesktop ? 30 : (screenWidth * 0.070).clamp(25.0, 30.0);
    final double textSize =
        isDesktop ? 17 : (screenWidth * 0.043).clamp(15.0, 17.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pickup
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 14 : screenWidth * 0.035,
              vertical: isDesktop ? 8 : screenHeight * 0.008,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: iconSize,
                  color: const Color(0xFF16B957),
                ),
                SizedBox(width: screenWidth * 0.025),
                Expanded(
                  child: Text(
                    _pickupAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: textSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFB5B5B5),
          ),

          // Drop
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 14 : screenWidth * 0.035,
              vertical: isDesktop ? 8 : screenHeight * 0.008,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: iconSize,
                  color: const Color(0xFFFF2020),
                ),
                SizedBox(width: screenWidth * 0.025),
                Expanded(
                  child: Text(
                    _dropAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: textSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CANCEL RIDE BUTTON
  // ============================================================
  Widget _buildCancelButton(double screenWidth, bool isDesktop) {
    final double buttonWidth =
        isDesktop ? 220 : (screenWidth * 0.55).clamp(190.0, 220.0);
    final double buttonHeight = isDesktop ? 38 : 36;
    final double textSize =
        isDesktop ? 17 : (screenWidth * 0.043).clamp(15.0, 17.0);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: _isCancelling ? null : _confirmCancelRide,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isCancelling
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Cancel Ride',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Serif',
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================
  Widget _buildFooter(double screenWidth, double screenHeight) {
    const double footerHeight = 80.0;
    return Container(
      width: double.infinity,
      height: footerHeight,
      color: const Color(0xFF3C3A3A),
    );
  }
}
