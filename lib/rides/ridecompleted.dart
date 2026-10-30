import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metersay_app/rides/mapscreen.dart';
import 'package:metersay_app/rides/ridereview.dart';

class RideCompletedScreen extends StatefulWidget {
  const RideCompletedScreen({super.key});

  @override
  State<RideCompletedScreen> createState() =>
      _RideCompletedScreenState();
}

class _RideCompletedScreenState
    extends State<RideCompletedScreen> {

  // =========================================================
  // REVIEW STATE
  // =========================================================

  int selectedRating = 0;

  bool showReviewBox = false;

  final TextEditingController reviewController =
  TextEditingController();

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final double screenHeight =
        MediaQuery.of(context).size.height;

    final bool isDesktop =
        screenWidth >= 900;

    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    // =========================================================
    // RESPONSIVE CONTENT WIDTH
    // =========================================================

    final double contentWidth = isDesktop
        ? 500
        : isTablet
        ? 480
        : screenWidth;

    // =========================================================
    // RESPONSIVE HEADER HEIGHT
    // =========================================================

    final double headerHeight = isDesktop
        ? 80
        : isTablet
        ? 80
        : 80;

    // =========================================================
    // RESPONSIVE FOOTER HEIGHT
    // =========================================================

    final double footerHeight = isDesktop
        ? 80
        : isTablet
        ? 80
        : 80;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF808080),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,

        body: Center(
          child: SizedBox(
            width: contentWidth,
            height: screenHeight,

            child: Column(
              children: [
                // SPACE ABOVE HEADER
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                // =================================================
                // HEADER
                // =================================================

                SizedBox(
                  height: headerHeight,

                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFFD329),

                    child: Stack(
                      children: [

                        // =================================================
                        // MENU
                        // =================================================

                        Positioned(
                          left: screenWidth * 0.055,
                          top: headerHeight * 0.30,

                          child: Icon(
                            Icons.menu,

                            size: isDesktop
                                ? 30
                                : isTablet
                                ? 32
                                : 28,

                            color: const Color(0xFF1E1E1E),
                          ),
                        ),

                        // =================================================
                        // TITLE
                        // =================================================

                        Positioned.fill(
                          child: Center(
                            child: Text(
                              'Ride Completed',

                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontFamily: 'Geologica',

                                fontSize: isDesktop
                                    ? 21
                                    : isTablet
                                    ? 20
                                    : 20,

                                fontWeight:
                                FontWeight.w500,

                                height: 1.4,

                                letterSpacing: -0.02,

                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // =================================================
                        // NOTIFICATION
                        // =================================================

                        Positioned(
                          right: screenWidth * 0.055,
                          top: headerHeight * 0.29,

                          child: Icon(
                            Icons.notifications_none,

                            size: isDesktop
                                ? 28
                                : isTablet
                                ? 38
                                : 26,

                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // BODY
                // ONLY THIS AREA WILL SCROLL
                // =================================================

                Expanded(
                  child: SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? 25
                            : isTablet
                            ? 22
                            : screenWidth * 0.043,
                      ),

                      child: Column(
                        children: [

                          // =================================================
// PART 2 — SUCCESS SECTION
// =================================================

// SKIP
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                right: screenWidth * 0.02,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Skip review
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RideReviewScreen(),
                                    ),
                                        (route) => false,
                                  );

                                },
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontFamily: 'Geologica',
                                    fontSize: isDesktop
                                        ? 16
                                        : isTablet
                                        ? 15
                                        : screenWidth * 0.041,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF3C3A3A),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),

// =================================================
// SUCCESS ICON
// =================================================

                          SizedBox(
                            height: isDesktop
                                ? 120
                                : isTablet
                                ? 115
                                : screenWidth * 0.34,

                            width: isDesktop
                                ? 120
                                : isTablet
                                ? 115
                                : screenWidth * 0.34,

                            child: Image.asset(
                              'assets/check.png',
                              fit: BoxFit.contain,
                            ),
                          ),

// =================================================
// RIDE COMPLETED TEXT
// =================================================



                          Text(
                            'Ride Completed!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isDesktop
                                  ? 24
                                  : isTablet
                                  ? 19
                                  : screenWidth * 0.043,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),

// =================================================
// EXPERIENCE TEXT
// =================================================

                          const SizedBox(height: 7),

                          Text(
                            'How was your experience?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isDesktop
                                  ? 20
                                  : isTablet
                                  ? 20
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),
                          // =================================================
// PART 3 — RIDE MAP
// =================================================

                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isDesktop
                                  ? 30
                                  : isTablet
                                  ? 28
                                  : screenWidth * 0.076,
                            ),

                            child: SizedBox(
                              width: double.infinity,

                              height: isDesktop
                                  ? 240
                                  : isTablet
                                  ? 225
                                  : screenWidth * 0.529,

                              child: Image.asset(
                                'assets/maps.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // =================================================
// PART 4 — RATE YOUR EXPERIENCE
// =================================================

                          Text(
                            'Rate your Experience',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Geologica',
                              fontSize: isDesktop
                                  ? 21
                                  : isTablet
                                  ? 20
                                  : 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Your feedback helps us improve',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Geologica',
                              fontSize: isDesktop
                                  ? 20
                                  : isTablet
                                  ? 20
                                  : screenWidth * 0.045,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 12),

// =================================================
// CLICKABLE STARS
// =================================================

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                                  (index) {
                                final int starNumber = index + 1;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRating = starNumber;
                                    });
                                  },

                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop
                                          ? 4
                                          : isTablet
                                          ? 4
                                          : screenWidth * 0.015,
                                    ),

                                    child: Icon(
                                      starNumber <= selectedRating
                                          ? Icons.star
                                          : Icons.star_border,

                                      size: isDesktop
                                          ? 40
                                          : isTablet
                                          ? 35
                                          : screenWidth * 0.085,

                                      color: starNumber <= selectedRating
                                          ? const Color(0xFFFFD329)
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 15),
                          // =================================================
// PART 5 — WRITE A REVIEW
// =================================================

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showReviewBox = !showReviewBox;
                              });
                            },

                            child: Text(
                              'Write a review (optional)',
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontFamily: 'Geologica',

                                fontSize: isDesktop
                                    ? 18
                                    : isTablet
                                    ? 16
                                    : screenWidth * 0.041,

                                fontWeight: FontWeight.w400,

                                color: Colors.black,

                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

// =================================================
// REVIEW BOX — APPEARS ONLY AFTER CLICK
// =================================================

                          if (showReviewBox) ...[
                            const SizedBox(height: 12),

                            Container(
                              width: double.infinity,

                              constraints: BoxConstraints(
                                minHeight: 40,
                                maxHeight: 110,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),

                              child: TextField(
                                controller: reviewController,

                                maxLines: null,

                                expands: true,

                                textAlignVertical:
                                TextAlignVertical.top,

                                style: TextStyle(
                                  fontFamily: 'Geologica',

                                  fontSize: isDesktop
                                      ? 14
                                      : isTablet
                                      ? 13
                                      : screenWidth * 0.034,

                                  color: Colors.black,
                                ),

                                decoration: InputDecoration(
                                  hintText: 'Write your review...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Geologica',

                                    fontSize: isDesktop
                                        ? 14
                                        : isTablet
                                        ? 13
                                        : screenWidth * 0.034,

                                    color: Colors.grey,
                                  ),

                                  border: InputBorder.none,

                                  contentPadding:
                                  const EdgeInsets.all(12),
                                ),
                              ),

                            ),

                          ],

                          const SizedBox(height: 20),
                          // =================================================
// PART 6 — SUBMIT REVIEW BUTTON
// =================================================

                          SizedBox(
                            width: double.infinity,

                            height: isDesktop
                                ? 46
                                : isTablet
                                ? 44
                                : screenWidth * 0.102,

                            child: ElevatedButton(
                              onPressed: () {
                                // Submit review action
                                FocusScope.of(context).unfocus();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MappingScreen(),
                                  ),
                                      (route) => false,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Review submitted successfully',
                                    ),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFEA08),

                                foregroundColor: Colors.black,

                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),

                              child: Text(
                                'Submit Review',

                                style: TextStyle(
                                  fontFamily: 'Geologica',

                                  fontSize: isDesktop
                                      ? 13
                                      : isTablet
                                      ? 12
                                      : screenWidth * 0.031,

                                  fontWeight: FontWeight.w700,

                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

// Bottom spacing so content doesn't touch footer
                          SizedBox(
                            height: isDesktop
                                ? 30
                                : isTablet
                                ? 28
                                : 25,
                          ),


                        ],
                      ),
                    ),
                  ),
                ),



                // =================================================
                // FIXED FOOTER
                // =================================================

                SizedBox(
                  height: footerHeight,

                  width: double.infinity,

                  child: Container(
                    color: const Color(0xFF3C3A3A),
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