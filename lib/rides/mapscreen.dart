import 'package:flutter/material.dart';
import 'package:metersay_app/sliders/customermenu.dart';
import 'package:metersay_app/rides/pickupdroplocation.dart';

class MappingScreen extends StatefulWidget {
  const MappingScreen({super.key});

  @override
  State<MappingScreen> createState() => _MappingScreenState();
}

class _MappingScreenState extends State<MappingScreen> {

  bool isDrawerOpen = false;
  // ==========================================================
  // CONTROLLER
  // ==========================================================

  final TextEditingController destinationController =
  TextEditingController();

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // ========================================================
    // RESPONSIVE BREAKPOINTS
    // ========================================================

    final bool isDesktop = screenWidth >= 900;

    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    // ========================================================
    // COMMON CONTENT WIDTH
    //
    // Desktop/Web  -> maximum 500 px
    // Tablet       -> maximum 480 px
    // Mobile       -> almost full width
    // ========================================================

    final double contentWidth = isDesktop
        ? 500
        : isTablet
        ? 480
        : screenWidth;

    // ========================================================
    // FOOTER HEIGHT
    //
    // Keep footer proportional.
    // ========================================================

    final double footerHeight = 80.0;


    final double sheetHeight = isDesktop
        ? 170
        : isTablet
        ? 190
        : 215;

    final double pickupHeight = isDesktop
        ? 58
        : isTablet
        ? 55
        : 52;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          // ==================================================
          // MAP
          // ==================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: footerHeight,

            child: Center(
              child: SizedBox(
                width: contentWidth,
                height: double.infinity,

                child: ClipRect(
                  child: Image.asset(
                    'assets/maps.png',

                    width: contentWidth,
                    height: double.infinity,

                    fit: BoxFit.cover,

                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),

          // ==================================================
          // HEADER
          // =================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(
              color: const Color(0xFFE0E0E0),
            ),
          ),


          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,

            child: _buildHeader(
              screenWidth,
              screenHeight,
              isDesktop,
              isTablet,
            ),
          ),

          // ==================================================
          // LIVE PICKUP ADDRESS
          // ==================================================

          Positioned(
            left: 0,
            right: 0,

            // Position above white sheet
            bottom: footerHeight + (isDesktop ? 170 : isTablet ? 190 : 215) + 10,

            child: Center(
              child: SizedBox(
                width: isDesktop
                    ? 500
                    : isTablet
                    ? 480
                    : screenWidth - 68,

                child: _buildPickupAddress(
                  screenWidth,
                  isDesktop,
                  isTablet,
                ),
              ),
            ),
          ),

          // ==================================================
          // WHITE DESTINATION SHEET
          // ==================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: footerHeight,

            child: Center(
              child: SizedBox(
                width: contentWidth,

                child: _buildDestinationSheet(
                  screenWidth,
                  screenHeight,
                  isDesktop,
                  isTablet,
                ),
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

            child: _buildFooter(
              screenWidth,
              screenHeight,

            ),
          ),

          // ==================================================
// CUSTOMER SLIDER
// ==================================================

          if (isDrawerOpen)
            CustomerMenuScreen(
              onClose: () {
                if (!mounted) return;

                setState(() {
                  isDrawerOpen = false;
                });
              },
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
      double screenWidth,
      double screenHeight,
      bool isDesktop,
      bool isTablet,
      ) {
    return Container(
      width: double.infinity,

      height: isDesktop
          ? 80
          : isTablet
          ? 80
          :  80,

      color: const Color(0xFFFFD329),

        child: Stack(
          alignment: Alignment.center,

          children: [

            // =================================================
            // DASHBOARD TITLE
            // =================================================

            Text(
              'Dashboard',

              style: TextStyle(
                fontFamily: 'Geologica',

                fontSize: isDesktop
                    ? 28
                    : isTablet
                    ? 20
                    : 20,

                fontWeight: FontWeight.w500,

                color: Colors.black,
              ),
            ),

            // MENU
            Positioned(
              left: isDesktop
                  ? 30
                  : isTablet
                  ? 25
                  : 28,

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isDrawerOpen = true;
                  });
                },

                child: Icon(
                  Icons.menu,
                  size: isDesktop
                      ? 28
                      : isTablet
                      ? 32
                      : 26,

                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ),
// NOTIFICATION
            Positioned(
              right: isDesktop
                  ? 30
                  : isTablet
                  ? 25
                  : 30,

              child: Icon(
                Icons.notifications_none,
                size: isDesktop
                    ? 28
                    : isTablet
                    ? 32
                    : 26,

                color: const Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),

    );
  }

  // ==========================================================
  // LIVE PICKUP ADDRESS
  // ==========================================================

  Widget _buildPickupAddress(
      double screenWidth,
      bool isDesktop,
      bool isTablet,
      ) {
    return Container(
      height: isDesktop ? 40 : isTablet ? 37 : 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        color: const Color(0xFF808080),
        borderRadius: BorderRadius.circular(22),
      ),

      alignment: Alignment.center,

      child: Text(
        'pickup location address with help of live location or dragging on map',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,

        style: TextStyle(
          fontFamily: 'InriaSerif',
          fontSize: isDesktop ? 14 : isTablet ? 13 : 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  // ==========================================================
  // DESTINATION SHEET
  // ==========================================================

  Widget _buildDestinationSheet(
      double screenWidth,
      double screenHeight,
      bool isDesktop,
      bool isTablet,

      ) {
    return Container(
      width: double.infinity,

      height: isDesktop
          ? 170
          : isTablet
          ? 190
          : 215,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),



      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 24
              : isTablet
              ? 18
              : 14,
          vertical: isDesktop
              ? 10
              : isTablet
              ? 8
              : 7,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ==================================================
            // DRAG HANDLE
            // ==================================================

            Container(
              width: isDesktop ? 90 : 75,
              height: isDesktop ? 5 : 4,

              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            SizedBox(
              height: isDesktop
                  ? 12
                  : isTablet
                  ? 9
                  : 17,
            ),

            // ==================================================
            // SELECT YOUR DESTINATION
            // ==================================================

            Text(
              'Select your Destination.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: 'InriaSerif',

                fontSize: isDesktop
                    ? 21
                    : isTablet
                    ? 19
                    : 17,

                fontWeight: FontWeight.w400,

                letterSpacing: 0.04,

                color: Colors.black,
              ),
            ),

            SizedBox(
              height: isDesktop
                  ? 12
                  : isTablet
                  ? 9
                  : 27,
            ),

            // ==================================================
            // DESTINATION SEARCH BAR
            // ==================================================

            Container(
              width: double.infinity,

              height: isDesktop
                  ? 46
                  : isTablet
                  ? 43
                  : 40,

              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(22),
              ),

              child: Row(
                children: [

                  // SEARCH ICON
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 13,
                    ),

                    child: Icon(
                      Icons.search,

                      size: isDesktop
                          ? 25
                          : isTablet
                          ? 23
                          : 21,

                      color: Colors.black,
                    ),
                  ),

                  // DESTINATION CONTAINER
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickupDropLocation(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Where would you like to go?',
                          style: TextStyle(
                            fontFamily: 'InriaSerif',
                            fontSize: isDesktop
                                ? 17
                                : isTablet
                                ? 16
                                : 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ==================================================
            // SAVED LOCATIONS
            // ==================================================

            SizedBox(
              height: isDesktop
                  ? 16
                  : isTablet
                  ? 13
                  : 40,
            ),

            Row(
              children: [

                // ==================================================
                // HOME
                // ==================================================

                Expanded(
                  child: _buildSavedLocation(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                  ),
                ),

                // ==================================================
                // OFFICE
                // ==================================================

                Expanded(
                  child: _buildSavedLocation(
                    icon: Icons.business_outlined,
                    label: 'Office',
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                  ),
                ),

                // ==================================================
                // OTHER
                // ==================================================

                Expanded(
                  child: _buildSavedLocation(
                    icon: Icons.location_on_outlined,
                    label: 'Other',
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  // ==========================================================
  // SAVED LOCATION ITEM
  // ==========================================================

  Widget _buildSavedLocation({
    required IconData icon,
    required String label,
    required bool isDesktop,
    required bool isTablet,
  }) {
    return InkWell(
      onTap: () {
        // API / saved-location logic later
        debugPrint('$label selected');
      },

      borderRadius: BorderRadius.circular(12),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,

            size: isDesktop
                ? 30
                : isTablet
                ? 28
                : 26,

            color: Colors.black,
          ),

          const SizedBox(height: 3),

          Text(
            label,

            style: TextStyle(
              fontFamily: 'InriaSerif',

              fontSize: isDesktop
                  ? 15
                  : isTablet
                  ? 14
                  : 13,

              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FOOTER
  // ==========================================================

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