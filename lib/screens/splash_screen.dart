import 'package:flutter/material.dart';
import 'dart:async';
import 'createaccount_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // auto move to login after 3 sec
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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