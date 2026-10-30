import 'package:flutter/material.dart';
import 'package:metersay_app/rides/activeride.dart';
import 'package:metersay_app/sliders/customermenu.dart';

class RiderAccepted extends StatefulWidget {
  const RiderAccepted({super.key});

  static const Color yellow = Color(0xFFFFD329);
  static const Color dark = Color(0xFF3C3A3A);

  @override
  State<RiderAccepted> createState() => _RiderAcceptedState();
}

class _RiderAcceptedState extends State<RiderAccepted> {

  bool isMenuOpen = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;

            final bool isDesktop = screenWidth >= 900;

            final bool isTablet =
                screenWidth >= 600 && screenWidth < 900;

            final double contentMaxWidth = isDesktop
                ? 500.0
                : isTablet
                ? 480.0
                : screenWidth;

            final double headerHeight =
            isDesktop ? 80.0 : 80.0;

            final double footerHeight =
            isDesktop ? 80.0 : 80.0;

            return Stack(
              children: [

                // ============================================================
                // MAP
                // ============================================================
                // ============================================================
// CENTERED MAP
// ============================================================

                Positioned(
                  top: headerHeight,
                  left: 0,
                  right: 0,
                  bottom: footerHeight,

                  child: Center(
                    child: SizedBox(
                      width: contentMaxWidth,
                      height: double.infinity,

                      child: Image.asset(
                        'assets/maps.png',
                        width: contentMaxWidth,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),

                // ============================================================
                // HEADER
                // ============================================================
                // ============================================================
// HEADER
// ============================================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: headerHeight,

                  child: Container(
                    color: RiderAccepted.yellow,

                    child: Stack(
                      alignment: Alignment.center,

                      children: [

                        // ==================================================
                        // MENU
                        // ==================================================

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

                        // ==================================================
                        // TITLE
                        // ==================================================

                        Text(
                          'Ride Details',

                          style: TextStyle(
                            fontSize: isDesktop ? 28.0 : 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),

                        // ==================================================
                        // NOTIFICATION
                        // ==================================================

                        Positioned(
                          right: isDesktop ? 25.0 : 20.0,

                          child: Icon(
                            Icons.notifications_none,
                            size: isDesktop ? 28 : 26,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ============================================================
                // RIDE DETAILS SHEET
                // ============================================================
                // ============================================================
// CENTERED RIDE DETAILS SHEET
// ============================================================

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: footerHeight,

                  child: Center(
                    child: SizedBox(
                      width: contentMaxWidth,

                      child: _RideDetailsSheet(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ),
                  ),
                ),

                // ============================================================
                // FOOTER
                // ============================================================
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: footerHeight,
                  child: Container(
                    color: RiderAccepted.dark,
                    child: _CancelWarning(
                      screenWidth: screenWidth,
                    ),
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
            );
          },
        ),
      ),
    );
  }
}

class _RideDetailsSheet extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _RideDetailsSheet({
    required this.screenWidth,
    required this.screenHeight,
  });



  @override
  Widget build(BuildContext context) {
    // Keep the content compact on large screens.
    final double contentWidth =
    screenWidth > 700 ? 500.0 : screenWidth * 0.94;

    final double titleSize =
    screenWidth >= 700
        ? 16
        : (screenWidth * 0.047).clamp(15.0, 20.0);

    final double otpTextSize =
    screenWidth > 700 ? 28 : (screenWidth * 0.065).clamp(23.0, 29.0);

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),

      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 700
            ? 20
            : screenWidth * 0.025,
        vertical: screenHeight * 0.014,
      ),

      child: Center(
        child: SizedBox(
          width: contentWidth,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ============================================================
              // DRIVER ARRIVAL
              // ============================================================

              Text(
                'Driver arrives in 5 minutes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inria Serif',
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.012,
              ),

              // ============================================================
              // OTP
              // ============================================================

              // ============================================================
// SMALLER YELLOW OTP CONTAINER
// ============================================================

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 700 ? 560 : double.infinity,
                  ),

                  child: Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 700 ? 14 : 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD329),
                      borderRadius: BorderRadius.circular(28),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // ==================================================
                        // OTP TEXT
                        // ==================================================

                        Text(
                          'OTP :',
                          style: TextStyle(
                            fontFamily: 'Inria Serif',
                            fontSize: screenWidth > 700
                                ? 18
                                : (screenWidth * 0.052).clamp(18.0, 22.0),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),

                        const Spacer(),

                        // ==================================================
                        // OTP BOX 1
                        // ==================================================

                        _OtpBox(
                          value: '5',
                          size: screenWidth,
                        ),

                        SizedBox(
                          width: screenWidth > 700 ? 8 : 8,
                        ),

                        // ==================================================
                        // OTP BOX 2
                        // ==================================================

                        _OtpBox(
                          value: '5',
                          size: screenWidth,
                        ),

                        SizedBox(
                          width: screenWidth > 700 ? 8 : 8,
                        ),

                        // ==================================================
                        // OTP BOX 3
                        // ==================================================

                        _OtpBox(
                          value: '5',
                          size: screenWidth,
                        ),

                        SizedBox(
                          width: screenWidth > 700 ? 8 : 8,
                        ),

                        // ==================================================
                        // OTP BOX 4
                        // ==================================================

                        _OtpBox(
                          value: '5',
                          size: screenWidth,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.014,
              ),

              // ============================================================
              // DRIVER CARD
              // ============================================================

              _DriverCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final String value;
  final double size;

  const _OtpBox({
    required this.value,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double boxSize = size > 700
        ? 40
        : (size * 0.058).clamp(32.0, 40.0);

    final double digitSize = size > 700
        ? 19
        : (size * 0.040).clamp(16.0, 19.0);

    return SizedBox(
      width: boxSize,
      height: boxSize,

      child: Container(
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),

          border: Border.all(
            color: const Color(0xFFD0D0D0),
            width: 1,
          ),
        ),

        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'Inria Serif',
            fontSize: digitSize,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _DriverCard({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = screenWidth > 700;

    return Container(
      width: double.infinity,

      // Smaller grey container
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 16 : screenWidth * 0.035,
        vertical: isDesktop ? 10 : screenHeight * 0.008,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ⭐ Rating
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: isDesktop ? 15 : 16,
                  color: Colors.black,
                ),
                const SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontFamily: 'Inria Serif',
                    fontSize: isDesktop ? 15 : 16,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.004),

          // Driver information
          Row(
            children: [

              // Driver photo
              SizedBox(
                width: isDesktop ? 55 : 48,
                height: isDesktop ? 55 : 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/driver.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.035),

              // Driver details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isDesktop ? 33.0 : 28.0,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name : Mahesh Jagtap',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inria Serif',
                          fontSize: isDesktop ? 20 : 18,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Vh no : MH 12 AA 1234',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inria Serif',
                          fontSize: isDesktop ? 18 : 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rickshaw

            ],
          ),

          SizedBox(height: screenHeight * 0.010),

          // Message + Call
          Row(
            children: [

              Expanded(
                child: _ActionButton(
                  text: 'Message',
                  icon: Icons.chat_bubble_outline,
                  screenWidth: screenWidth,
                ),
              ),

              SizedBox(width: screenWidth * 0.04),

              Expanded(
                child: _ActionButton(
                  text: 'Call',
                  icon: Icons.phone,
                  screenWidth: screenWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double screenWidth;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (screenWidth * 0.105).clamp(42.0, 55.0),

      child: ElevatedButton.icon(
        onPressed: () {
          // ==========================================================
          // TODO:
          // Message → open chat screen later
          // Call → initiate driver call later
          // ==========================================================
        },

        icon: Icon(
          icon,
          size: (screenWidth * 0.055).clamp(20.0, 27.0),
          color: Colors.black,
        ),

        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inria Serif',
            fontSize: screenWidth >= 900 ? 14.0 : 18.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          foregroundColor: Colors.black,
          elevation: 0,

          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
// ================================================================
// FIXED CANCELLATION FOOTER
// ================================================================

class _CancelWarning extends StatelessWidget {
  final double screenWidth;

  const _CancelWarning({
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = screenWidth >= 900;
    final bool isTablet =
        screenWidth >= 600 && screenWidth < 900;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 900
              : isTablet
              ? 700
              : double.infinity,
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 25
                : isTablet
                ? 20
                : 17,
          ),

          child: Container(
            width: double.infinity,

            height: isDesktop
                ? 62
                : isTablet
                ? 60
                : 59,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [

                // ==================================================
                // WARNING ICON
                // ==================================================

                Padding(
                  padding: EdgeInsets.only(
                    left: isDesktop ? 10 : 6,
                  ),

                  child: Image.asset(
                    'assets/images (2).png',

                    width: isDesktop ? 30 : 27,
                    height: isDesktop ? 28 : 25,

                    fit: BoxFit.contain,

                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: isDesktop ? 30 : 27,
                      );
                    },
                  ),
                ),

                // ==================================================
                // WARNING MESSAGE
                // ==================================================

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                    ),

                    child: Text(
                      'Canceling rides more than 2 times '
                          'in a single day may temporarily block '
                          'your account for 24 hours. Please accept '
                          'rides responsibly to maintain smooth '
                          'service for customers.',

                      maxLines: 4,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isDesktop ? 10 : 9,
                        fontWeight: FontWeight.w200,
                        height: 1.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // CANCEL RIDE
                // ==================================================

                Padding(
                  padding: EdgeInsets.only(
                    right: isDesktop ? 10 : 7,
                  ),

                  child: TextButton(
                    onPressed: () {
                      // ==================================================
                      // TODO:
                      // Add cancel ride API / confirmation dialog later.
                      // ==================================================
                    },

                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 9 : 5,
                      ),

                      minimumSize: Size.zero,

                      tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                    ),

                    child: Text(
                      'Cancel Ride',

                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: isDesktop ? 13 : 11,
                        fontWeight: FontWeight.w500,
                        decoration:
                        TextDecoration.underline,
                        color: Colors.red,
                      ),
                    ),
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