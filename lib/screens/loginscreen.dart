import 'package:flutter/material.dart';
import '/rides/mapscreen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // ==========================================
  // TEXT CONTROLLERS
  // ==========================================

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  // ==========================================
  // PASSWORD VISIBILITY & LOADING
  // ==========================================

  bool obscurePassword = true;
  bool _isLoading = false;

  // ==========================================
  // DISPOSE CONTROLLERS
  // ==========================================

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // LOGIN ACTION
  // ==========================================

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String phone = phoneController.text.trim();
    final String password = passwordController.text.trim();

    final result = await AuthService().login(
      phoneNumber: phone,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      // Navigate directly to MapScreen (Requirement 11)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MappingScreen(),
        ),
        (route) => false,
      );
    } else {
      // Display appropriate error message without navigating to MapScreen (Requirement 12)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Login failed. Please check your credentials.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController resetPhoneController =
        TextEditingController(text: phoneController.text.trim());
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isResetting = false;
    String? dialogError;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'Geologica',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dialogError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Text(
                          dialogError!,
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    TextField(
                      controller: resetPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Registered Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isResetting ? null : () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD329),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: isResetting
                      ? null
                      : () async {
                          final phone = resetPhoneController.text.trim();
                          final newPass = newPasswordController.text;
                          final confirmPass = confirmPasswordController.text;

                          if (phone.isEmpty || newPass.isEmpty) {
                            setDialogState(() => dialogError = 'Please fill all fields');
                            return;
                          }
                          if (newPass != confirmPass) {
                            setDialogState(() => dialogError = 'Passwords do not match');
                            return;
                          }

                          setDialogState(() {
                            isResetting = true;
                            dialogError = null;
                          });

                          final res = await AuthService().resetPassword(
                            phoneNumber: phone,
                            newPassword: newPass,
                          );

                          if (!mounted) return;

                          if (res['success'] == true) {
                            Navigator.pop(dialogCtx);
                            passwordController.text = newPass;
                            phoneController.text = phone;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password updated successfully! Tap LOGIN to continue.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            setDialogState(() {
                              isResetting = false;
                              dialogError = res['message'] ?? 'Failed to update password';
                            });
                          }
                        },
                  child: isResetting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Save Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================
  // RESPONSIVE SCREEN
  // ==========================================

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;

        final bool isMobile = screenWidth < 600;

        final bool isTablet =
            screenWidth >= 600 && screenWidth < 1024;

        final bool isDesktop = screenWidth >= 1024;

        // ======================================
        // RESPONSIVE WIDTH
        // ======================================

        final double contentWidth = isDesktop
            ? 480
            : isTablet
            ? 520
            : screenWidth * 0.88;

        // ======================================
        // RESPONSIVE SIZES
        // ======================================

        final double headerHeight = isDesktop ? 90 : 82;

        final double titleSize = isDesktop ? 24 : 20;

        final double horizontalPadding =
        isDesktop ? 24 : 18;

        return Scaffold(

          backgroundColor: Colors.white,

          resizeToAvoidBottomInset: true,

          body: SafeArea(

            top: true,
            bottom: false,

            child: Column(
              children: [

                // ==================================
                // HEADER
                // ==================================

                Container(
                  height: headerHeight,
                  width: double.infinity,
                  color: const Color(0xFFFFD329),

                  alignment: Alignment.center,

                  child: Text(
                    'Welcome to METERSAY',

                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                // ==================================
                // MAIN BODY
                // ==================================

                Expanded(

                  child: SingleChildScrollView(

                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: screenHeight * 0.025,
                    ),

                    child: Center(

                      child: ConstrainedBox(

                        constraints: BoxConstraints(
                          maxWidth: contentWidth,
                        ),

                        child: Form(
                          key: formKey,

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,

                            children: [

// ==========================================
// METERSAY LOGO
// ==========================================

                              SizedBox(
                                height: screenHeight * 0.045,
                              ),

                              Center(
                                child: Image.asset(
                                  'assets/logo.png',

                                  width: isDesktop
                                      ? 140
                                      : isTablet
                                      ? 130
                                      : screenWidth * 0.30,

                                  height: isDesktop
                                      ? 140
                                      : isTablet
                                      ? 130
                                      : screenWidth * 0.30,

                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(
                                height: screenHeight * 0.065,
                              ),

// ==========================================
// PHONE NUMBER LABEL
// ==========================================

                              Align(
                                alignment: Alignment.centerLeft,

                                child: Text(
                                  'Enter Registered Phone Number',

                                  style: TextStyle(
                                    fontSize: isDesktop ? 17 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

// ==========================================
// PHONE NUMBER FIELD
// ==========================================

                              SizedBox(
                                height: isDesktop ? 58 : 48,

                                child: TextFormField(
                                  controller: phoneController,

                                  keyboardType: TextInputType.phone,

                                  maxLength: 10,

                                  textInputAction: TextInputAction.next,

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter phone number';
                                    }

                                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                                      return 'Enter valid 10 digit phone number';
                                    }

                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    counterText: '',

                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: const BorderSide(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

// ==========================================
// SPACE
// ==========================================

                              SizedBox(
                                height: screenHeight * 0.035,
                              ),

// ==========================================
// PASSWORD LABEL
// ==========================================

                              Align(
                                alignment: Alignment.centerLeft,

                                child: Text(
                                  'Enter Password',

                                  style: TextStyle(
                                    fontSize: isDesktop ? 17 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

// ==========================================
// PASSWORD FIELD WITH EYE BUTTON
// ==========================================

                              SizedBox(
                                height: isDesktop ? 58 : 48,

                                child: TextFormField(
                                  controller: passwordController,

                                  obscureText: obscurePassword,

                                  textInputAction: TextInputAction.done,

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }

                                    return null;
                                  },

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),

                                    // ======================================
                                    // EYE BUTTON
                                    // ======================================

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

                                        color: Colors.black87,

                                        size: isDesktop ? 25 : 21,
                                      ),

                                      tooltip: obscurePassword
                                          ? 'Show password'
                                          : 'Hide password',
                                    ),

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11),
                                      borderSide: const BorderSide(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: screenHeight * 0.035,
                              ),

// ==========================================
// LOGIN BUTTON
// ==========================================

                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isDesktop ? 280 : 280,
                                  ),

                                  child: SizedBox(
                                    width: double.infinity,

                                    height: isDesktop
                                        ? 52
                                        : isTablet
                                        ? 48
                                        : (screenHeight * 0.048)
                                        .clamp(40.0, 46.0),

                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _handleLogin,

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD9D9D9),

                                        foregroundColor: Colors.black,

                                        elevation: 0,

                                        padding: EdgeInsets.zero,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),

                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'L O G I N',

                                              style: TextStyle(
                                                fontSize: isDesktop ? 19 : 17,

                                                fontWeight: FontWeight.w500,

                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),

// ==========================================
// FORGOT PASSWORD
// ==========================================

                              SizedBox(
                                height: screenHeight * 0.014,
                              ),

                              Center(
                                child: TextButton(
                                  onPressed: _showForgotPasswordDialog,

                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),

                                    minimumSize: Size.zero,

                                    tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                  ),

                                  child: Text(
                                    'Forgot Password..?',

                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,

                                      fontWeight: FontWeight.w500,

                                      letterSpacing: 1.2,

                                      color: Colors.black,

                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: screenHeight * 0.02,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ==================================
                // FOOTER
                // ==================================

                Container(
                  width: double.infinity,
                  height: isDesktop ? 58 : 52,
                  color: const Color(0xFF3C3A3A),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
