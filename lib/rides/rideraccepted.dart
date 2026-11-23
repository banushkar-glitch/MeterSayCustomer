import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metersay_app/rides/activeride.dart';
import 'package:metersay_app/rides/mapscreen.dart';
import 'package:metersay_app/sliders/customermenu.dart';
import 'package:metersay_app/sliders/rejectslider.dart';
import 'package:metersay_app/services/location_service.dart';
import 'package:metersay_app/services/ride_service.dart';

class RiderAccepted extends StatefulWidget {
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
  final String? otp;

  const RiderAccepted({
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
    this.otp,
  });

  static const Color yellow = Color(0xFFFFD329);
  static const Color dark = Color(0xFF3C3A3A);

  @override
  State<RiderAccepted> createState() => _RiderAcceptedState();
}

class _RiderAcceptedState extends State<RiderAccepted> {

  bool isMenuOpen = false;
  GoogleMapController? _googleMapController;
  final RideService _rideService = RideService();
  BitmapDescriptor _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor _autoMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  List<LatLng> _routePoints = [];

  Timer? _pollingTimer;
  String? _currentOtp;
  bool _isDriverArrived = false;
  String _arrivalBannerText = 'Driver is on the way to pickup';
  double? _driverLat;
  double? _driverLng;

  @override
  void initState() {
    super.initState();
    _driverLat = widget.driverLatitude;
    _driverLng = widget.driverLongitude;
    // OTP will only be populated dynamically when driver arrives
    _currentOtp = widget.otp;
    _loadMarkerIcons();
    _fetchRoute();
    _startArrivalPolling();
  }

  Future<void> _loadMarkerIcons() async {
    final pickup = await LocationService.getPickupMarkerIcon();
    final auto = await LocationService.getAutoMarkerIcon();
    if (!mounted) return;
    setState(() {
      _pickupMarkerIcon = pickup;
      _autoMarkerIcon = auto;
    });
  }

  Future<void> _fetchRoute() async {
    final curDriverLat = _driverLat ?? widget.driverLatitude;
    final curDriverLng = _driverLng ?? widget.driverLongitude;
    if (curDriverLat != null && curDriverLng != null &&
        widget.pickupLatitude != null && widget.pickupLongitude != null) {
      final start = LatLng(curDriverLat, curDriverLng);
      final end = LatLng(widget.pickupLatitude!, widget.pickupLongitude!);
      final details = await LocationService.getShortestRoute(start, end);
      if (!mounted) return;
      setState(() {
        _routePoints = details.polylinePoints;
      });
      _fitRouteBounds();
    }
  }

  void _fitRouteBounds() {
    final curDriverLat = _driverLat ?? widget.driverLatitude;
    final curDriverLng = _driverLng ?? widget.driverLongitude;
    if (curDriverLat != null && curDriverLng != null &&
        widget.pickupLatitude != null && widget.pickupLongitude != null &&
        _googleMapController != null) {
      final double minLat = min(curDriverLat, widget.pickupLatitude!);
      final double maxLat = max(curDriverLat, widget.pickupLatitude!);
      final double minLng = min(curDriverLng, widget.pickupLongitude!);
      final double maxLng = max(curDriverLng, widget.pickupLongitude!);

      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          70,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startArrivalPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      Map<String, dynamic> response;
      if (widget.rideId != null) {
        response = await _rideService.getRideDetails(widget.rideId!);
      } else {
        response = await _rideService.getActiveRide();
      }

      if (!mounted) return;

      if (response['success'] == true) {
        final data = response['data'] ?? {};
        final String? status = data['status'];

        // Live driver coordinates update
        if (data['driverLatitude'] != null && data['driverLongitude'] != null) {
          final double newLat = (data['driverLatitude'] as num).toDouble();
          final double newLng = (data['driverLongitude'] as num).toDouble();
          if (_driverLat != newLat || _driverLng != newLng) {
            setState(() {
              _driverLat = newLat;
              _driverLng = newLng;
            });
          }
        }

        if (status == 'DRIVER_ARRIVED' || status == 'ARRIVED') {
          if (!_isDriverArrived) {
            setState(() {
              _isDriverArrived = true;
              _arrivalBannerText = 'Driver has arrived at pickup!';
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Auto driver has arrived at pickup! Share OTP with driver.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
          }

          // Dynamically obtain and display OTP upon arrival
          if (data['otp'] != null && data['otp'].toString().isNotEmpty && _currentOtp != data['otp'].toString()) {
            setState(() {
              _currentOtp = data['otp'].toString();
            });
          }
        } else if (status == 'DRIVER_ACCEPTED' || status == 'ACCEPTED' || status == 'DRIVER_ASSIGNED' || status == 'DRIVER_ARRIVING') {
          if (_arrivalBannerText != 'Driver is on the way to pickup') {
            setState(() {
              _arrivalBannerText = 'Driver is on the way to pickup';
            });
          }
        } else if (status == 'RIDE_STARTED' || status == 'IN_PROGRESS' || status == 'STARTED') {
          _pollingTimer?.cancel();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ride started! Fare will be calculated on driver\'s meter.'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ActiveRideScreen(
                rideId: widget.rideId,
                driverName: widget.driverName,
                driverPhoneNumber: widget.driverPhoneNumber,
                autoNumber: widget.autoNumber,
                autoModel: widget.autoModel,
                driverLatitude: _driverLat ?? widget.driverLatitude,
                driverLongitude: _driverLng ?? widget.driverLongitude,
                pickupAddress: widget.pickupAddress,
                pickupLatitude: widget.pickupLatitude,
                pickupLongitude: widget.pickupLongitude,
                dropAddress: widget.dropAddress,
                dropLatitude: widget.dropLatitude,
                dropLongitude: widget.dropLongitude,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;

            final bool isDesktop = screenWidth >= 900;

            final bool isTablet =
                screenWidth >= 600 && screenWidth < 900;

            final double contentMaxWidth = isDesktop
                ? 500.0
                : isTablet
                ? 480.0
                : screenWidth;

            final double headerHeight =
            isDesktop ? 80.0 : 80.0;

            final double footerHeight =
            isDesktop ? 80.0 : 80.0;

            return Stack(
              children: [

                // ============================================================
                // MAP
                // ============================================================
                // ============================================================
// CENTERED MAP
// ============================================================

                Positioned(
                  top: headerHeight,
                  left: 0,
                  right: 0,
                  bottom: footerHeight,

                  child: Center(
                    child: SizedBox(
                      width: contentMaxWidth,
                      height: double.infinity,

                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: (_driverLat != null && _driverLng != null)
                              ? LatLng(_driverLat!, _driverLng!)
                              : (widget.pickupLatitude != null && widget.pickupLongitude != null
                                  ? LatLng(widget.pickupLatitude!, widget.pickupLongitude!)
                                  : LocationService.defaultLocation),
                          zoom: 15.0,
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
                          if (widget.pickupLatitude != null && widget.pickupLongitude != null)
                            Marker(
                              markerId: const MarkerId('pickup'),
                              position: LatLng(widget.pickupLatitude!, widget.pickupLongitude!),
                              icon: _pickupMarkerIcon,
                              anchor: const Offset(0.5, 1.0),
                              infoWindow: InfoWindow(title: 'Pickup: ${widget.pickupAddress ?? "Your Pickup"}'),
                            ),
                          if (_driverLat != null && _driverLng != null)
                            Marker(
                              markerId: const MarkerId('driver'),
                              position: LatLng(_driverLat!, _driverLng!),
                              icon: _autoMarkerIcon,
                              anchor: const Offset(0.5, 0.5),
                              infoWindow: InfoWindow(
                                title: 'Auto: ${widget.driverName ?? "Driver"} (${widget.autoNumber ?? ""})',
                              ),
                            ),
                        },
                        polylines: {
                          if (_routePoints.isNotEmpty)
                            Polyline(
                              polylineId: const PolylineId('driver_to_pickup'),
                              points: _routePoints,
                              width: 5,
                              color: const Color(0xFFFFD329),
                            ),
                        },
                      ),
                    ),
                  ),
                ),

                // ============================================================
                // HEADER
                // ============================================================
                // ============================================================
// HEADER
// ============================================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerHeight,

                  child: Container(
                    color: RiderAccepted.yellow,

                    child: Stack(
                      alignment: Alignment.center,

                      children: [

                        // ==================================================
                        // MENU
                        // ==================================================

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

                        // ==================================================
                        // TITLE
                        // ==================================================

                        Text(
                          'Ride Details',

                          style: TextStyle(
                            fontSize: isDesktop ? 28.0 : 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),

                        // ==================================================
                        // NOTIFICATION
                        // ==================================================

                        Positioned(
                          right: isDesktop ? 25.0 : 20.0,

                          child: Icon(
                            Icons.notifications_none,
                            size: isDesktop ? 28 : 26,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ============================================================
                // RIDE DETAILS SHEET
                // ============================================================
                // ============================================================
// CENTERED RIDE DETAILS SHEET
// ============================================================

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: footerHeight,

                  child: Center(
                    child: SizedBox(
                      width: contentMaxWidth,

                      child: _RideDetailsSheet(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        driverName: widget.driverName,
                        autoNumber: widget.autoNumber,
                        autoModel: widget.autoModel,
                        driverPhoneNumber: widget.driverPhoneNumber,
                        otp: _currentOtp,
                        arrivalMessage: _arrivalBannerText,
                        isDriverArrived: _isDriverArrived,
                      ),
                    ),
                  ),
                ),

                // ============================================================
                // FOOTER
                // ============================================================
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: footerHeight,
                  child: Container(
                    color: RiderAccepted.dark,
                    child: _CancelWarning(
                      screenWidth: screenWidth,
                      rideId: widget.rideId,
                    ),
                  ),
                ),

                // ============================================================
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
            );
          },
        ),
      ),
    );
  }
}

class _RideDetailsSheet extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String? driverName;
  final String? autoNumber;
  final String? autoModel;
  final String? driverPhoneNumber;
  final String? otp;
  final String arrivalMessage;
  final bool isDriverArrived;

  const _RideDetailsSheet({
    required this.screenWidth,
    required this.screenHeight,
    this.driverName,
    this.autoNumber,
    this.autoModel,
    this.driverPhoneNumber,
    this.otp,
    required this.arrivalMessage,
    required this.isDriverArrived,
  });

  @override
  Widget build(BuildContext context) {
    // Keep the content compact on large screens.
    final double contentWidth =
    screenWidth > 700 ? 500.0 : screenWidth * 0.94;

    final double titleSize =
    screenWidth >= 700
        ? 16
        : (screenWidth * 0.047).clamp(15.0, 20.0);

    final String otpStr = (otp != null && otp!.trim().isNotEmpty) ? otp!.trim() : '----';
    final List<String> digits = otpStr.split('');

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),

      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 700
            ? 20
            : screenWidth * 0.025,
        vertical: screenHeight * 0.014,
      ),

      child: Center(
        child: SizedBox(
          width: contentWidth,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ============================================================
              // DRIVER ARRIVAL
              // ============================================================

              Text(
                arrivalMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Serif',
                  fontSize: titleSize,
                  fontWeight: isDriverArrived ? FontWeight.w600 : FontWeight.w400,
                  color: isDriverArrived ? const Color(0xFF16B957) : Colors.black,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.012,
              ),

              // ============================================================
              // OTP
              // ============================================================

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 700 ? 560 : double.infinity,
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 700 ? 14 : 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD329),
                      borderRadius: BorderRadius.circular(28),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // ==================================================
                        // OTP TEXT
                        // ==================================================

                        Text(
                          'OTP :',
                          style: TextStyle(
                            fontFamily: 'Inria Serif',
                            fontSize: screenWidth > 700
                                ? 18
                                : (screenWidth * 0.052).clamp(18.0, 22.0),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),

                        const Spacer(),

                        // Dynamic 6-digit OTP boxes
                        for (int i = 0; i < digits.length; i++) ...[
                          if (i > 0)
                            SizedBox(
                              width: screenWidth > 700 ? 8 : 5,
                            ),
                          _OtpBox(
                            value: digits[i],
                            size: screenWidth,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.014,
              ),

              // ============================================================
              // DRIVER CARD
              // ============================================================

              _DriverCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                driverName: driverName ?? 'Mahesh Jagtap',
                autoNumber: autoNumber ?? 'MH 12 AA 1234',
                autoModel: autoModel ?? 'Auto Rickshaw',
                driverPhoneNumber: driverPhoneNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final String value;
  final double size;

  const _OtpBox({
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double boxSize = size > 700
        ? 38
        : (size * 0.052).clamp(28.0, 36.0);

    final double digitSize = size > 700
        ? 18
        : (size * 0.038).clamp(15.0, 18.0);

    return SizedBox(
      width: boxSize,
      height: boxSize,

      child: Container(
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),

          border: Border.all(
            color: const Color(0xFFD0D0D0),
            width: 1,
          ),
        ),

        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'Inria Serif',
            fontSize: digitSize,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String driverName;
  final String autoNumber;
  final String autoModel;
  final String? driverPhoneNumber;

  const _DriverCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.driverName,
    required this.autoNumber,
    required this.autoModel,
    this.driverPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = screenWidth > 700;

    return Container(
      width: double.infinity,

      // Smaller grey container
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 16 : screenWidth * 0.035,
        vertical: isDesktop ? 10 : screenHeight * 0.008,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ⭐ Rating
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: isDesktop ? 15 : 16,
                  color: Colors.black,
                ),
                const SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontFamily: 'Inria Serif',
                    fontSize: isDesktop ? 15 : 16,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.004),

          // Driver information
          Row(
            children: [

              // Driver photo
              SizedBox(
                width: isDesktop ? 55 : 48,
                height: isDesktop ? 55 : 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/driver.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.035),

              // Driver details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isDesktop ? 33.0 : 28.0,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name : $driverName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inria Serif',
                          fontSize: isDesktop ? 20 : 18,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Vh no : $autoNumber',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inria Serif',
                          fontSize: isDesktop ? 18 : 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rickshaw

            ],
          ),

          SizedBox(height: screenHeight * 0.010),

          // Message + Call
          Row(
            children: [

              Expanded(
                child: _ActionButton(
                  text: 'Message',
                  icon: Icons.chat_bubble_outline,
                  screenWidth: screenWidth,
                ),
              ),

              SizedBox(width: screenWidth * 0.04),

              Expanded(
                child: _ActionButton(
                  text: 'Call',
                  icon: Icons.phone,
                  screenWidth: screenWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double screenWidth;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (screenWidth * 0.105).clamp(42.0, 55.0),

      child: ElevatedButton.icon(
        onPressed: () {
          // ==========================================================
          // TODO:
          // Message → open chat screen later
          // Call → initiate driver call later
          // ==========================================================
        },

        icon: Icon(
          icon,
          size: (screenWidth * 0.055).clamp(20.0, 27.0),
          color: Colors.black,
        ),

        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inria Serif',
            fontSize: screenWidth >= 900 ? 14.0 : 18.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          foregroundColor: Colors.black,
          elevation: 0,

          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
// ================================================================
// FIXED CANCELLATION FOOTER
// ================================================================

class _CancelWarning extends StatelessWidget {
  final double screenWidth;
  final int? rideId;

  const _CancelWarning({
    required this.screenWidth,
    this.rideId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = screenWidth >= 900;
    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 900
              : isTablet
              ? 700
              : double.infinity,
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 25
                : isTablet
                ? 20
                : 17,
          ),

          child: Container(
            width: double.infinity,

            height: isDesktop
                ? 62
                : isTablet
                ? 60
                : 59,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [

                // ==================================================
                // WARNING ICON
                // ==================================================

                Padding(
                  padding: EdgeInsets.only(
                    left: isDesktop ? 10 : 6,
                  ),

                  child: Image.asset(
                    'assets/images (2).png',

                    width: isDesktop ? 30 : 27,
                    height: isDesktop ? 28 : 25,

                    fit: BoxFit.contain,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: isDesktop ? 30 : 27,
                      );
                    },
                  ),
                ),

                // ==================================================
                // WARNING MESSAGE
                // ==================================================

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                    ),

                    child: Text(
                      'Canceling rides more than 2 times '
                          'in a single day may temporarily block '
                          'your account for 24 hours. Please accept '
                          'rides responsibly to maintain smooth '
                          'service for customers.',

                      maxLines: 4,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isDesktop ? 10 : 9,
                        fontWeight: FontWeight.w200,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // CANCEL RIDE
                // ==================================================

                Padding(
                  padding: EdgeInsets.only(
                    right: isDesktop ? 10 : 7,
                  ),

                  child: TextButton(
                    onPressed: () {
                      CancelRideSheet.show(
                        context,
                        rideId: rideId,
                      );
                    },

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 9 : 5,
                      ),

                      minimumSize: Size.zero,

                      tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    ),

                    child: Text(
                      'Cancel Ride',

                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isDesktop ? 13 : 11,
                        fontWeight: FontWeight.w500,
                        decoration:
                        TextDecoration.underline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}