import 'package:flutter/material.dart';

import 'package:metersay_app/rides/pickupmaplocation.dart';
import 'package:metersay_app/rides/destinationmaplocation.dart';
import 'package:metersay_app/sliders/customermenu.dart';

class LastMileScreen extends StatefulWidget {
  const LastMileScreen({super.key});

  @override
  State<LastMileScreen> createState() => _LastMileScreenState();
}

class _LastMileScreenState extends State<LastMileScreen> {

  // ============================================================
  // COLORS
  // ============================================================

  static const Color yellow = Color(0xFFFFD329);
  static const Color dark = Color(0xFF3C3A3A);
  static const Color green = Color(0xFF269F59);
  static const Color red = Color(0xFFFF2525);

  // ============================================================
  // MENU SLIDER
  // ============================================================

  bool isMenuOpen = false;

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController pickupController =
  TextEditingController();

  final TextEditingController dropController =
  TextEditingController();

  // ============================================================
  // FOCUS NODES
  // ============================================================

  final FocusNode pickupFocusNode = FocusNode();
  final FocusNode dropFocusNode = FocusNode();

  // ============================================================
  // ACTIVE LOCATION
  // true  = Pickup
  // false = Drop
  // null  = Nothing selected
  // ============================================================

  bool? isPickupActive;

  // ============================================================
  // RECENT PICKUP LOCATIONS
  // ============================================================

  final List<String> pickupRecentLocations = [
    'Last Recent pickup location searched',
    'Second Last Recent pickup location searched',
    'Recent pickup location searched',
    'Recent pickup location searched',
    'Recent pickup location searched',
  ];

  // ============================================================
  // RECENT DROP LOCATIONS
  // ============================================================

  final List<String> dropRecentLocations = [
    'Last Recent drop location searched',
    'Second Last Recent drop location searched',
    'Recent drop location searched',
    'Recent drop location searched',
    'Recent drop location searched',
  ];

  // ============================================================
  // DISPOSE CONTROLLERS
  // ============================================================

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();

    pickupFocusNode.dispose();
    dropFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

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
        // RESPONSIVE WIDTH
        // ======================================================

        final double contentMaxWidth =
        isDesktop ? 700 : isTablet ? 850 : screenWidth;

        // ======================================================
        // HEADER AND FOOTER
        // ======================================================

        final double headerHeight = isDesktop ? 90 : 82;

        final double footerHeight = isDesktop ? 58 : 52;

        return Scaffold(
          backgroundColor: Colors.white,

          // Keep header and footer fixed when keyboard opens.
          resizeToAvoidBottomInset: false,

          body: Stack(
            children: [

              // ==================================================
              // MAIN SCREEN
              // ==================================================

              SafeArea(
                bottom: false,

                child: Column(
                  children: [

                    // ==========================================
                    // HEADER
                    // ==========================================

                    SizedBox(
                      width: double.infinity,
                      height: headerHeight,

                      child: Container(
                        color: yellow,

                        child: Stack(
                          alignment: Alignment.center,

                          children: [

                            // MENU ICON

                            Align(
                              alignment: Alignment.centerLeft,

                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: isDesktop
                                      ? 30
                                      : isTablet
                                      ? 25
                                      : 20,
                                ),

                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isMenuOpen = true;
                                    });
                                  },

                                  icon: Icon(
                                    Icons.menu,
                                    size: isDesktop
                                        ? 40
                                        : isTablet
                                        ? 36
                                        : 32,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            // HEADER TITLE

                            Text(
                              'Last Mile',

                              style: TextStyle(
                                fontFamily: 'Geologica',
                                fontSize: isDesktop ? 30 : 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),

                            // NOTIFICATION ICON

                            Align(
                              alignment: Alignment.centerRight,

                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: isDesktop
                                      ? 30
                                      : isTablet
                                      ? 25
                                      : 20,
                                ),

                                child: IconButton(
                                  onPressed: () {
                                    // Notification integration later.
                                  },

                                  icon: Icon(
                                    Icons.notifications_none,
                                    size: isDesktop
                                        ? 40
                                        : isTablet
                                        ? 36
                                        : 32,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==========================================
                    // RESPONSIVE BODY
                    // ==========================================

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, bodyConstraints) {

                          final double bodyHeight =
                              bodyConstraints.maxHeight;

                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: contentMaxWidth,
                              ),

                              child: Column(
                                children: [


                                  // ================================================
                                  // PART 2 - HERO SECTION
                                  // ================================================

                                  Expanded(
                                    flex: isDesktop ? 40 : 34,

                                    child: LayoutBuilder(
                                      builder: (context, heroConstraints) {

                                        final double width = heroConstraints.maxWidth;
                                        final double height = heroConstraints.maxHeight;

                                        final bool smallScreen = width < 400;
                                        final bool largeScreen = width >= 900;

                                        final double headingSize = isDesktop
                                            ? 34
                                            : (width * 0.062).clamp(20.0, 38.0);

                                        final double subtitleSize = isDesktop
                                            ? 22
                                            : (width * 0.048).clamp(16.0, 29.0);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.035,
                                          ),

                                          child: Column(
                                            children: [

                                              // ========================================
                                              // BACK BUTTON
                                              // ========================================

                                              SizedBox(
                                                height: isDesktop
                                                    ? height * 0.22
                                                    : height * 0.27,

                                                child: Align(
                                                  alignment: Alignment.centerLeft,

                                                  child: Material(
                                                    color: const Color(0xFFD9D9D9),
                                                    shape: const CircleBorder(),

                                                    child: InkWell(
                                                      customBorder: const CircleBorder(),

                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },

                                                      child: SizedBox(
                                                        width: (width * 0.09)
                                                            .clamp(38.0, 60.0),

                                                        height: (width * 0.09)
                                                            .clamp(38.0, 60.0),

                                                        child: Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.black,

                                                          size: (width * 0.065)
                                                              .clamp(23.0, 36.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // ========================================
                                              // HERO TEXT AND IMAGE
                                              // ========================================

                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,

                                                  children: [

                                                    // ==================================
                                                    // LEFT SIDE TEXT
                                                    // ==================================

                                                    Expanded(
                                                      flex: 11,

                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,

                                                        mainAxisSize: MainAxisSize.min,

                                                        children: [

                                                          Text(
                                                            'Auto Ride at\nHalf Price',

                                                            maxLines: 2,

                                                            style: TextStyle(
                                                              fontFamily: 'Geologica',

                                                              fontSize: headingSize,

                                                              fontWeight: FontWeight.w600,

                                                              height: 1.4,

                                                              color: const Color(0xFFF07849),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            height: height * 0.025,
                                                          ),

                                                          Text(
                                                            'Pay less, every ride',

                                                            maxLines: 2,

                                                            overflow: TextOverflow.ellipsis,

                                                            style: TextStyle(
                                                              fontFamily: 'Geologica',

                                                              fontSize: subtitleSize,

                                                              fontWeight: FontWeight.w600,

                                                              height: 1.2,

                                                              color: const Color(0xFF333333),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // ==================================
                                                    // RIGHT SIDE IMAGE
                                                    // ==================================

                                                    Expanded(
                                                      flex: 10,

                                                      child: SizedBox(
                                                        height: isDesktop
                                                            ? height * 0.70
                                                            : height * 0.95,

                                                        child: Image.asset(
                                                          'assets/lastmile.jpeg',

                                                          fit: BoxFit.cover,

                                                          errorBuilder: (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                              ) {
                                                            return const Icon(
                                                              Icons.image_not_supported_outlined,
                                                              color: Colors.white,
                                                              size: 45,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),



                                  // ============================================================
                                  // PART 3 - PICKUP AND DROP LOCATION SECTION
                                  // ============================================================

                                  Expanded(
                                    flex: isDesktop ? 27 : 29,

                                    child: LayoutBuilder(
                                      builder: (context, locationConstraints) {

                                        final double width = locationConstraints.maxWidth;
                                        final double height = locationConstraints.maxHeight;

                                        final double horizontalPadding =
                                        (width * 0.05).clamp(12.0, 35.0);

                                        final double fontSize =
                                        (width * 0.037).clamp(15.0, 23.0);

                                        final double iconSize =
                                        (width * 0.055).clamp(23.0, 34.0);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: horizontalPadding,
                                            vertical: height * 0.04,
                                          ),

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [

                                              // ==================================================
                                              // HEADING
                                              // ==================================================

                                              Expanded(
                                                flex: 3,

                                                child: Align(
                                                  alignment: Alignment.centerLeft,

                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment: Alignment.centerLeft,

                                                    child: Text(
                                                      'Search pickup and drop point',

                                                      style: TextStyle(
                                                        fontFamily: 'Geologica',
                                                        fontSize: width < 400 ? 17 : 21,
                                                        fontWeight: FontWeight.w600,
                                                        color: const Color(0xFF333333),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // ==================================================
                                              // PICKUP AND DROP CONTAINER
                                              // ==================================================

                                              Expanded(
                                                flex: 7,

                                                child: Container(
                                                  width: double.infinity,

                                                  decoration: BoxDecoration(
                                                    color: Colors.white,

                                                    border: Border.all(
                                                      color: const Color(0xFFB8B8B8),
                                                      width: 1.5,
                                                    ),

                                                    borderRadius: BorderRadius.circular(30),
                                                  ),

                                                  child: Column(
                                                    children: [

                                                      // ==========================================
                                                      // PICKUP ROW
                                                      // ==========================================

                                                      Expanded(
                                                        child: InkWell(
                                                          borderRadius: const BorderRadius.vertical(
                                                            top: Radius.circular(28),
                                                          ),

                                                          onTap: () {

                                                            setState(() {
                                                              isPickupActive = true;
                                                            });

                                                            // API / MAP NAVIGATION PLACEHOLDER
                                                            // Pickup map navigation will be added
                                                            // in Part 4.
                                                          },

                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: width * 0.025,
                                                            ),

                                                            child: Row(
                                                              children: [

                                                                Icon(
                                                                  Icons.location_on,
                                                                  color: green,
                                                                  size: iconSize,
                                                                ),

                                                                SizedBox(
                                                                  width: width * 0.045,
                                                                ),

                                                                Expanded(
                                                                  child: Text(
                                                                    pickupController.text.isEmpty
                                                                        ? 'Pickup location'
                                                                        : pickupController.text,

                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,

                                                                    style: TextStyle(
                                                                      fontFamily: 'Inria Serif',
                                                                      fontSize: fontSize,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      // ==========================================
                                                      // DASHED DIVIDER
                                                      // ==========================================

                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: width * 0.015,
                                                        ),

                                                        child: LayoutBuilder(
                                                          builder: (context, constraints) {

                                                            final int dashCount =
                                                            (constraints.maxWidth / 12)
                                                                .floor()
                                                                .clamp(1, 100);

                                                            return Row(
                                                              children: List.generate(
                                                                dashCount,

                                                                    (index) => Expanded(
                                                                  child: Container(
                                                                    height: 1.5,
                                                                    margin: const EdgeInsets.symmetric(
                                                                      horizontal: 2,
                                                                    ),
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),

                                                      // ==========================================
                                                      // DROP ROW
                                                      // ==========================================

                                                      Expanded(
                                                        child: InkWell(
                                                          borderRadius: const BorderRadius.vertical(
                                                            bottom: Radius.circular(28),
                                                          ),

                                                          onTap: () {

                                                            setState(() {
                                                              isPickupActive = false;
                                                            });

                                                            // API / MAP NAVIGATION PLACEHOLDER
                                                            // Destination map navigation will be
                                                            // added in Part 4.
                                                          },

                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: width * 0.025,
                                                            ),

                                                            child: Row(
                                                              children: [

                                                                Icon(
                                                                  Icons.location_on,
                                                                  color: red,
                                                                  size: iconSize,
                                                                ),

                                                                SizedBox(
                                                                  width: width * 0.045,
                                                                ),

                                                                Expanded(
                                                                  child: Text(
                                                                    dropController.text.isEmpty
                                                                        ? 'Drop location'
                                                                        : dropController.text,

                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,

                                                                    style: TextStyle(
                                                                      fontFamily: 'Inria Serif',
                                                                      fontSize: fontSize,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
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
                                      },
                                    ),
                                  ),



                                  // ============================================================
                                  // PART 4 - SELECT ON MAP BUTTON
                                  // ============================================================

                                  Expanded(
                                    flex: isDesktop ? 9 : 10,

                                    child: LayoutBuilder(
                                      builder: (context, constraints) {

                                        final double width = constraints.maxWidth;

                                        final double buttonWidth =
                                        (width * 0.23).clamp(125.0, 190.0);

                                        final double buttonHeight =
                                        (constraints.maxHeight * 0.65)
                                            .clamp(38.0, 58.0);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.045,
                                          ),

                                          child: Align(
                                            alignment: Alignment.centerLeft,

                                            child: SizedBox(
                                              width: buttonWidth,
                                              height: buttonHeight,

                                              child: OutlinedButton(
                                                onPressed: () {

                                                  // ==========================================
                                                  // CHECK LOCATION SELECTION
                                                  // ==========================================

                                                  if (isPickupActive == null) {

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Please select Pickup or Drop location first',
                                                        ),
                                                      ),
                                                    );

                                                    return;
                                                  }

                                                  // ==========================================
                                                  // MAP NAVIGATION PLACEHOLDER
                                                  // ==========================================

                                                  if (isPickupActive == true) {

                                                    debugPrint(
                                                      'Opening Pickup Map Screen',
                                                    );

                                                    // PickupMapScreen navigation
                                                    // will be connected here.

                                                  } else {

                                                    debugPrint(
                                                      'Opening Destination Map Screen',
                                                    );

                                                    // DestinationMapScreen navigation
                                                    // will be connected here.
                                                  }
                                                },

                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.black,

                                                  side: const BorderSide(
                                                    color: Color(0xFFB8B8B8),
                                                    width: 1.5,
                                                  ),

                                                  shape: const StadiumBorder(),

                                                  padding: EdgeInsets.zero,
                                                ),

                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,

                                                  child: Text(
                                                    'Select on map',

                                                    style: TextStyle(
                                                      fontFamily: 'Inria Serif',
                                                      fontSize: (width * 0.035)
                                                          .clamp(15.0, 21.0),
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),



// ============================================================
// PART 5 - RECENT SEARCHES HEADING
// ============================================================

                                  Expanded(
                                    flex: isDesktop ? 24 : 27,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        final double width = constraints.maxWidth;
                                        final double horizontalPadding =
                                        (width * 0.045).clamp(15.0, 35.0);

                                        final List<Map<String, String>> recentItems = [];

                                        for (int i = 0; i < pickupRecentLocations.length; i++) {
                                          recentItems.add({
                                            'location': pickupRecentLocations[i],
                                            'type': 'Pickup',
                                          });
                                        }

                                        for (int i = 0; i < dropRecentLocations.length; i++) {
                                          recentItems.add({
                                            'location': dropRecentLocations[i],
                                            'type': 'Drop',
                                          });
                                        }

                                        return Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: horizontalPadding,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              const SizedBox(height: 8),

                                              Expanded(
                                                child: ListView.separated(
                                                  padding: const EdgeInsets.only(bottom: 8),
                                                  physics: const ClampingScrollPhysics(),
                                                  itemCount: recentItems.length,
                                                  separatorBuilder: (context, index) {
                                                    return const Divider(
                                                      height: 1,
                                                      thickness: 0.7,
                                                      color: Color(0xFFEAEAEA),
                                                    );
                                                  },
                                                  itemBuilder: (context, index) {
                                                    final item = recentItems[index];
                                                    final bool isPickup = item['type'] == 'Pickup';

                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isPickup) {
                                                            pickupController.text = item['location']!;
                                                            isPickupActive = true;
                                                          } else {
                                                            dropController.text = item['location']!;
                                                            isPickupActive = false;
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                          horizontal: 4,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.access_time,
                                                              size: 20,
                                                              color: Colors.grey.shade600,
                                                            ),

                                                            const SizedBox(width: 12),

                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    item['location']!,
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Geologica',
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: Color(0xFF333333),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 3),

                                                                  Text(
                                                                    item['type']!,
                                                                    style: TextStyle(
                                                                      fontSize: 11,
                                                                      color: isPickup
                                                                          ? green
                                                                          : red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            const Icon(
                                                              Icons.arrow_forward_ios,
                                                              size: 13,
                                                              color: Colors.black45,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),



                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ==========================================
                    // FIXED FOOTER
                    // ==========================================

                    Container(
                      width: double.infinity,
                      height: footerHeight,
                      color: dark,
                    ),
                  ],
                ),
              ),

              // ==================================================
              // CUSTOMER MENU SLIDER
              // ==================================================

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
      },
    );
  }
}