import 'package:flutter/material.dart';
import 'dart:async';
import 'createaccount_screen.dart';
import '../rides/mapscreen.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Check login session after 4 seconds
    Timer(const Duration(seconds: 4), () async {
      if (!mounted) return;

      final bool loggedIn = await AuthService().isLoggedIn();

      if (!mounted) return;

      if (loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MappingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFFFFD329),

        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              //  BIG ANIMATION GIF
              Expanded(
              flex: 18,
              child: Center(
                child: Image.asset(
                  'assets/animation3.gif',   // oUR GIF
                  width: width * 1.4,
                  fit: BoxFit.contain,
                ),
              ),
            ),
              ],
            ),
        ),
    );
  }
}
