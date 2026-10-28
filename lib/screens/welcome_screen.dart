import 'package:flutter/material.dart';
import 'package:metersay_app/rides/mapscreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, constraints) {

        final screenWidth = constraints.maxWidth;

        // Responsive Breakpoints

        final bool isMobile = screenWidth < 600;

        final bool isTablet =
            screenWidth >= 600 &&
                screenWidth < 1024;

        final bool isDesktop =
            screenWidth >= 1024;

        // Maximum body width

        final double formWidth =
        isDesktop
            ? 700
            : isTablet
            ? 620
            : screenWidth * 0.92;

        // Responsive Sizes

        final double horizontalPadding =
        isDesktop ? 30 : 20;

        final double titleSize =
        isDesktop ? 24 : 20;

        final double welcomeSize =
        isDesktop ? 34 : 24;

        final double buttonHeight =
        isDesktop ? 58 : 52;

        final double roadImageHeight =
        isDesktop ? 260 : 185;

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

                    alignment: Alignment.center,

                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),

                    child: Text(

                      "Welcome to METERSAY",

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: titleSize,

                        fontWeight: FontWeight.w400,

                        color: Colors.black,

                      ),

                    ),

                  ),

                ),



                /// BODY

                Expanded(

                  child: SingleChildScrollView(

                    padding: EdgeInsets.symmetric(

                      horizontal: horizontalPadding,

                      vertical: isDesktop ? 35 : 28,

                    ),

                    child: Center(

                      child: ConstrainedBox(

                        constraints: BoxConstraints(

                          maxWidth: formWidth,

                        ),

                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(

                              "Namaste and Welcome! 🙏",

                              style: TextStyle(

                                fontSize: welcomeSize,

                                fontWeight: FontWeight.w700,

                                color: Colors.black,

                                height: 1.35,

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 18 : 14,
                            ),

                            Text(
                              "You are now connected directly to the heartbeat of the city—our local auto drivers. Enjoy fair pricing, quick pickups, and hassle-free daily travel. Let’s hit the road!",
                              textAlign: TextAlign.left,

                              style: TextStyle(

                                fontSize: isDesktop ? 26 : 24,

                                fontWeight: FontWeight.w400,

                                color: Colors.black,

                                height: 1.55,

                              ),

                            ),

                            SizedBox(
                              height: 20,
                            ),

                          ],

                        ),

                      ),

                    ),

                  ),

                ),



                /// ROAD IMAGE

                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 550,
                      ),
                      child: Image.asset(
                        "assets/road1.png",
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),



                /// FOOTER

                Container(

                  width: double.infinity,

                  height: 80, // 👈 FOOTER HEIGHT

                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
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

                  child: Center(

                    child: ConstrainedBox(

                      constraints: const BoxConstraints(

                        maxWidth: 500,

                      ),

                      child: SizedBox(

                        width: double.infinity,

                        height: buttonHeight,

                        child: ElevatedButton(

                          onPressed: () {

                            // TODO : Continue
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MappingScreen(),
                              ),
                            );

                          },

                          style: ElevatedButton.styleFrom(

                            backgroundColor: const Color(0xFFD9D9D9),

                            foregroundColor: Colors.black,

                            elevation: 0,

                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(28),

                            ),

                          ),

                          child: Text(

                            "Continue",

                            style: TextStyle(

                              fontFamily: "InriaSerif",

                              fontSize: isDesktop ? 22 : 20,

                              fontWeight: FontWeight.w400,

                              letterSpacing: 0.5,

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

        );

      },

    );

  }

}