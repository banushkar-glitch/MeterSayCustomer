import 'package:flutter/material.dart';
import 'package:metersay_app/rides/mapscreen.dart';

class RideReviewScreen extends StatefulWidget {
  const RideReviewScreen({Key? key}) : super(key: key);

  @override
  State<RideReviewScreen> createState() =>
      _RideReviewScreenState();
}

class _RideReviewScreenState
    extends State<RideReviewScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MappingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, constraints) {

        final screenWidth = constraints.maxWidth;

        //==========================
        // Responsive Breakpoints
        //==========================

        final bool isMobile =
            screenWidth < 600;

        final bool isTablet =
            screenWidth >= 600 &&
                screenWidth < 1024;

        final bool isDesktop =
            screenWidth >= 1024;

        //==========================
        // Responsive Sizes
        //==========================

        final double bodyWidth =
        isDesktop
            ? 520
            : isTablet
            ? 480
            : screenWidth * 0.90;

        final double horizontalPadding =
        isDesktop ? 30 : 20;

        final double titleSize = isDesktop ? 28 : 20;

        final double headingSize =
        isDesktop ? 32 : 20;

        final double descriptionSize =
        isDesktop ? 18 : 12;

        final double tickSize =
        isDesktop ? 140 : 100;

        return Scaffold(

          backgroundColor: Colors.white,

          body: SafeArea(

            child: Column(

              children: [

                /// HEADER

                SizedBox(

                  height: isDesktop ? 80 : 80,

                  width: double.infinity,

                  child: Container(

                    color: const Color(0xFFFFD329),

                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),

                    child: Row(

                      children: [

                        IconButton(

                          onPressed: () {

                            // TODO : Open Drawer

                          },

                          icon: Icon(

                            Icons.menu,

                            color: Colors.black,

                            size: isDesktop ? 34 : 34,

                          ),

                        ),

                        Expanded(

                          child: Center(

                            child: Text(

                              "Ride Review",

                              style: TextStyle(

                                fontSize: titleSize,

                                fontWeight: FontWeight.w400,

                                color: Colors.black,

                              ),

                            ),

                          ),

                        ),

                        IconButton(

                          onPressed: () {

                            // TODO : Notification

                          },

                          icon: Icon(

                            Icons.notifications_none,

                            color: Colors.black,

                            size: isDesktop ? 30 : 30,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),



                /// BODY

                Expanded(

                  child: Center(

                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        maxWidth: bodyWidth,
                      ),

                      child: Padding(

                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),

                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Image.asset(

                              "assets/check.png",

                              height: tickSize,

                              fit: BoxFit.contain,

                            ),

                            SizedBox(
                              height: isDesktop ? 28 : 22,
                            ),

                            Text(

                              "Thank you for your review !",

                              textAlign: TextAlign.center,

                              style: TextStyle(

                                fontSize: headingSize,

                                fontWeight: FontWeight.w700,

                                color: Colors.black,

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 18 : 14,
                            ),

                            Text(
                              "Thank you for the rating! 🛺 Your feedback has been recorded. Ready for your next booking? Keep the meter running and stay online to find your next passenger nearby!",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: descriptionSize,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),

                          ],

                        ),

                      ),

                    ),

                  ),

                ),



                /// FOOTER

                Container(

                  width: double.infinity,

                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),

                  constraints: const BoxConstraints(
                    minHeight: 80,
                  ),

                  decoration: const BoxDecoration(

                    color: Color(0xFF3C3A3A),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black12,

                        blurRadius: 8,

                        offset: Offset(0, -2),

                      ),

                    ],

                  ),

                ),

              ],

            ),

          ),

        );

      },

    );

  }

}