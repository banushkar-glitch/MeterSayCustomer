import 'package:flutter/material.dart';
import 'package:metersay_app/rides/activeride.dart';
import 'package:metersay_app/rides/bookride.dart';
import 'package:metersay_app/rides/mapscreen.dart';
import 'package:metersay_app/rides/pickupdroplocation.dart';
import 'screens/welcome_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/createaccount_screen.dart';
import 'screens/registration.dart';
import '../rides/rideraccepted.dart';
import '../rides/ridecompleted.dart';
import '../rides/pickupmaplocation.dart';
import 'screens/createaccount_screen.dart';
import 'screens/accountcreated.dart';
void main() {
  runApp(MeterApp());
}

class MeterApp extends StatelessWidget {
  const MeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(), // first screen
    );
  }
}