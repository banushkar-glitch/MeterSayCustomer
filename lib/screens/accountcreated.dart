import 'package:flutter/material.dart';
import 'welcome_screen.dart';
class AccountCreatedScreen extends StatefulWidget {
  const AccountCreatedScreen({super.key});

  @override
  State<AccountCreatedScreen> createState() =>
      _AccountCreatedScreenState();
}

class _AccountCreatedScreenState
    extends State<AccountCreatedScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final bool isDesktop = screenWidth >= 900;
    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    // ======================================================
    // RESPONSIVE CONTENT WIDTH
    // ======================================================

    final double contentWidth = isDesktop
        ? 500
        : isTablet
        ? 480
        : screenWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFFD329),

      body: Center(
        child: SizedBox(
          width: contentWidth,
          height: screenHeight,

          child: Stack(
            children: [

              // ==================================================
              // ACCOUNT CREATED TEXT
              // ==================================================

              Positioned(
                left: 0,
                right: 0,

                top: screenHeight * 0.35,

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 30
                        : isTablet
                        ? 25
                        : 20,
                  ),

                  child: Text(
                    'Account Created Successfully',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'Geologica',

                      fontSize: isDesktop
                          ? 25
                          : isTablet
                          ? 24
                          : 22,

                      fontWeight: FontWeight.w400,

                      height: 1.4,

                      letterSpacing: -0.02,

                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // ==================================================
// SUCCESS GIF
// ==================================================

              Positioned(
                left: 0,
                right: 0,

                top: screenHeight * 0.415,

                child: Center(
                  child: SizedBox(
                    width: isDesktop
                        ? 250
                        : isTablet
                        ? 240
                        : 230,

                    height: isDesktop
                        ? 250
                        : isTablet
                        ? 240
                        : 230,

                    child: Image.asset(
                      'assets/accountcreated_transparent.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}