import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle poppinStyle({double? fontSize, FontWeight? fontWeight, Color? color}) {
  return GoogleFonts.poppins(
    fontSize: fontSize ?? 18,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? Colors.black,
  );
}
