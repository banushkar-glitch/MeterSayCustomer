import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metersay_app/rides/mapscreen.dart';
import 'package:metersay_app/rides/ridecompleted.dart';
import 'package:metersay_app/sliders/customermenu.dart';
import 'package:metersay_app/services/location_service.dart';
import 'package:metersay_app/services/ride_service.dart';

class ActiveRideScreen extends StatefulWidget {
  final int? rideId;
  final String? driverName;
  final String? driverPhoneNumber;
  final String? autoNumber;
  final String? autoModel;
  final double? driverLatitude;
  final double? driverLongitude;
  final String? pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? dropAddress;
  final double? dropLatitude;
  final double? dropLongitude;

  const ActiveRideScreen({
    super.key,
    this.rideId,
    this.driverName,
    this.driverPhoneNumber,
    this.autoNumber,
    this.autoModel,
    this.driverLatitude,
    this.driverLongitude,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropAddress,
    this.dropLatitude,
    this.dropLongitude,
  });

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  bool isMenuOpen = false;
  GoogleMapController? _googleMapController;
  final RideService _rideService = RideService();
  BitmapDescriptor _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _destinationMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor _autoMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  List<LatLng> _routePoints = [];

  Timer? _pollingTimer;

  int? _rideId;
  String? _driverName;
  String? _autoNumber;
  String? _autoModel;
  String? _driverPhoneNumber;
  String? _pickupAddress;
  double? _pickupLat;
  double? _pickupLng;
  String? _dropAddress;
  double? _dropLat;
  double? _dropLng;
  double? _currentAutoLat;
  double? _currentAutoLng;

  String _distanceText = '-- km';
  String _etaText = '--';

  @override
  void initState() {
    super.initState();
    _rideId = widget.rideId;
    _driverName = widget.driverName;
    _autoNumber = widget.autoNumber;
    _autoModel = widget.autoModel;
    _driverPhoneNumber = widget.driverPhoneNumber;
    _pickupAddress = widget.pickupAddress;
    _pickupLat = widget.pickupLatitude;
    _pickupLng = widget.pickupLongitude;
    _dropAddress = widget.dropAddress;
    _dropLat = widget.dropLatitude;
    _dropLng = widget.dropLongitude;
    _currentAutoLat = widget.driverLatitude ?? widget.pickupLatitude;
    _currentAutoLng = widget.driverLongitude ?? widget.pickupLongitude;

    _loadMarkerIcons();
    _fetchDrivingRoute();
    _calculateDistanceAndEta();
    _fetchActiveRideDetails();
    _startStatusPolling();
  }

  Future<void> _loadMarkerIcons() async {
    final pickup = await LocationService.getPickupMarkerIcon();
    final dest = await LocationService.getDestinationMarkerIcon();
    final auto = await LocationService.getAutoMarkerIcon();
    if (!mounted) return;
    setState(() {
      _pickupMarkerIcon = pickup;
      _destinationMarkerIcon = dest;
      _autoMarkerIcon = auto;
    });
  }

  Future<void> _fetchDrivingRoute() async {
    if (_pickupLat != null && _pickupLng != null && _dropLat != null && _dropLng != null) {
      final start = LatLng(_pickupLat!, _pickupLng!);
      final end = LatLng(_dropLat!, _dropLng!);
      final details = await LocationService.getShortestRoute(start, end);
      if (!mounted) return;
      setState(() {
        _routePoints = details.polylinePoints;
      });
      _fitRouteBounds();
    }
  }

  void _fitRouteBounds() {
    if (_pickupLat != null && _pickupLng != null && _dropLat != null && _dropLng != null && _googleMapController != null) {
      final double minLat = min(_pickupLat!, _dropLat!);
      final double maxLat = max(_pickupLat!, _dropLat!);
      final double minLng = min(_pickupLng!, _dropLng!);
      final double maxLng = max(_pickupLng!, _dropLng!);

      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          60,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _calculateDistanceAndEta() {
    if (_pickupLat != null && _pickupLng != null && _dropLat != null && _dropLng != null) {
      final double distKm = _haversineDistance(_pickupLat!, _pickupLng!, _dropLat!, _dropLng!);
      setState(() {
        _distanceText = '${distKm.toStringAsFixed(1)} km';
        // Auto speed in city ~25 km/h
        final int etaMinutes = max(2, (distKm / 25.0 * 60.0).round());
        final now = DateTime.now().add(Duration(minutes: etaMinutes));
        final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
        final ampm = now.hour >= 12 ? 'PM' : 'AM';
        final minute = now.minute.toString().padLeft(2, '0');
        _etaText = '$hour.$minute $ampm';
      });
    }
  }

  double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295;
    final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _fetchActiveRideDetails() async {
    Map<String, dynamic> response;
    if (_rideId != null) {
      response = await _rideService.getRideDetails(_rideId!);
    } else {
      response = await _rideService.getActiveRide();
    }

    if (!mounted) return;

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      setState(() {
        _rideId ??= data['rideId'];
        _driverName ??= data['driverName'];
        _autoNumber ??= data['autoNumber'];
        _autoModel ??= data['autoModel'];
        _driverPhoneNumber ??= data['driverPhoneNumber'];
        _pickupAddress ??= data['pickupAddress'];
        _pickupLat ??= (data['pickupLatitude'] as num?)?.toDouble();
        _pickupLng ??= (data['pickupLongitude'] as num?)?.toDouble();
        _dropAddress ??= data['dropAddress'];
        _dropLat ??= (data['dropLatitude'] as num?)?.toDouble();
        _dropLng ??= (data['dropLongitude'] as num?)?.toDouble();
        if (data['driverLatitude'] != null && data['driverLongitude'] != null) {
          _currentAutoLat = (data['driverLatitude'] as num).toDouble();
          _currentAutoLng = (data['driverLongitude'] as num).toDouble();
        }
      });
      _calculateDistanceAndEta();
    }
  }

  void _startStatusPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      Map<String, dynamic> response;
      if (_rideId != null) {
        response = await _rideService.getRideDetails(_rideId!);
      } else {
        response = await _rideService.getActiveRide();
      }

      if (!mounted) return;

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final String? status = data['status'];

        if (data['driverLatitude'] != null && data['driverLongitude'] != null) {
          setState(() {
            _currentAutoLat = (data['driverLatitude'] as num).toDouble();
            _currentAutoLng = (data['driverLongitude'] as num).toDouble();
          });
        }

        if (status == 'COMPLETED' || status == 'RIDE_COMPLETED' || status == 'completed') {
          _pollingTimer?.cancel();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ride completed! Please pay the fare shown on the auto meter to the driver.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 4),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RideCompletedScreen(
                rideId: _rideId,
                driverName: _driverName,
                autoNumber: _autoNumber,
                pickupAddress: _pickupAddress,
                dropAddress: _dropAddress,
                pickupLatitude: _pickupLat,
                pickupLongitude: _pickupLng,
                dropLatitude: _dropLat,
                dropLongitude: _dropLng,
              ),
            ),
          );
        } else if (status == 'CANCELLED' || status == 'cancelled') {
          _pollingTimer?.cancel();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ride has been cancelled.'),
              backgroundColor: Colors.black87,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MappingScreen()),
            (route) => false,
          );
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final bool isDesktop = screenWidth >= 900;
    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    final double contentMaxWidth = isDesktop
        ? 500.0
        : isTablet
        ? 480.0
        : screenWidth;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF808080),
        statusBarIconBrightness: Brightness.dark,
      ),

      child: Scaffold(
        backgroundColor: const Color(0xFF3C3A3A),

        body: Stack(
          children: [

         SafeArea(
          child: Column(
            children: [

              // =====================================================
              // HEADER
              // =====================================================

              SizedBox(
                height: isDesktop
                    ? 80
                    : isTablet
                    ? 80
                    : 80,

                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFFFD329),

                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      // ================= MENU =================

                      Positioned(
                        left: isDesktop ? 25.0 : 20.0,

                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isMenuOpen = true;
                            });
                          },

                          padding: EdgeInsets.zero,

                          icon: Icon(
                            Icons.menu,
                            size: isDesktop ? 30 : 28,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // ================= TITLE =================

                      Center(
                        child: Text(
                          'Active Ride',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontFamily: 'Geologica',

                            fontSize: isDesktop
                                ? 24
                                : isTablet
                                ? 22
                                : 20,

                            fontWeight: FontWeight.w500,

                            letterSpacing: -0.02,

                            color: Colors.black,
                          ),
                        ),
                      ),

                      // ================= BELL =================

                      Positioned(
                        right: isDesktop
                            ? 35
                            : isTablet
                            ? 28
                            : screenWidth * 0.055,

                        child: Icon(
                          Icons.notifications_none,

                          size: isDesktop
                              ? 28
                              : isTablet
                              ? 40
                              : 26,

                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =====================================================
              // MAP + DRAGGABLE SHEET
              // =====================================================

              Expanded(
                child: Stack(
                  children: [

                    // =================================================
                    // MAP
                    // =================================================

                    Positioned.fill(
                      child: Center(
                        child: SizedBox(
                          width: contentMaxWidth,
                          height: double.infinity,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _currentAutoLat ?? _pickupLat ?? 18.5204,
                                _currentAutoLng ?? _pickupLng ?? 73.8567,
                              ),
                              zoom: 14.5,
                            ),
                            onMapCreated: (controller) {
                              _googleMapController = controller;
                              _fitRouteBounds();
                            },
                            myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            markers: {
                              if (_pickupLat != null && _pickupLng != null)
                                Marker(
                                  markerId: const MarkerId('pickup'),
                                  position: LatLng(_pickupLat!, _pickupLng!),
                                  icon: _pickupMarkerIcon,
                                  anchor: const Offset(0.5, 1.0),
                                  infoWindow: InfoWindow(title: 'Pickup: ${_pickupAddress ?? ""}'),
                                ),
                              if (_dropLat != null && _dropLng != null)
                                Marker(
                                  markerId: const MarkerId('drop'),
                                  position: LatLng(_dropLat!, _dropLng!),
                                  icon: _destinationMarkerIcon,
                                  anchor: const Offset(0.5, 1.0),
                                  infoWindow: InfoWindow(title: 'Drop: ${_dropAddress ?? ""}'),
                                ),
                              if (_currentAutoLat != null && _currentAutoLng != null)
                                Marker(
                                  markerId: const MarkerId('auto'),
                                  position: LatLng(_currentAutoLat!, _currentAutoLng!),
                                  icon: _autoMarkerIcon,
                                  anchor: const Offset(0.5, 0.5),
                                  infoWindow: InfoWindow(title: 'Auto: ${_driverName ?? "Driver"} (${_autoNumber ?? ""})'),
                                ),
                            },
                            polylines: {
                              if (_routePoints.isNotEmpty)
                                Polyline(
                                  polylineId: const PolylineId('active_route'),
                                  points: _routePoints,
                                  width: 5,
                                  color: const Color(0xFFFFD329),
                                ),
                            },
                          ),
                        ),
                      ),
                    ),

                    // =================================================
                    // DRAGGABLE SHEET
                    // =================================================

                    DraggableScrollableSheet(
                      initialChildSize: 0.20,

                      minChildSize: 0.20,

                      maxChildSize: 0.50,

                      snap: true,

                      snapSizes: const [
                        0.20,
                        0.50,
                      ],

                      builder: (
                          BuildContext context,
                          ScrollController scrollController,
                          ) {
                        return Center(
                          child: SizedBox(
                            width: contentMaxWidth,

                            child: Container(
                              width: double.infinity,

                          decoration: const BoxDecoration(
                            color: Color(0xFFD9D9D9),

                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),

                          child: SingleChildScrollView(
                            controller: scrollController,

                            child: Column(
                              children: [

                                // ==============================
                                // DRAG HANDLE
                                // ==============================

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 12,
                                  ),

                                  child: Container(
                                    width: isDesktop
                                        ? 65
                                        : isTablet
                                        ? 60
                                        : 55,

                                    height: isDesktop
                                        ? 9
                                        : 8,

                                    decoration: BoxDecoration(
                                      color: Colors.white,

                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                  ),
                                ),

                                // =================================================
// PART 2 — CUSTOMER + VEHICLE ROW
// =================================================

                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 15, // 👈 moves the whole row DOWN
                                    left: isDesktop
                                        ? 25
                                        : isTablet
                                        ? 22
                                        : screenWidth * 0.055,
                                    right: isDesktop
                                        ? 25
                                        : isTablet
                                        ? 22
                                        : screenWidth * 0.055,
                                  ),

                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: [

                                      // ============================================
                                      // CUSTOMER PHOTO
                                      // ============================================

                                      SizedBox(
                                        width: isDesktop
                                            ? 75
                                            : isTablet
                                            ? 70
                                            : screenWidth * 0.16,

                                        height: isDesktop
                                            ? 65
                                            : isTablet
                                            ? 60
                                            : screenWidth * 0.14,

                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),

                                          child: Image.asset(
                                            'assets/Avatar.png',

                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      // ============================================
                                      // SPACE
                                      // ============================================

                                      SizedBox(
                                        width: isDesktop
                                            ? 22
                                            : isTablet
                                            ? 18
                                            : screenWidth * 0.08,
                                      ),

                                      // ============================================
                                      // CUSTOMER DETAILS
                                      // ============================================

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          mainAxisSize: MainAxisSize.min,

                                          children: [

                                            Text(
                                              'Name : ${_driverName ?? 'Mahesh Jagtap'}',

                                              maxLines: 1,

                                              overflow: TextOverflow.ellipsis,

                                              style: TextStyle(
                                                fontFamily: 'Inria Serif',

                                                fontSize: isDesktop
                                                    ? 20
                                                    : isTablet
                                                    ? 18
                                                    : screenWidth * 0.043,

                                                fontWeight: FontWeight.w600,

                                                color: Colors.black,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              'Vh no : ${_autoNumber ?? 'MH 12 AA 1234'}',

                                              maxLines: 1,

                                              overflow: TextOverflow.ellipsis,

                                              style: TextStyle(
                                                fontFamily: 'Inria Serif',

                                                fontSize: isDesktop
                                                    ? 20
                                                    : isTablet
                                                    ? 18
                                                    : screenWidth * 0.043,

                                                fontWeight: FontWeight.w600,

                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ============================================
                                      // RICKSHAW IMAGE
                                      // ============================================

                                      SizedBox(
                                        width: isDesktop
                                            ? 65
                                            : isTablet
                                            ? 60
                                            : screenWidth * 0.15,

                                        height: isDesktop
                                            ? 55
                                            : isTablet
                                            ? 50
                                            : screenWidth * 0.13,

                                        child: Image.asset(
                                          'assets/rickshaw.png',

                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // =================================================
// PART 3 — PICKUP + DROP DETAILS
// =================================================

                                SizedBox(
                                  height: isDesktop
                                      ? 175
                                      : isTablet
                                      ? 165
                                      : screenWidth * 0.60,

                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop
                                          ? 25
                                          : isTablet
                                          ? 22
                                          : screenWidth * 0.055,
                                    ),

                                    child: Column(
                                      children: [

                                        // ==========================================
                                        // PICKUP ROW
                                        // ==========================================

                                        Expanded(
                                          flex: 1,
                                          child: Transform.translate(
                                            offset: const Offset(0, 12),
                                            child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [

                                              // LOCATION ICON
                                              Icon(
                                                Icons.location_on,
                                                size: isDesktop
                                                    ? 24
                                                    : isTablet
                                                    ? 22
                                                    : 20,

                                                color: const Color(0xFF1D1B20),
                                              ),

                                              SizedBox(
                                                width: isDesktop
                                                    ? 22
                                                    : isTablet
                                                    ? 18
                                                    : 16,
                                              ),

                                              // PICKUP ADDRESS
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Pickup',
                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',
                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : screenWidth * 0.040,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.red,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 6),

                                                    Text(
                                                      _pickupAddress ?? 'Pickup location',
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: isDesktop
                                                            ? 16
                                                            : isTablet
                                                            ? 15
                                                            : screenWidth * 0.040,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // ====================================
                                              // ETA
                                              // ====================================

                                              SizedBox(
                                                width: isDesktop
                                                    ? 65
                                                    : isTablet
                                                    ? 60
                                                    : screenWidth * 0.16,

                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    Text(
                                                      'ETA',

                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',

                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : 14,

                                                        fontWeight: FontWeight.w400,

                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 4),

                                                    Text(
                                                      _etaText,

                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',

                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : 14,

                                                        fontWeight: FontWeight.w400,

                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),

                                        // ==========================================
                                        // DROP ROW
                                        // ==========================================

                                        Expanded(
                                          flex: 1,
                                          child: Transform.translate(
                                            offset: const Offset(0, -4),
                                            child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [

                                              // LOCATION ICON
                                              Icon(
                                                Icons.location_on,

                                                size: isDesktop
                                                    ? 24
                                                    : isTablet
                                                    ? 22
                                                    : 20,

                                                color: const Color(0xFF1D1B20),
                                              ),

                                              SizedBox(
                                                width: isDesktop
                                                    ? 22
                                                    : isTablet
                                                    ? 18
                                                    : 16,
                                              ),

                                              // DROP ADDRESS
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Drop',
                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',
                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : screenWidth * 0.040,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.green,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 6),

                                                    Text(
                                                      _dropAddress ?? 'Drop location',
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: isDesktop
                                                            ? 16
                                                            : isTablet
                                                            ? 15
                                                            : screenWidth * 0.040,
                                                        fontWeight: FontWeight.w400,
                                                        height: 1.15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // ====================================
                                              // DISTANCE
                                              // ====================================

                                              SizedBox(
                                                width: isDesktop
                                                    ? 65
                                                    : isTablet
                                                    ? 60
                                                    : screenWidth * 0.16,

                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    Text(
                                                      'Distance',

                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',

                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : 14,

                                                        fontWeight: FontWeight.w400,

                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 4),

                                                    Text(
                                                      _distanceText,

                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',

                                                        fontSize: isDesktop
                                                            ? 15
                                                            : isTablet
                                                            ? 14
                                                            : 14,

                                                        fontWeight: FontWeight.w400,

                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                        ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // =====================================================
              // FOOTER
              // =====================================================

              SizedBox(
                height: isDesktop
                    ? 80
                    : isTablet
                    ? 80
                    : 80,

                child: Container(
                  width: double.infinity,

                  color: const Color(0xFF3C3A3A),
                ),
              ),
            ],
          ),
        ),

            // CUSTOMER MENU SLIDER
           // ============================================================

            if (isMenuOpen)
              CustomerMenuScreen(
                onClose: () {
                  setState(() {
                    isMenuOpen = false;
                  });
                },
              ),
        ],
      ),
      ),
    );
  }
}