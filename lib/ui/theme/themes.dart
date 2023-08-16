import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* 
An outline of Theme classes to be used within the TicketWallet Mobile App.
Eventually, should include dark theme as well, but for now contains just defualt
theme.
*/

// define useful colors, can be altered as seen fit
Color primary = const Color(0xFF0A1158);
Color accent1 = const Color(0xFF625BF6);
Color accent2 = const Color(0xFF6B95FF);
Color surface = const Color(0xFF606060);
Color error = const Color(0xFFFF6961);
Color offwhitebackground = const Color(0xFFFAFEFF);
String goldman = GoogleFonts.goldman().fontFamily!;

// define overall default theme, possible dark theme added later
// No default button themes are defined directly, but attempt to
// use a borderradius of either 11 or 25 for consinstency.
ThemeData defaultTheme = ThemeData(
  scaffoldBackgroundColor: offwhitebackground,
  disabledColor: surface,
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      primaryContainer: primary,
      onPrimary: Colors.white,
      secondary: accent1,
      secondaryContainer: accent1,
      onSecondary: Colors.white,
      tertiary: accent2,
      tertiaryContainer: accent2,
      onTertiary: Colors.white,
      error: error,
      onError: Colors.white,
      background: offwhitebackground,
      onBackground: primary,
      surface: surface,
      onSurface: Colors.white),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: primary, fontFamily: goldman),
    displayMedium: TextStyle(color: primary, fontFamily: goldman),
    displaySmall: TextStyle(color: primary, fontFamily: goldman),
    bodyLarge: TextStyle(color: primary, fontFamily: goldman),
    bodyMedium: TextStyle(color: primary, fontFamily: goldman),
    bodySmall: TextStyle(color: primary, fontFamily: goldman),
    titleLarge: TextStyle(color: primary, fontFamily: goldman),
    titleMedium: TextStyle(color: primary, fontFamily: goldman),
    titleSmall: TextStyle(color: primary, fontFamily: goldman),
    labelLarge: TextStyle(color: primary, fontFamily: goldman),
    labelMedium: TextStyle(color: primary, fontFamily: goldman),
    labelSmall: TextStyle(color: primary, fontFamily: goldman),
  ),
  // Still required to set headline fonts, which are rarely used in mobile
  fontFamily: GoogleFonts.goldman().fontFamily,
);
