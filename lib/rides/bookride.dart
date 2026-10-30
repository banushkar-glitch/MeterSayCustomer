import 'package:flutter/material.dart';
import 'package:metersay_app/rides/locatingdriver.dart';
import 'package:metersay_app/sliders/customermenu.dart';
import 'package:metersay_app/sliders/rejectslider.dart';
class BookRideScreen extends StatefulWidget {
  const BookRideScreen({super.key});

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {

  bool isMenuOpen = false;

  // ============================================================
  // API-READY DATA
  // ============================================================

  String pickupAddress = "Current location";
  String destinationAddress = "Drop off Location";

  double? pickupLatitude;
  double? pickupLongitude;

  double? destinationLatitude;
  double? destinationLongitude;

  // ============================================================
  // RESPONSIVE HELPERS
  // ============================================================

  double _width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double _height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  bool _isDesktop(BuildContext context) {
    return _width(context) >= 900;
  }

  bool _isTablet(BuildContext context) {
    return _width(context) >= 600 &&
        _width(context) < 900;
  }

  // ============================================================
  // MAIN SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double screenWidth = _width(context);
    final double screenHeight = _height(context);

    final bool isDesktop = _isDesktop(context);
    final bool isTablet = _isTablet(context);

    // ==========================================================
// RESPONSIVE VALUES
// ==========================================================

    final double titleSize =
    isDesktop ? 28 : 20;

    final double headerHeight =
    isDesktop ? 80 : 80;

    final double footerHeight =
    isDesktop ? 80 : 80;

    final double horizontalPadding = isDesktop
        ? 32
        : isTablet
        ? 28
        : 18;

    final double contentMaxWidth = isDesktop
        ? 500
        : isTablet
        ? 480
        : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,

      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [


          SafeArea(
        top: true,
        bottom: false,

        child: Column(
          children: [

            // ==================================================
            // FIXED HEADER
            // ==================================================

            SizedBox(
              height: headerHeight,

              child: Container(
                width: double.infinity,
                color: const Color(0xFFFFD329),

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    // ==========================================
                    // MENU BUTTON
                    // ==========================================

                    Align(
                      alignment: Alignment.centerLeft,

                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isDesktop
                              ? 25
                              : isTablet
                              ? 22
                              : 20,
                        ),

                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isMenuOpen = true;
                            });
                          },

                          padding: EdgeInsets.zero,

                          icon: Icon(
                            Icons.menu,
                            color: const Color(0xFF1D1B20),
                            size: isDesktop
                                ? 30
                                : isTablet
                                ? 37
                                : 28,
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // DASHBOARD TITLE
                    // ==================================================

                    Center(
                      child: Text(
                        "Dashboard",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontFamily: "Geologica",
                          fontSize: titleSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // ==================================================
                    // NOTIFICATION ICON
                    // ==================================================

                    Align(
                      alignment: Alignment.centerRight,

                      child: Padding(
                        padding: EdgeInsets.only(
                          right: isDesktop
                              ? 25
                              : isTablet
                              ? 22
                              : 20,
                        ),

                        child: IconButton(
                          onPressed: () {
                            // TODO:
                            // Connect notification screen/API later.
                          },

                          padding: EdgeInsets.zero,

                          icon: Icon(
                            Icons.notifications_none,
                            color: const Color(0xFF1D1B20),
                            size: isDesktop
                                ? 28
                                : isTablet
                                ? 34
                                : 26,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // MAIN AREA
            // ==================================================

            Expanded(
              child: Center(
                child: SizedBox(
                  width: contentMaxWidth,

                  child: Stack(
                    children: [

                  // ==================================================
                  // PART 2 → MAP WILL COME HERE
                  // RESPONSIVE MAP AREA
                  // ==================================================

                  Positioned.fill(
                    child: ClipRect(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,

                        child: Image.asset(
                          "assets/maps.png",

                          width: double.infinity,
                          height: double.infinity,

                          fit: BoxFit.cover,

                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // PART 3 → DRAGGABLE SHEET WILL COME HERE
                  // ==================================================
                  // DRAGGABLE BOTTOM SHEET
                  // ==================================================

                  DraggableScrollableSheet(
                    initialChildSize: 0.38,
                    minChildSize: 0.38,
                    maxChildSize: 0.38,

                    snap: true,

                    builder: (
                        BuildContext context,
                        ScrollController scrollController,
                        ) {
                      return Container(
                        width: double.infinity,

                        decoration: const BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),

                        child: SingleChildScrollView(
                          controller: scrollController,

                          physics: const ClampingScrollPhysics(),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              // ==================================================
                              // DRAG HANDLE
                              // ==================================================

                              Container(
                                width: 55,
                                height: 8,

                                margin: const EdgeInsets.only(
                                  top: 3,
                                  bottom: 12,
                                ),

                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),

                              // ==================================================
                              // PART 4 → INPUTS WILL COME HERE
                              // ==================================================

                              // ==================================================
                              // LOCATION FIELDS
                              // ==================================================

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop
                                      ? 28
                                      : isTablet
                                      ? 22
                                      : 14,
                                ),

                                child: Column(
                                  children: [

                                    // ==================================================
                                    // CURRENT LOCATION
                                    // ==================================================

                                    Container(
                                      width: double.infinity,
                                      height: isDesktop
                                          ? 54
                                          : isTablet
                                          ? 50
                                          : 48,

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.location_on,
                                              color: const Color(0xFF34A853),
                                              size: isDesktop ? 29 : 26,
                                            ),
                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),

                                              child: Text(
                                                pickupAddress,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                  fontFamily: "InriaSerif",
                                                  fontSize: isDesktop
                                                      ? 19
                                                      : isTablet
                                                      ? 18
                                                      : 16,

                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ==================================================
                                    // SMALL GAP
                                    // ==================================================

                                    SizedBox(
                                      height: isDesktop
                                          ? 24
                                          : isTablet
                                          ? 20
                                          : 17,
                                    ),

                                    // ==================================================
                                    // DROP OFF LOCATION
                                    // ==================================================

                                    Container(
                                      width: double.infinity,
                                      height: isDesktop
                                          ? 54
                                          : isTablet
                                          ? 50
                                          : 48,

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 12),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: isDesktop ? 29 : 26,
                                            ),
                                          ),

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),

                                              child: Text(
                                                destinationAddress,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                  fontFamily: "InriaSerif",
                                                  fontSize: isDesktop
                                                      ? 19
                                                      : isTablet
                                                      ? 18
                                                      : 16,

                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ==================================================
                                    // SMALL GAP BEFORE BOOK RIDE
                                    // ==================================================

                                    SizedBox(
                                      height: isDesktop
                                          ? 30
                                          : isTablet
                                          ? 24
                                          : 30,
                                    ),

                                    // ==================================================
                                    // BOOK RIDE
                                    // ==================================================

                                    SizedBox(
                                      width: isDesktop
                                          ? 290
                                          : isTablet
                                          ? 270
                                          : 245,

                                      height: isDesktop
                                          ? 46
                                          : isTablet
                                          ? 43
                                          : 40,

                                      child: ElevatedButton(
                                        onPressed: () {

                                          // API / NAVIGATION LATER

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LocatingDriverScreen(),
                                            ),
                                          );

                                          debugPrint(
                                            "Book Ride pressed",
                                          );

                                          debugPrint(
                                            "Pickup: $pickupAddress",
                                          );

                                          debugPrint(
                                            "Destination: $destinationAddress",
                                          );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFD329),
                                          foregroundColor: Colors.black,
                                          elevation: 3,
                                          padding: EdgeInsets.zero,

                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(22),
                                          ),
                                        ),

                                        child: Text(
                                          "Book Ride",

                                          style: TextStyle(
                                            fontFamily: "InriaSerif",
                                            fontSize: isDesktop
                                                ? 21
                                                : isTablet
                                                ? 19
                                                : 17,

                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.3,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ==================================================
                                    // VERY SMALL BOTTOM SPACE
                                    // ==================================================

                                    SizedBox(
                                      height: isDesktop
                                          ? 10
                                          : isTablet
                                          ? 6
                                          : 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),


                ],
              ),
            ),
          ),
    ),

            // ==================================================
// FIXED DARK FOOTER
// ==================================================

            SizedBox(
              width: double.infinity,
              height: footerHeight,

              child: Container(
                color: const Color(0xFF3C3A3A),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: contentMaxWidth,
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? 28
                            : isTablet
                            ? 22
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
                                left: isDesktop
                                    ? 12
                                    : 6,
                              ),

                              child: Image.asset(
                                "assets/images (2).png",

                                width: isDesktop
                                    ? 30
                                    : 27,

                                height: isDesktop
                                    ? 28
                                    : 25,

                                fit: BoxFit.contain,

                                errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return Icon(
                                    Icons.warning_amber_rounded,

                                    color: Colors.red,

                                    size: isDesktop
                                        ? 30
                                        : 27,
                                  );
                                },
                              ),
                            ),

                            // ==================================================
                            // WARNING TEXT
                            // ==================================================

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),

                                child: Text(
                                  "Canceling rides more than 2 times "
                                      "in a single day may temporarily block "
                                      "your account for 24 hours. Please accept "
                                      "rides responsibly to maintain smooth "
                                      "service for customers.",

                                  maxLines: isDesktop ? 3 : 4,

                                  overflow: TextOverflow.ellipsis,

                                  style: TextStyle(
                                    fontFamily: "Inter",

                                    fontSize: isDesktop
                                        ? 10
                                        : 9,

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
                                right: isDesktop
                                    ? 12
                                    : 8,
                              ),

                              child: TextButton(
                                onPressed: () {
                                  // TODO:
                                  // Add cancel-ride logic/API later.
                                  CancelRideSheet.show(context);
                                },

                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isDesktop
                                        ? 10
                                        : 5,
                                  ),

                                  minimumSize: Size.zero,

                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),

                                child: Text(
                                  "Cancel Ride",

                                  style: TextStyle(
                                    fontFamily: "Roboto",

                                    fontSize: isDesktop
                                        ? 13
                                        : 11,

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
                ),
              ),
            ),
          ],
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
    ),
    );
  }
}