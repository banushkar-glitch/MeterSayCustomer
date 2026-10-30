import 'package:flutter/material.dart';
import 'package:metersay_app/rides/pickupdroplocation.dart';

class PickupMapScreen extends StatefulWidget {
  const PickupMapScreen({Key? key}) : super(key: key);

  @override
  State<PickupMapScreen> createState() => _PickupMapScreenState();
}

class _PickupMapScreenState extends State<PickupMapScreen> {

  // ============================================================
  // API / MAP DATA - TO BE CONNECTED LATER
  // ============================================================

  String pickupAddress = "";

  // TODO:
  // Replace the above value with the address received
  // from the map/reverse-geocoding API later.

  // ============================================================
  // FUTURE MAP DATA
  // ============================================================

  double? pickupLatitude;
  double? pickupLongitude;

  // TODO:
  // These values will come from the map/location API later.

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;



        // ======================================================
        // RESPONSIVE BREAKPOINTS
        // ======================================================

        final bool isMobile = screenWidth < 600;

        final bool isTablet =
            screenWidth >= 600 && screenWidth < 1024;

        final bool isDesktop = screenWidth >= 1024;

        // ======================================================
        // RESPONSIVE SIZES
        // ======================================================

        final double headerHeight =
        isDesktop ? 80 : 80;

        final double footerHeight =
        isDesktop ? 80 : 80;

        final double horizontalPadding =
        isDesktop
            ? 40
            : isTablet
            ? 30
            : 20;

        final double panelHeight =
        isDesktop
            ? 240
            : isTablet
            ? 225
            : 195;

        final double backButtonSize =
        isDesktop ? 52 : 40;

        final double titleSize =
        isDesktop ? 28 : 20;

        final double contentMaxWidth =
        isDesktop
            ? 500
            : isTablet
            ? 480
            : screenWidth;

        return Scaffold(

          backgroundColor: Colors.white,

          // IMPORTANT:
          // Keyboard should not move the map/header/footer.
          resizeToAvoidBottomInset: false,

          body: SafeArea(
            child: Column(
              children: [

                // ==================================================
                // HEADER
                // ==================================================

                // ==================================================
// FIXED DASHBOARD HEADER
// ==================================================

                SizedBox(
                  width: double.infinity,
                  height: headerHeight,

                  child: Container(
                    color: const Color(0xFFFFD329),

                    child: Stack(
                      alignment: Alignment.center,

                      children: [

                        // ==================================================
                        // Menu Icon
                        // ==================================================

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
                                Navigator.pop(context);
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
                // MAP + PICKUP PANEL
                // ==================================================

                Expanded(
                  child: Stack(
                    children: [

                      // ==================================================
// RESPONSIVE MAP AREA
// ==================================================

                      Positioned.fill(
                        child: Center(
                          child: SizedBox(
                            width: contentMaxWidth,
                            child: Container(
                              color: const Color(0xFFF2F2F2),

                              child: Image.asset(
                                "assets/maps.png",
                                width: contentMaxWidth,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFE8E8E8),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

// ==================================================
// FLOATING BACK BUTTON
// ==================================================



                      // ==================================================
                      // BOTTOM PICKUP PANEL
                      // ==================================================

                      // ==================================================
// BOTTOM PICKUP PANEL
// ==================================================

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,

                        child: Container(
                          width: double.infinity,

                          constraints: BoxConstraints(
                            minHeight: panelHeight,
                          ),

                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            isDesktop ? 12 : 8,
                            horizontalPadding,
                            isDesktop ? 18 : 12,
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

                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: contentMaxWidth,
                              ),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                children: [

                                  // ==================================================
                                  // SET YOUR PICKUP
                                  // ==================================================

                                  Text(
                                    "Set your Pickup.",

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontFamily: "InriaSerif",
                                      fontSize: isDesktop ? 20 : 20,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: Colors.black,
                                    ),
                                  ),

                                  // ==================================================
                                  // DRAG MAP TEXT
                                  // ==================================================

                                  const SizedBox(height: 2),

                                  Text(
                                    "Drag map to set pin.",

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontFamily: "InriaSerif",
                                      fontSize: isDesktop ? 18 : 18,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.0,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(
                                    height: isDesktop ? 16 : 15,
                                  ),

                                  // ==================================================
                                  // PICKUP ADDRESS FIELD
                                  // ==================================================

                                  Container(
                                    width: double.infinity,

                                    height: isDesktop ? 48 : 48,

                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        118,
                                        118,
                                        128,
                                        0.12,
                                      ),

                                      borderRadius: BorderRadius.circular(18),
                                    ),

                                    child: Stack(
                                      alignment: Alignment.center,

                                      children: [

                                        // LOCATION ICON
                                        Align(
                                          alignment: Alignment.centerLeft,

                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 18,
                                            ),

                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.green,
                                              size: isDesktop ? 28 : 28,
                                            ),
                                          ),
                                        ),

                                        // PICKUP ADDRESS - EXACT CENTER
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 55,
                                          ),

                                          child: Text(
                                            pickupAddress.isEmpty
                                                ? "Pickup address"
                                                : pickupAddress,

                                            textAlign: TextAlign.center,

                                            maxLines: 1,

                                            overflow: TextOverflow.ellipsis,

                                            style: TextStyle(
                                              fontFamily: "InriaSerif",
                                              fontSize: isDesktop ? 16 : 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  const SizedBox(height: 18),

                                  // ==================================================
                                  // CONFIRM PICKUP BUTTON
                                  // ==================================================

                                  SizedBox(
                                    height: isDesktop ? 48 : 48,

                                    width: isDesktop
                                        ? 243
                                        : isTablet
                                        ? 243
                                        : 243,

                                    child: ElevatedButton(
                                      onPressed: () {

                                        // ==================================================
                                        // TODO: API / MAP INTEGRATION
                                        // ==================================================
                                        //
                                        // Later:
                                        //
                                        // 1. Get selected latitude
                                        // 2. Get selected longitude
                                        // 3. Get pickup address
                                        // 4. Send data to backend/API
                                        //
                                        // pickupLatitude
                                        // pickupLongitude
                                        // pickupAddress
                                        //
                                        // ==================================================

                                        debugPrint(
                                          "Pickup confirmed: "
                                              "$pickupAddress | "
                                              "$pickupLatitude | "
                                              "$pickupLongitude",
                                        );

                                        Navigator.pop(context, true);
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFF3C3A3A),

                                        foregroundColor: Colors.white,

                                        elevation: 0,

                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),

                                      child: Text(
                                        "Confirm Pickup.",

                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontFamily: "InriaSerif",
                                          fontSize: isDesktop ? 18 : 18,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.2,
                                          color: Colors.green,
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

                    ],
                  ),
                ),


                // ==================================================
                // FOOTER
                // ==================================================

                // ==================================================

                Container(
                  width: double.infinity,
                  height: footerHeight,

                  color: const Color(0xFF3C3A3A),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}