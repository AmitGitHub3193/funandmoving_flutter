import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme sTextTheme(theme, [language = 'en']) {
  switch (language) {
    case 'en':
      return GoogleFonts.firaSansTextTheme(theme);
    default:
      return GoogleFonts.firaSansTextTheme(theme);
  }
}

TextTheme sHeadLineTheme(theme, [language = 'en']) {
  switch (language) {
    case 'en':
      return GoogleFonts.firaSansTextTheme(theme);
    default:
      return GoogleFonts.firaSansTextTheme(theme);
  }
}