import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
const Color bluish= Color(0xFF4e5ae8);
const Color yellow= Color(0xFFFFB746);
const Color pink= Color(0xFFff4667);
const Color white= Colors.white;
const Color primary= bluish;
const Color darkGreyClr= Color(0xFF121212);
const Color darkHeader= Color(0xFF424242);
class Themes{
  static final ligth= ThemeData(
    backgroundColor: Colors.white,
  primaryColor: primary,
  brightness: Brightness.light,
  );
  static final dark= ThemeData(
    backgroundColor:darkGreyClr,
  primaryColor: darkGreyClr,
  brightness: Brightness.dark,
  );
}


TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.grey[400]:Colors.grey
      )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
      )
  );
}