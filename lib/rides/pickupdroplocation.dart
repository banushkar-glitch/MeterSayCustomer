import 'package:flutter/material.dart';
import 'package:metersay_app/rides/pickupmaplocation.dart';
import 'package:metersay_app/rides/destinationmaplocation.dart';
import 'package:metersay_app/sliders/customermenu.dart';

class PickupDropLocation extends StatefulWidget {
  const PickupDropLocation({Key? key}) : super(key: key);

  @override
  State<PickupDropLocation> createState() => _PickupDropLocationState();
}

class _PickupDropLocationState extends State<PickupDropLocation> {
  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  bool isMenuOpen = false;


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
  // ============================================================

  bool? isPickupActive;

  // ============================================================
  // RECENT LOCATIONS
  // ============================================================

  final List<String> pickupRecentLocations = [
    "Last Recent pickup location searched",
    "Second Last Recent pickup location searched",
    "Recent pickup location searched",
    "Recent pickup location searched",
    "Recent pickup location searched",
  ];

  final List<String> dropRecentLocations = [
    "Last Recent drop location searched",
    "Second Last Recent drop location searched",
    "Recent drop location searched",
    "Recent drop location searched",
    "Recent drop location searched",
  ];

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();

    pickupFocusNode.dispose();
    dropFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;

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

        final double horizontalPadding =
        isDesktop
            ? 40
            : isTablet
            ? 32
            : 20;

        final double headerHeight =
        isDesktop ? 80 : 80;

        final double footerHeight =
        isDesktop ? 80 : 80;

        final double contentMaxWidth =
        isDesktop
            ? 500
            : isTablet
            ? 480
            : screenWidth;

        final double titleSize =
        isDesktop ? 28 : 20;

        return Scaffold(
          backgroundColor: Colors.white,

          // Keeps header/footer in their positions
          // when the keyboard opens.
          resizeToAvoidBottomInset: false,

          body: Stack(
            children: [

           SafeArea(
            child: Column(
              children: [

                // ==================================================
                // HEADER
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
                                setState(() {
                                  isMenuOpen = true;
                                });
                              },

                              padding: EdgeInsets.zero,

                              icon: Icon(
                                Icons.menu,
                                color: const Color(0xFF1D1B20),
                                size: isDesktop
                                    ? 34
                                    : isTablet
                                    ? 37
                                    : 34,
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
                              fontWeight: FontWeight.w400,
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
                                    ? 30
                                    : isTablet
                                    ? 34
                                    : 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // ==================================================
                // BODY
                // ==================================================

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isDesktop ? 25 : 18,
                    ),

                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentMaxWidth,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [

                            // ==================================================
                            // PICKUP TITLE + BACK BUTTON
                            // ==================================================

                            SizedBox(
                              height: isDesktop ? 90 : 70,

                              child: Stack(
                                alignment: Alignment.center,

                                children: [

                                  // Back button
                                  Align(
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
                                          width: isDesktop ? 46 : 46,
                                          height: isDesktop ? 46 : 46,

                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: isDesktop ? 34 : 34,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Pickup title
                                  Center(
                                    child: Text(
                                      isPickupActive == null
                                          ? ""
                                          : isPickupActive == true
                                          ? "Pickup"
                                          : "Drop",

                                      style: TextStyle(
                                        fontFamily: "InriaSerif",
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.2,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: isDesktop ? 25 : 15,
                            ),

                            // ==================================================
// SMALLER PICKUP + DROP LOCATION BOX
// ==================================================

                            Container(
                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFFB3B3B3),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Column(
                                children: [

                                  // ==================================================
                                  // PICKUP FIELD
                                  // ==================================================

                                  SizedBox(
                                    height: isDesktop ? 55 : 55,

                                    child: InkWell(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),

                                      onTap: () {
                                        setState(() {
                                          isPickupActive = true;
                                        });

                                        pickupFocusNode.requestFocus();
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),

                                        child: Row(
                                          children: [

                                            Icon(
                                              Icons.location_on,
                                              color: Colors.green,
                                              size: isDesktop ? 27 : 27,
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: TextField(
                                                controller: pickupController,
                                                focusNode: pickupFocusNode,

                                                onTap: () {
                                                  setState(() {
                                                    isPickupActive = true;
                                                  });
                                                },

                                                onChanged: (value) {
                                                  setState(() {
                                                    isPickupActive = true;
                                                  });
                                                },

                                                decoration: const InputDecoration(
                                                  hintText: "Pickup location",
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                ),

                                                style: TextStyle(
                                                  fontFamily: "InriaSerif",
                                                  fontSize: isDesktop ? 16 : 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ==================================================
                                  // DASHED DIVIDER
                                  // ==================================================

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),

                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Row(
                                          children: List.generate(
                                            (constraints.maxWidth / 14).floor(),
                                                (index) {
                                              return Expanded(
                                                child: Container(
                                                  height: 1,

                                                  margin: const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                  ),

                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // ==================================================
                                  // DROP FIELD
                                  // ==================================================

                                  SizedBox(
                                    height: isDesktop ? 55 : 55,

                                    child: InkWell(
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(20),
                                      ),

                                      onTap: () {
                                        setState(() {
                                          isPickupActive = false;
                                        });

                                        dropFocusNode.requestFocus();
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),

                                        child: Row(
                                          children: [

                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.red,
                                              size: isDesktop ? 27 : 27,
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: TextField(
                                                controller: dropController,
                                                focusNode: dropFocusNode,

                                                onTap: () {
                                                  setState(() {
                                                    isPickupActive = false;
                                                  });
                                                },

                                                onChanged: (value) {
                                                  setState(() {
                                                    isPickupActive = false;
                                                  });
                                                },

                                                decoration: const InputDecoration(
                                                  hintText: "Drop location",
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                ),

                                                style: TextStyle(
                                                  fontFamily: "InriaSerif",
                                                  fontSize: isDesktop ? 16 : 16,
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

                            // ==================================================
                            // SELECT ON MAP
                            // ==================================================

                            Align(
                              alignment: Alignment.centerLeft,

                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 22,
                                  left: 15,
                                ),

                                child: OutlinedButton(
                                  onPressed: () {
                                    if (isPickupActive == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PickupMapScreen(),
                                        ),
                                      ).then((result) {
                                        if (result == true) {
                                          setState(() {
                                            isPickupActive = false;
                                          });

                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (mounted) {
                                              dropFocusNode.requestFocus();
                                            }
                                          });
                                        }
                                      });
                                    } else if (isPickupActive == false) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const DestinationMapScreen(),
                                          ),
                                       );
                                    } else {
                                      // Nothing selected → do nothing
                                      }
                                      },

                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(
                                      color: Color(0xFFB3B3B3),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: isDesktop ? 12 : 7,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),

                                  child: Text(
                                    "Select on map",
                                    style: TextStyle(
                                      fontFamily: "InriaSerif",
                                      fontSize: isDesktop ? 14 : 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // ==================================================
                            // SPACE BEFORE RECENT LOCATIONS
                            // ==================================================

                            SizedBox(
                              height: isDesktop ? 14 : 6,
                            ),


                            // ==================================================
                            // RECENT LOCATION LIST
                            // ==================================================

                            ...(
                                isPickupActive == true
                                    ? pickupRecentLocations
                                    : isPickupActive == false
                                    ? dropRecentLocations
                                    : <String>[]
                            ).map(
                                  (location) {

                                return _recentLocationTile(
                                  location: location,
                                  isDesktop: isDesktop,
                                );
                              },
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


                // ==================================================
                // FOOTER
                // ==================================================

                // ==================================================

                Container(
                  width: double.infinity,

                  height: footerHeight,

                  decoration: const BoxDecoration(
                    color: Color(0xFF3C3A3A),
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
      },
    );
  }

  // ============================================================
// RECENT LOCATION TILE
// ============================================================

  Widget _recentLocationTile({
    required String location,
    required bool isDesktop,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 2,
      ),

      child: Column(
        children: [

          SizedBox(
            height: isDesktop ? 48 : 48,

            child: Row(
              children: [

                // ==================================================
                // CLOCK ICON
                // ==================================================

                Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 12,
                  ),

                  child: Icon(
                    Icons.access_time,
                    color: const Color(0xFFB3B3B3),
                    size: isDesktop ? 22 : 22,
                  ),
                ),

                // ==================================================
                // LOCATION TEXT
                // ==================================================

                Expanded(
                  child: Text(
                    location,

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

                const SizedBox(width: 8),
              ],
            ),
          ),

          // ======================================================
          // DASHED DIVIDER
          // ======================================================

          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),

            child: LayoutBuilder(
              builder: (context, constraints) {

                return Row(
                  children: List.generate(
                    (constraints.maxWidth / 12).floor(),

                        (index) {
                      return Expanded(
                        child: Container(
                          height: 1,

                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),

                          color: const Color(0xFFB3B3B3),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}