import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metersay_app/rides/ridecompleted.dart';
import 'package:metersay_app/sliders/customermenu.dart';
class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {

  bool isMenuOpen = false;



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
                          child: Image.asset(
                            'assets/maps.png',
                            width: contentMaxWidth,
                            height: double.infinity,
                            fit: BoxFit.cover,
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
                                              'Name : Mahesh Jagtap',

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
                                              'Vh no : MH 12 AA 1234',

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
                                                      '283/5 Shaniwar Peth '
                                                          '(Bhegade Ali) Talegaon Dabhade '
                                                          'Maval Pune 410506',
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
                                                      '6.45 PM',

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
                                                      'Plot 5 Ravivar Peth '
                                                          '(Mali Ali) Swargate Parvati '
                                                          'Pune 411506',
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
                                                      '5 km',

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