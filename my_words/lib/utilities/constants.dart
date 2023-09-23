import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstantsColor {
  static const Color primaryBackGroundColor = Color(0xffD1EAF5);
  static const Color primaryColor=Color(0xffEAF9E3);
  static const Color mainColor=Color(0xffFFD6DA);
  static const Color darkerMainColor=Color(0xffFFC6D0);
}

class ConstantsStyle {
  static final TextStyle headingStyle = GoogleFonts.beVietnamPro(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 22,
  );
  static final TextStyle primaryTextStyle= GoogleFonts.beVietnamPro(
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 20,
  );
  static final TextStyle secondaryTextStyle = GoogleFonts.beVietnamPro(
    fontSize: 16,
    color: Colors.black,
    //fontWeight: FontWeight.w500,
  );
  
}
