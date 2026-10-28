import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registration.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  String selectedLanguage = "English";

  final List<String> languages = [

    "English",

    "हिन्दी",

    "मराठी",

  ];

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFE0E0E0),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return LayoutBuilder(

      builder: (context, constraints) {

        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        final bool isDesktop = screenWidth >= 1024;

        final double contentWidth = screenWidth * 0.90;

        final double logoSize =
        (screenWidth * 0.55).clamp(180.0, 280.0);

        final double buttonWidth =
        (screenWidth * 0.78).clamp(280.0, 340.0);

        final double buttonHeight =
        (screenHeight * 0.065).clamp(52.0, 60.0);

        final double languageWidth =
        (screenWidth * 0.40).clamp(150.0, 180.0);

        final double horizontalPadding =
        (screenWidth * 0.05).clamp(20.0, 30.0);

        return Scaffold(

          backgroundColor: const Color(0xFFFFD329),

          body: SafeArea(

            child: Center(

              child: ConstrainedBox(

                constraints: BoxConstraints(

                  maxWidth: contentWidth,

                ),

                child: Padding(

                  padding: EdgeInsets.symmetric(

                    horizontal: horizontalPadding,

                  ),

                  child: Column(

                    children: [

                      Expanded(

                        child: Column(



                          children: [

                            //========================
                            // Logo
                            //========================

                            // Space from top
                            SizedBox(
                              height: isDesktop
                                  ? screenHeight * 0.05
                                  : screenHeight * 0.15,
                            ),

                            Image.asset(

                              "assets/logo.png",

                              width: logoSize,

                              height: logoSize,

                              fit: BoxFit.contain,

                            ),

                            SizedBox(
                              height: isDesktop
                                  ? screenHeight * 0.07
                                  : 80,
                            ),

                            //========================
                            // Login Button
                            //========================

                            SizedBox(
                              width: buttonWidth,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO : Login Screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  foregroundColor: Colors.black,
                                  elevation: 6,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: "InriaSerif",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: screenHeight * 0.035,
                            ),



                            //========================
                            // Create Account
                            //========================

                            SizedBox(
                              width: buttonWidth,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO : Registration

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegistrationScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  foregroundColor: Colors.black,
                                  elevation: 6,
                                  shadowColor: Colors.black26,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontFamily: "InriaSerif",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: isDesktop
                                  ? screenHeight * 0.07
                                  : screenHeight * 0.15,
                            ),

                            //========================
                            // Language
                            //========================


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Language :",
                                  style: TextStyle(
                                    fontFamily: "InriaSerif",
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Container(
                                  width: languageWidth,
                                  height: 46,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2EDD8),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedLanguage,
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: languages.map((language) {
                                        return DropdownMenuItem(
                                          value: language,
                                          child: Text(
                                            language,
                                            style: const TextStyle(
                                              fontFamily: "InriaSerif",
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedLanguage = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                          ],

                        ),

                      ),

                    ],

                  ),

                ),

              ),

            ),

          ),

        );

      },

    );

  }

}