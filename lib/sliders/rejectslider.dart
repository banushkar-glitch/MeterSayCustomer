import 'package:flutter/material.dart';

class CancelRideSheet {
  // ============================================================
  // OPEN REJECTION SHEET
  // ============================================================

  static Future<void> show(
      BuildContext context,
      ) {
    // ============================================================
    // SCREEN WIDTH
    // ============================================================

    final double screenWidth =
        MediaQuery.of(context).size.width;

    // ============================================================
    // RESPONSIVE SHEET WIDTH
    // ============================================================

    final double sheetWidth =
    screenWidth >= 900
        ? 500.0
        : screenWidth >= 600
        ? 480.0
        : screenWidth;

    return showModalBottomSheet(
      context: context,

      // ==========================================================
      // ALLOW SHEET TO USE MORE HEIGHT
      // ==========================================================

      isScrollControlled: true,

      // ==========================================================
      // DARK BACKGROUND
      // ==========================================================

      barrierColor:
      Colors.black.withOpacity(0.55),

      // ==========================================================
      // TRANSPARENT MODAL BACKGROUND
      // ==========================================================

      backgroundColor:
      Colors.transparent,

      // ==========================================================
      // ALLOW DRAGGING
      // ==========================================================

      enableDrag: true,

      // ==========================================================
      // IMPORTANT:
      // LIMIT WIDTH ON WEB / DESKTOP
      // ==========================================================

      constraints: BoxConstraints(
        maxWidth: sheetWidth,
      ),

      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,

          child: SizedBox(
            width: sheetWidth,

            child: const _CancelRideBottomSheet(),
          ),
        );
      },
    );
  }
}


// ================================================================
// REJECTION BOTTOM SHEET
// ================================================================

class _CancelRideBottomSheet extends StatefulWidget {
  const _CancelRideBottomSheet();

  @override
  State<_CancelRideBottomSheet> createState() =>
      _CancelRideBottomSheetState();
}


// ================================================================
// STATE
// ================================================================

class _CancelRideBottomSheetState
    extends State<_CancelRideBottomSheet> {

  String? selectedReason;

  @override
  Widget build(BuildContext context) {

    // ============================================================
    // SCREEN SIZE
    // ============================================================

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final double screenHeight =
        MediaQuery.of(context).size.height;


    // ============================================================
    // RESPONSIVE VALUES
    // ============================================================

    final bool isDesktop =
        screenWidth >= 900;

    final bool isTablet =
        screenWidth >= 600 &&
            screenWidth < 900;


    final double horizontalPadding =
    isDesktop
        ? 40
        : isTablet
        ? 30
        : screenWidth * 0.055;


    final double titleSize =
    isDesktop
        ? 20
        : isTablet
        ? 26
        : (screenWidth * 0.052)
        .clamp(20.0, 24.0);


    return DraggableScrollableSheet(

      // ==========================================================
      // DEFAULT HEIGHT
      // ==========================================================

      initialChildSize: 0.64,

      // ==========================================================
      // MINIMUM HEIGHT
      // ==========================================================

      minChildSize: 0.18,

      // ==========================================================
      // MAXIMUM HEIGHT
      // ==========================================================

      maxChildSize: 0.90,

      // ==========================================================
      // ALLOW SHEET TO EXPAND / COLLAPSE
      // ==========================================================

      expand: false,

      builder: (
          BuildContext context,
          ScrollController scrollController,
          ) {

        return Container(

          width: double.infinity,

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),


          child: SingleChildScrollView(
            controller: scrollController,

            physics: const ClampingScrollPhysics(),



            child: Padding(

              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,

                // Bottom safe-area space.
                bottom:
                MediaQuery.of(context)
                    .padding
                    .bottom +
                    20,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ==================================================
                  // DRAG HANDLE
                  // ==================================================

                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.018,
                      bottom: screenHeight * 0.020,
                    ),

                    child: Container(
                      width: isDesktop
                          ? 90
                          : isTablet
                          ? 75
                          : screenWidth * 0.145,

                      height: isDesktop
                          ? 9
                          : 7,

                      decoration: BoxDecoration(
                        color: const Color(0xFFBDBDBD),

                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                  ),


                  // ==================================================
                  // TITLE
                  // ==================================================

                  Text(
                    'Why do you want to Cancel this ride?',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'Inter',

                      fontSize: titleSize,

                      fontWeight:
                      FontWeight.w700,

                      color: Colors.black,
                    ),
                  ),


                  // ==================================================
                  // SPACE
                  // ==================================================

                  SizedBox(
                    height: screenHeight * 0.035,
                  ),


                  // ==================================================
                  // PART 2 CONTENT WILL COME HERE
                  // ==================================================

                  // ==================================================
// REJECTION REASONS
// ==================================================

                  Column(
                    children: [

                      // ==================================================
                      // PICKUP TOO FAR AWAY
                      // ==================================================

                      _ReasonTile(
                        text: 'Pickup too far away',
                        value: 'Pickup too far away',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),

                      // ==================================================
                      // HEAVY TRAFFIC
                      // ==================================================

                      _ReasonTile(
                        text: 'Heavy traffic',
                        value: 'Heavy traffic',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),

                      // ==================================================
                      // VEHICLE ISSUE
                      // ==================================================

                      _ReasonTile(
                        text: 'Vehicle issue',
                        value: 'Vehicle issue',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),

                      // ==================================================
                      // GOING OFFLINE
                      // ==================================================

                      _ReasonTile(
                        text: 'Going offline',
                        value: 'Going offline',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),

                      // ==================================================
                      // PERSONAL REASON
                      // ==================================================

                      _ReasonTile(
                        text: 'Personal reason',
                        value: 'Personal reason',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),

                      // ==================================================
                      // OTHER REASON
                      // ==================================================

                      _ReasonTile(
                        text: 'Other reason',
                        value: 'Other reason',
                        selectedReason: selectedReason,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,

                        onSelected: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),

                      // ============================================================


// ============================================================
// BOTTOM SPACE
// ============================================================

                      SizedBox(
                        height: screenHeight * 0.012,
                      ),
                    ],
                  ),


                  // ==================================================
                  // API / NAVIGATION SPACE
                  // ==================================================

                  // IMPORTANT:
                  // We will replace this section later with:
                  //
                  // 1. Submit button
                  // 2. API call
                  // 3. Navigation
                  //
                  // DO NOT ADD API CODE NOW.

                  // ==================================================
// SUBMIT BUTTON
// ==================================================

                  // ==================================================
// SMALL RESPONSIVE SUBMIT BUTTON
// ==================================================

                  SizedBox(
                    width: double.infinity,

                    height: isDesktop
                        ? 45.0
                        : isTablet
                        ? 48.0
                        : (screenHeight * 0.058)
                        .clamp(44.0, 50.0),

                    child: ElevatedButton(
                      onPressed: () {

                        // ==================================================
                        // CHECK WHETHER A REASON IS SELECTED
                        // ==================================================

                        if (selectedReason == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select a reason',
                              ),
                            ),
                          );

                          return;
                        }

                        // ==================================================
                        // SELECTED REASON
                        // ==================================================

                        final String reason = selectedReason!;

                        // ==================================================
                        // API PLACEHOLDER
                        // ==================================================

                        debugPrint(
                          'Selected rejection reason: $reason',
                        );

                        // ==================================================
                        // CLOSE SHEET
                        // ==================================================

                        Navigator.of(context).pop();

                        // ==================================================
                        // NAVIGATION WILL COME HERE AFTER API
                        // ==================================================
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B30),

                        foregroundColor: Colors.white,

                        elevation: 1,

                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      child: Text(
                        'Submit',

                        style: TextStyle(
                          fontFamily: 'Inter',

                          fontSize: isDesktop
                              ? 15.0
                              : isTablet
                              ? 17.0
                              : (screenWidth * 0.042)
                              .clamp(15.0, 18.0),

                          fontWeight: FontWeight.w600,

                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),


// ==================================================
// BOTTOM SAFE SPACE
// ==================================================

                  SizedBox(
                    height:
                    MediaQuery.of(context)
                        .padding
                        .bottom +
                        12,
                  ),

                ],
              ),
            ),
        ),
        );
      },
    );
  }
}
// ================================================================
// RESPONSIVE REASON TILE
// ================================================================

class _ReasonTile extends StatelessWidget {
  final String text;
  final String value;
  final String? selectedReason;

  final double screenWidth;
  final double screenHeight;

  final ValueChanged<String> onSelected;

  const _ReasonTile({
    required this.text,
    required this.value,
    required this.selectedReason,
    required this.screenWidth,
    required this.screenHeight,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {

    // ============================================================
    // RESPONSIVE SCREEN TYPES
    // ============================================================

    final bool isDesktop =
        screenWidth >= 900;

    final bool isTablet =
        screenWidth >= 600 &&
            screenWidth < 900;


    // ============================================================
    // RESPONSIVE TILE HEIGHT
    // ============================================================

    final double tileHeight =
    isDesktop
        ? 46
        : isTablet
        ? 48
        : (screenHeight * 0.058)
        .clamp(44.0, 50.0);


    // ============================================================
    // RESPONSIVE TEXT SIZE
    // ============================================================

    final double textSize =
    isDesktop
        ? 14
        : isTablet
        ? 17
        : (screenWidth * 0.040)
        .clamp(14.0, 17.0);


    // ============================================================
    // RESPONSIVE RADIO SIZE
    // ============================================================

    final double radioSize =
    isDesktop
        ? 22
        : isTablet
        ? 25
        : (screenWidth * 0.065)
        .clamp(22.0, 26.0);


    // ============================================================
    // CHECK WHETHER SELECTED
    // ============================================================

    final bool isSelected =
        selectedReason == value;


    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          onSelected(value);
        },

        borderRadius:
        BorderRadius.circular(18),

        child: Container(

          width: double.infinity,

          height: tileHeight,

          padding: EdgeInsets.symmetric(
            horizontal: isDesktop
                ? 25
                : isTablet
                ? 22
                : screenWidth * 0.045,
          ),

          decoration: BoxDecoration(

            // Same light background style
            // as your screenshot.
            color: const Color(0xFFF8F3FA),

            borderRadius:
            BorderRadius.circular(18),

            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [

              // ==================================================
              // RADIO BUTTON
              // ==================================================

              SizedBox(
                width: radioSize,
                height: radioSize,

                child: Radio<String>(
                  value: value,

                  groupValue:
                  selectedReason,

                  onChanged: (newValue) {

                    if (newValue != null) {
                      onSelected(newValue);
                    }
                  },

                  activeColor:
                  const Color(0xFF7650B8),

                  materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,

                  visualDensity:
                  VisualDensity.compact,
                ),
              ),

              // ==================================================
              // SPACE BETWEEN RADIO + TEXT
              // ==================================================

              SizedBox(
                width: isDesktop
                    ? 28
                    : isTablet
                    ? 24
                    : screenWidth * 0.06,
              ),

              // ==================================================
              // REASON TEXT
              // ==================================================

              Expanded(
                child: Text(
                  text,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    fontFamily: 'Inter',

                    fontSize: textSize,

                    fontWeight:
                    FontWeight.w400,

                    color: Colors.black,
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