import 'package:flutter/material.dart';
import 'otp_screen.dart';
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  //==============================
  // Controllers
  //==============================

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //==============================
  // Variables
  //==============================

  bool obscurePassword = true;

  //==============================
  // Dispose Controllers
  //==============================

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(

      builder: (context, constraints) {

        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Mobile
        final bool isMobile = screenWidth < 600;

        // Tablet
        final bool isTablet =
            screenWidth >= 600 &&
                screenWidth < 1024;

        // Desktop / Web
        final bool isDesktop =
            screenWidth >= 1024;

        // Maximum width for the form
        final double formWidth =
        isDesktop
            ? 480
            : isTablet
            ? 520
            : screenWidth * 0.92;

        // Responsive spacing
        final double horizontalPadding =
        isDesktop
            ? 24
            : 18;

        final double titleSize =
        isDesktop
            ? 24
            : 20;

        final double labelSize =
        isDesktop
            ? 16
            : 14;

        final double textFieldHeight =
        isDesktop
            ? 58
            : 54;

        final double iconSize =
        isDesktop
            ? 24
            : 22;

        final double imageSize =
        isDesktop
            ? 100
            : 80;

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

                          onPressed: () {},

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
                      vertical: 18,
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
                              height: isDesktop ? 18 : 10,
                            ),

                            // Registration Image
                            Center(

                              child: Image.asset(

                                "assets/registration.png",

                                height: imageSize,

                                fit: BoxFit.contain,

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 30 : 24,
                            ),

                            //==============================
// Name
//==============================

                            Text(
                              "Name",
                              style: TextStyle(
                                fontSize: labelSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(

                              height: textFieldHeight,

                              child: TextFormField(

                                controller: nameController,

                                validator: (value) {

                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter your name";
                                  }

                                  return null;

                                },

                                textInputAction: TextInputAction.next,

                                autofillHints: const [
                                  AutofillHints.name,
                                ],

                                cursorColor: Colors.black,

                                decoration: InputDecoration(

                                  hintText: "Enter Name",

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),

                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    size: iconSize,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),

                                ),

                              ),

                            ),

                            SizedBox(height: isDesktop ? 22 : 18),

//==============================
// Phone Number
//==============================

                            Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: labelSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(

                              height: textFieldHeight,

                              child: TextFormField(

                                controller: phoneController,

                                validator: (value) {

                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter phone number";
                                  }

                                  if (value.length != 10) {
                                    return "Enter valid phone number";
                                  }

                                  return null;

                                },

                                cursorColor: Colors.black,

                                keyboardType: TextInputType.phone,

                                textInputAction: TextInputAction.next,


                                autofillHints: const [
                                  AutofillHints.name,
                                ],

                                decoration: InputDecoration(

                                  hintText: "Enter Phone Number",

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),

                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    size: iconSize,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),

                                ),

                              ),

                            ),

                            SizedBox(height: isDesktop ? 22 : 18),

//==============================
// Password
//==============================

                            Text(
                              "Set Password",
                              style: TextStyle(
                                fontSize: labelSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 8),

                            SizedBox(

                              height: textFieldHeight,

                              child: TextFormField(

                                controller: passwordController,

                                validator: (value) {

                                  if (value == null || value.isEmpty) {
                                    return "Please enter password";
                                  }

                                  if (value.length < 8) {
                                    return "Minimum 8 characters";
                                  }

                                  return null;

                                },
                                cursorColor: Colors.black,

                                obscureText: obscurePassword,

                                textInputAction: TextInputAction.done,

                                autofillHints: const [
                                  AutofillHints.name,
                                ],

                                decoration: InputDecoration(

                                  hintText: "Enter Password",

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),

                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    size: iconSize,
                                  ),

                                  suffixIcon: IconButton(

                                    onPressed: () {

                                      setState(() {

                                        obscurePassword = !obscurePassword;

                                      });

                                    },

                                    icon: Icon(

                                      obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,

                                    ),

                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),

                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),

                                ),

                              ),

                            ),

                            SizedBox(height: isDesktop ? 24 : 20),

// Password Rules Card

                            Container(

                              width: double.infinity,

                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(

                                color: const Color(0xFFFFF8D9),

                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),

                              ),

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    "Password must contain:",

                                    style: TextStyle(

                                      fontSize: labelSize,

                                      fontWeight: FontWeight.w600,

                                    ),

                                  ),

                                  const SizedBox(height: 12),

                                  _passwordRule(
                                    "At least 8 characters",
                                  ),

                                  const SizedBox(height: 8),

                                  _passwordRule(
                                    "One uppercase letter",
                                  ),

                                  const SizedBox(height: 8),

                                  _passwordRule(
                                    "One lowercase letter",
                                  ),

                                  const SizedBox(height: 8),

                                  _passwordRule(
                                    "One number or special character",
                                  ),

                                ],

                              ),

                            ),

                            SizedBox(
                              height: isDesktop ? 24 : 20,
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

                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    14,
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
                        maxWidth: 480,
                      ),

                      child: SizedBox(

                        width: double.infinity,

                        height: isDesktop ? 54 : 50,

                        child: ElevatedButton(

                          onPressed: () {

                            // TODO : Submit Button
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpScreen(),
                              ),
                            );


                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {

                                ScaffoldMessenger.of(context).showSnackBar(

                                  const SnackBar(

                                    content: Text(
                                      "Registration Successful",
                                    ),

                                  ),

                                );

                              }



                          },

                          style: ElevatedButton.styleFrom(

                            backgroundColor: const Color(0xFFD9D9D9),

                            foregroundColor: Colors.black,

                            elevation: 0,

                            shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.circular(30),

                            ),

                          ),

                          child: Text(

                            "Submit",

                            style: TextStyle(

                              fontSize: isDesktop ? 18 : 16,

                              fontWeight: FontWeight.w600,

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
  Widget _passwordRule(String text) {

    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Padding(

          padding: EdgeInsets.only(top: 2),

          child: Icon(

            Icons.check_circle_outline,

            size: 18,

            color: Colors.black87,

          ),

        ),

        const SizedBox(width: 10),

        Expanded(

          child: Text(

            text,

            style: const TextStyle(

              fontSize: 14,

              color: Colors.black87,

            ),

          ),

        ),

      ],

    );

  }
}