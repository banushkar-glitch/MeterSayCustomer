import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accountcreated.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  //====================================
  // OTP Controllers
  //====================================

  final List<TextEditingController> otpControllers =
  List.generate(
    6,
        (index) => TextEditingController(),
  );

  //====================================
  // OTP Focus Nodes
  //====================================

  final List<FocusNode> otpFocusNodes =
  List.generate(
    6,
        (index) => FocusNode(),
  );

  @override
  void dispose() {

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, constraints) {

        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

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
            ? 500
            : isTablet
            ? 540
            : screenWidth * 0.92;

        // Responsive values

        final double horizontalPadding =
        isDesktop ? 24 : 18;

        final double titleSize =
        isDesktop ? 24 : 20;

        final double instructionSize =
        isDesktop ? 38 : 28;

        final double otpBoxSize =
        isDesktop ? 58 : 48;

        final double resendSize =
        isDesktop ? 28 : 24;

        final double roadImageHeight =
        isDesktop ? 240 : 170;

        return Scaffold(



          backgroundColor: Colors.white,

          resizeToAvoidBottomInset: false,

          body: SafeArea(

            child: Column(

              children: [

                /// HEADER

                SizedBox(

                  height: isDesktop ? 90 : 82,

                  width: double.infinity,

                  child: Container(

                    color: const Color(0xFFFFD329),

                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),

                    child: Row(

                      children: [

                        // Back Button
                        IconButton(

                          onPressed: () {

                            Navigator.pop(context);

                          },

                          icon: Icon(

                            Icons.arrow_back,

                            color: Colors.black,

                            size: isDesktop ? 30 : 28,

                          ),

                        ),

                        Expanded(

                          child: Center(

                            child: Text(

                              "Registration",

                              style: TextStyle(

                                fontSize: titleSize,

                                fontWeight: FontWeight.w500,

                                color: Colors.black,

                              ),

                            ),

                          ),

                        ),

                        IconButton(

                          onPressed: () {

                            // Notification

                          },

                          icon: Icon(

                            Icons.notifications_none,

                            color: Colors.black,

                            size: isDesktop ? 28 : 26,

                          ),

                        ),

                      ],

                    ),

                  ),

                ),



                /// BODY

                Expanded(

                  child: SingleChildScrollView(

                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                    padding: EdgeInsets.symmetric(

                      horizontal: horizontalPadding,

                      vertical: 20,

                    ),

                    child: Center(

                      child: ConstrainedBox(

                        constraints: BoxConstraints(

                          maxWidth: formWidth,

                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.stretch,

                          children: [

                            SizedBox(
                              height: isDesktop ? 35 : 20,
                            ),

                            Center(

                              child: Text(

                                "Please enter the one time\n"
                                    "password sent to your\n"
                                    "registered mobile number.",

                                textAlign: TextAlign.center,

                                style: TextStyle(

                                  fontSize: instructionSize,

                                  fontFamily: "InriaSerif",

                                  fontWeight: FontWeight.w400,

                                  height: 1.35,

                                  color: Colors.black,

                                ),

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 45 : 35,
                            ),

                            // OTP Boxes
                            Center(

                              child: Wrap(

                                alignment: WrapAlignment.center,

                                spacing: isDesktop ? 16 : 12,

                                runSpacing: 12,

                                children: List.generate(

                                  6,

                                      (index) {

                                    return SizedBox(

                                      width: otpBoxSize,

                                      height: otpBoxSize + 6,

                                      child: TextField(

                                        controller: otpControllers[index],

                                        focusNode: otpFocusNodes[index],

                                        keyboardType: TextInputType.number,

                                        textAlign: TextAlign.center,

                                        textInputAction: TextInputAction.next,

                                        cursorColor: Colors.black,

                                        style: TextStyle(

                                          fontSize: isDesktop ? 24 : 22,

                                          fontWeight: FontWeight.w500,

                                        ),

                                        inputFormatters: [

                                          FilteringTextInputFormatter.digitsOnly,

                                          LengthLimitingTextInputFormatter(1),

                                        ],

                                        decoration: InputDecoration(

                                          counterText: "",

                                          contentPadding: EdgeInsets.zero,

                                          border: OutlineInputBorder(

                                            borderRadius: BorderRadius.circular(12),

                                            borderSide: BorderSide(

                                              color: Colors.grey.shade300,

                                            ),

                                          ),

                                          enabledBorder: OutlineInputBorder(

                                            borderRadius: BorderRadius.circular(12),

                                            borderSide: BorderSide(

                                              color: Colors.grey.shade300,

                                            ),

                                          ),

                                          focusedBorder: OutlineInputBorder(

                                            borderRadius: BorderRadius.circular(12),

                                            borderSide: const BorderSide(

                                              color: Colors.black54,

                                            ),

                                          ),

                                        ),

                                        onChanged: (value) {

                                          if (value.isNotEmpty) {

                                            if (index < 5) {

                                              FocusScope.of(context).requestFocus(
                                                otpFocusNodes[index + 1],
                                              );

                                            } else {

                                              FocusScope.of(context).unfocus();

                                            }

                                          }

                                          if (value.isEmpty && index > 0) {

                                            FocusScope.of(context).requestFocus(

                                              otpFocusNodes[index - 1],

                                            );

                                          }

                                        },

                                      ),

                                    );

                                  },

                                ),

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 40 : 30,
                            ),

                            Center(

                              child: TextButton(

                                onPressed: () {

                                  // TODO : Resend OTP

                                },

                                child: Text(

                                  "Resend",

                                  style: TextStyle(

                                    fontSize: resendSize,

                                    fontFamily: "InriaSerif",

                                    fontWeight: FontWeight.w400,

                                    letterSpacing: 6,

                                    color: Colors.black87,

                                  ),

                                ),

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



                /// RICKSHAW IMAGE

                SizedBox(

                  width: double.infinity,

                  child: Center(

                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        maxWidth: formWidth,
                      ),

                      child: Image.asset(

                        "assets/rickshaw_road1.png",

                        width: double.infinity,

                        height: roadImageHeight,

                        fit: BoxFit.contain,

                      ),

                    ),

                  ),

                ),



                /// FOOTER

                Container(

                  width: double.infinity,

                  padding: EdgeInsets.fromLTRB(

                    horizontalPadding,

                    12,

                    horizontalPadding,

                    18,

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

                        height: isDesktop ? 58 : 52,

                        child: ElevatedButton(

                          onPressed: () {

                            FocusScope.of(context).unfocus();

                            // TODO : Verify OTP
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountCreatedScreen(),
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

                            "Verify OTP",

                            style: TextStyle(

                              fontFamily: "InriaSerif",

                              fontSize: isDesktop ? 22 : 20,

                              fontWeight: FontWeight.w400,

                              letterSpacing: 2,

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