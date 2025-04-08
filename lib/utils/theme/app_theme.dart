import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:magic_insta/utils/widgets/custom_outlined_input_border.dart";

class AppTheme {
  static Color get orangeColor => const Color(0xffF58383);
  static Color get primararyColor => const Color(0xff8E4E9F);
  static Color get greenColor => const Color(0xff3CB975);
  static Color get darkPurple => const Color(0xff270A2D);

  static TextTheme get textTheme => TextTheme(
      headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.poppins(color: const Color(0xffBFB5C1)));

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      border: const CustomOutlinedInputBorder(),
      disabledBorder: CustomOutlinedInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: CustomOutlinedInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: CustomOutlinedInputBorder(
          borderSide: BorderSide(color: primararyColor, width: 2)),
      labelStyle: GoogleFonts.poppins(fontSize: 13));

  static List<Color> get primararyGradientColors => [
        const Color(0xff7A2291),
        const Color(0xffFF4B8B),
      ];

  static ChipThemeData get chipTheme => ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      side: BorderSide(color: Colors.grey.shade200));
}
