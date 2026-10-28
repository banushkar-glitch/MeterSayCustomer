import 'package:flutter/material.dart';

class CustomerMenuScreen extends StatelessWidget {
  final VoidCallback? onClose;

  const CustomerMenuScreen({
    super.key,
    this.onClose,
  });


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


    final double screenHeight = size.height;

    final double screenWidth = size.width;


    final bool isDesktop = screenWidth >= 900;
    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    // =====================================================
    // RESPONSIVE DRAWER WIDTH
    // =====================================================


    final double drawerWidth = isDesktop
        ? 360
        : isTablet
        ? screenWidth * 0.60
        : screenWidth * 0.68;

    return Scaffold(
      backgroundColor: Colors.transparent,


      body: Stack(
        children: [



          // =================================================
          // DARK OVERLAY
          // =================================================

          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                onClose?.call();
              },
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ),
          // =================================================
          // LEFT SLIDER
          // =================================================


            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              bottom: 0,

              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  // Right to left swipe
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity! < -300) {
                    onClose?.call();
                  }
                },

              child: SizedBox(
                width: drawerWidth,

                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F3FA),

                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        isDesktop
                            ? 24
                            : isTablet
                            ? 20
                            : 18,
                      ),

                      bottomRight: Radius.circular(
                        isDesktop
                            ? 24
                            : isTablet
                            ? 20
                            : 18,
                      ),
                    ),
                  ),

                  child: Column(
                    children: [

                      // =================================================
// PROFILE HEADER - SMALL RESPONSIVE
// =================================================

                      Container(
                        width: double.infinity,

                        padding: EdgeInsets.only(
                          top: isDesktop
                              ? 36
                              : isTablet
                              ? 33
                              : 30,

                          left: isDesktop
                              ? 28
                              : isTablet
                              ? 24
                              : 21,

                          right: isDesktop
                              ? 18
                              : isTablet
                              ? 15
                              : 13,

                          bottom: isDesktop
                              ? 18
                              : isTablet
                              ? 13
                              : 15,
                        ),

                        decoration: const BoxDecoration(
                          color: Color(0xFFE8CC58),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            // =========================================
                            // PROFILE ICON
                            // =========================================

                            Container(
                              width: isDesktop
                                  ? 90
                                  : isTablet
                                  ? 80
                                  : 70,

                              height: isDesktop
                                  ? 90
                                  : isTablet
                                  ? 80
                                  : 70,

                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE9DDF9),
                              ),

                              child: Icon(
                                Icons.person,

                                color: const Color(0xFF51348D),

                                size: isDesktop
                                    ? 45
                                    : isTablet
                                    ? 40
                                    : 35,
                              ),
                            ),

                            SizedBox(
                              height: isDesktop
                                  ? 20
                                  : isTablet
                                  ? 14
                                  : 18,
                            ),

                            // =========================================
                            // DRIVER NAME
                            // =========================================

                            Text(
                              'Customer Name',

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 24
                                    : isTablet
                                    ? 21
                                    : 21,

                                fontWeight: FontWeight.w400,

                                color: Colors.white,
                              ),
                            ),

                            SizedBox(
                              height: isDesktop
                                  ? 10
                                  : isTablet
                                  ? 7
                                  : 8,
                            ),

                            // =========================================
                            // EMAIL
                            // =========================================

                            Text(
                              'customer@email.com',

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 24
                                    : isTablet
                                    ? 21
                                    : 21,

                                fontWeight: FontWeight.w400,

                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =================================================
// MENU ITEMS
// =================================================

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              // =========================================
                              // MY PROFILE
                              // =========================================

                              _buildMenuItem(
                                icon: Icons.person,
                                title: 'My Profile',
                                isDesktop: isDesktop,
                                isTablet: isTablet,
                                onTap: () {
                                  // My Profile action
                                },
                              ),

                              // =========================================
                              // MY TRIPS
                              // =========================================

                              _buildMenuItem(
                                icon: Icons.history,
                                title: 'My Trips',
                                isDesktop: isDesktop,
                                isTablet: isTablet,
                                onTap: () {
                                  // My Trips action
                                },
                              ),

                              // =========================================
                              // DRIVER DASHBOARD
                              // =========================================

                              _buildMenuItem(
                                icon: Icons.dashboard,
                                title: 'Customer Dashboard',
                                isDesktop: isDesktop,
                                isTablet: isTablet,
                                onTap: () {
                                  // Driver Dashboard action
                                },
                              ),

                              // =========================================
                              // SETTINGS
                              // =========================================

                              _buildMenuItem(
                                icon: Icons.settings,
                                title: 'Settings',
                                isDesktop: isDesktop,
                                isTablet: isTablet,
                                onTap: () {
                                  // Settings action
                                },
                              ),

                              _buildMenuItem(
                                icon: Icons.logout,
                                title: 'Logout',
                                isDesktop: isDesktop,
                                isTablet: isTablet,
                                onTap: () {
                                  // Logout action
                                },
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
    ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDesktop,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 22
              : isTablet
              ? 18
              : 15,

          vertical: isDesktop
              ? 19
              : isTablet
              ? 13
              : 15,
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: isDesktop
                  ? 27
                  : isTablet
                  ? 25
                  : 23,

              color: Colors.black87,
            ),

            SizedBox(
              width: isDesktop
                  ? 20
                  : isTablet
                  ? 17
                  : 15,
            ),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: isDesktop
                      ? 21
                      : isTablet
                      ? 19
                      : 19,

                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}