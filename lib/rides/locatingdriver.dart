import 'package:flutter/material.dart';
import 'package:metersay_app/rides/rideraccepted.dart';
import 'package:metersay_app/sliders/rejectslider.dart';

class LocatingDriverScreen extends StatefulWidget {
  const LocatingDriverScreen({super.key});

  @override
  State<LocatingDriverScreen> createState() =>
      _LocatingDriverScreenState();
}

class _LocatingDriverScreenState
    extends State<LocatingDriverScreen> {



  // ============================================================
  // API PLACEHOLDERS
  // Later these values will come from backend/API
  // ============================================================

  String pickupAddress = 'Shivaji Nagar';

  String dropAddress = 'Hinjewadi Phase 1';

  bool isDriverFound = false;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // ============================================================
// RESPONSIVE CONTENT WIDTH
// ============================================================

    final bool isDesktop = screenWidth >= 900;

    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

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
            // MAP
            // ==================================================

            // ==================================================
// CENTERED MAP
// ==================================================

            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: contentMaxWidth,

                  child: _buildMap(
                    contentMaxWidth,
                    screenHeight,
                  ),
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
              child: _buildHeader(
                screenWidth,
              ),
            ),

            // ==================================================
            // BOTTOM SHEET
            // ==================================================

            // ==================================================
// CENTERED DRIVER SHEET
// ==================================================

            Positioned(
              left: 0,
              right: 0,

              bottom: (screenHeight * 0.094)
                  .clamp(80.0, 100.0),

              child: Center(
                child: SizedBox(
                  width: contentMaxWidth,

                  child: _buildDriverSheet(
                    contentMaxWidth,
                    screenHeight,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildFooter(
                screenWidth,
                screenHeight,

              ),
            ),
          ],
        ),
      ),
    );
  }
    // ============================================================
    // RESPONSIVE MAP
    // ============================================================

    Widget _buildMap(
        double screenWidth,
        double screenHeight,
        ) {
      return ClipRect(
        child: Image.asset(
          'assets/maps.png',

          width: screenWidth,
          height: screenHeight,

          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      );
    }

    // ============================================================
    // RESPONSIVE HEADER
    // ============================================================

    Widget _buildHeader(
        double screenWidth,
        ) {
      final bool isDesktop = screenWidth >= 700;

      final double headerHeight =
      isDesktop ? 80 : 80;

      final double iconSize = isDesktop
          ? 38
          : (screenWidth * 0.095).clamp(32.0, 38.0);

      final double titleSize = isDesktop ? 28 : 20;

      return Container(
        width: double.infinity,
        height: headerHeight,

        color: const Color(0xFFFFD329),

        child: Stack(
          alignment: Alignment.center,

          children: [

            // ====================================================
            // MENU
            // ====================================================

            Align(
              alignment: Alignment.centerLeft,

              child: Padding(
                padding: EdgeInsets.only(
                  left: isDesktop
                      ? 25 : 20,
                ),

                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  padding: EdgeInsets.zero,

                  icon: Icon(
                    Icons.menu,
                    color: const Color(0xFF1D1B20),
                    size: isDesktop
                        ? 30 : 28,
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
                      ? 25 : 20,
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
                        ? 28 : 26,
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

  Widget _buildDriverSheet(
      double screenWidth,
      double screenHeight,
      ) {
    final bool isDesktop = screenWidth >= 700;

    // Smaller fixed proportion so the sheet fits above footer.
    final double sheetHeight = screenHeight * 0.302;

    final double horizontalPadding = isDesktop
        ? screenWidth * 0.025
        : screenWidth * 0.020;

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
          topLeft: Radius.circular(
            isDesktop ? 30 : 24,
          ),
          topRight: Radius.circular(
            isDesktop ? 30 : 24,
          ),
        ),
      ),

      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

          // ==========================================================
          // HANDLE
          // ==========================================================

          Container(
            width: isDesktop ? 100 : screenWidth * 0.13,
            height: isDesktop ? 6 : 5,

            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          SizedBox(
            height: screenHeight * 0.008,
          ),

          // ==========================================================
          // TITLE
          // ==========================================================

          Text(
            'Locating your driver',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: 'Geologica',

              fontSize: isDesktop
                  ? 20
                  : (screenWidth * 0.040).clamp(15.0, 19.0),

              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          SizedBox(
            height: screenHeight * 0.005,
          ),

          // ==========================================================
          // SUBTITLE
          // ==========================================================

          Text(
            'We will update you as soon as we can',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontFamily: 'Inria Serif',

              fontSize: isDesktop
                  ? 19
                  : (screenWidth * 0.044).clamp(16.0, 19.0),

              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),

          SizedBox(
            height: screenHeight * 0.015,
          ),

          // ==========================================================
          // PROGRESS BAR
          // ==========================================================

          _buildProgressBar(
            screenWidth,
            isDesktop,
          ),

          SizedBox(
            height: screenHeight * 0.020,
          ),

          // ==========================================================
          // PICKUP + DROP
          // ==========================================================

          _buildLocationCard(
            screenWidth,
            screenHeight,
            isDesktop,
          ),

          SizedBox(
            height: screenHeight * 0.015,
          ),

          // ==========================================================
          // CANCEL BUTTON
          // ==========================================================

          _buildCancelButton(
            screenWidth,
            isDesktop,
          ),
        ],
      ),
    ),
      );
    }
    // ============================================================
    // RESPONSIVE PROGRESS BAR
    // ============================================================



  Widget _buildProgressBar(
      double screenWidth,
      bool isDesktop,
      ) {
    final double barHeight = isDesktop ? 8 : 6;

    return SizedBox(
      width: double.infinity,
      height: barHeight,

      child: Row(
        children: [

          // Completed — 50%
          Expanded(
            flex: 1,
            child: Container(
              height: barHeight,
              color: const Color(0xFFF4D35E),
            ),
          ),

          // Remaining — 50%
          Expanded(
            flex: 1,
            child: Container(
              height: barHeight,
              color: const Color(0xFFD9D9D9),
            ),
          ),
        ],
      ),
    );
  }

    // ============================================================
    // PICKUP + DROP LOCATION CARD
    // ============================================================

  // ============================================================
// SMALL RESPONSIVE PICKUP + DROP CARD
// ============================================================

  Widget _buildLocationCard(
      double screenWidth,
      double screenHeight,
      bool isDesktop,
      ) {
    final double iconSize = isDesktop
        ? 30
        : (screenWidth * 0.070).clamp(25.0, 30.0);

    final double textSize = isDesktop
        ? 17
        : (screenWidth * 0.043).clamp(15.0, 17.0);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ======================================================
          // PICKUP
          // ======================================================

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

                SizedBox(
                  width: screenWidth * 0.025,
                ),

                Expanded(
                  child: Text(
                    pickupAddress,

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

          // ======================================================
          // DIVIDER
          // ======================================================

          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFB5B5B5),
          ),

          // ======================================================
          // DROP
          // ======================================================

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

                SizedBox(
                  width: screenWidth * 0.025,
                ),

                Expanded(
                  child: Text(
                    dropAddress,

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
    // RESPONSIVE CANCEL RIDE BUTTON
    // ============================================================

  // ============================================================
// SMALL RESPONSIVE CANCEL RIDE BUTTON
// ============================================================

  Widget _buildCancelButton(
      double screenWidth,
      bool isDesktop,
      ) {
    final double buttonWidth = isDesktop
        ? 220
        : (screenWidth * 0.55).clamp(190.0, 220.0);

    final double buttonHeight = isDesktop ? 38 : 36;

    final double textSize = isDesktop
        ? 17
        : (screenWidth * 0.043).clamp(15.0, 17.0);

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,

      child: ElevatedButton(
        onPressed: () {
          // TODO:
          // Add cancel-ride confirmation/API later.
          CancelRideSheet.show(context);

          debugPrint('Cancel Ride pressed');
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: Text(
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

  Widget _buildFooter(
      double screenWidth,
      double screenHeight,

      ) {
    final double footerHeight = 80.0;

    return Container(
      width: double.infinity,
      height: footerHeight,
      color: const Color(0xFF3C3A3A),
    );
  }
  }