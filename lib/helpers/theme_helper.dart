import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorConstant {
  static const Color dodgerBlue = Color(0xff00BBFF);
  static const Color deepBlue = Color(0xff102A83);
  static Color lightBlue = Colors.lightBlue[100];
  static const Color white = Colors.white;
}

class MyKeys {
  static String apiKey = "8wu76m5Vz1eYGpkF224C5nA1klafosCJ";
}

class DummyPhotos {
  static const profilePic =
      "https://az-pe.com/wp-content/uploads/2018/05/kemptons-blank-profile-picture.jpg";
}

class AppTheme {
  get lightTheme => ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: ColorConstant.deepBlue,
      accentColor: ColorConstant.dodgerBlue,
      accentColorBrightness: Brightness.dark,
      iconTheme: IconThemeData(color: ColorConstant.deepBlue),
      scaffoldBackgroundColor: ColorConstant.white,
      dividerTheme: DividerThemeData(space: 5),
      textTheme: TextTheme(
          headline1: GoogleFonts.nunitoSans(fontSize: 28, color: Colors.black),
          headline2: GoogleFonts.poppins()));
}

class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
