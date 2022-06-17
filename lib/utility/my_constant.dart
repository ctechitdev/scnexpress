import 'dart:ui';

import 'package:flutter/material.dart';

class MyConstant {
  static String urlapi = 'http://149.129.55.90:1005/api';
  // General
  static String appName = 'SCNG Express';
  // Route
  static String routeAuth = '/authen';
  static String routCreateAccount = '/createAccount';
  static String routeRiderService = '/riderService';
  static String routeStaffService = '/staffServie';
  static String routeMerchantService = '/merchantService';
  static String rountCheckRecieve = '/checkRecieve';

  // Image

  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String imgicon = 'images/scnexpress.jpg';
  //Color

  static Color primary = Color(0xFFFF6F00);
  static Color dark = Color(0xFFFF9800);
  static Color light = Color(0xFFFFC10F);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 255, 152, 0.1),
    100: Color.fromRGBO(255, 255, 152, 0.2),
    200: Color.fromRGBO(255, 255, 152, 0.3),
    300: Color.fromRGBO(255, 255, 152, 0.4),
    400: Color.fromRGBO(255, 255, 152, 0.5),
    500: Color.fromRGBO(255, 255, 152, 0.6),
    600: Color.fromRGBO(255, 255, 152, 0.7),
    700: Color.fromRGBO(255, 255, 152, 0.8),
    800: Color.fromRGBO(255, 255, 152, 0.9),
    900: Color.fromRGBO(255, 255, 152, 1.0),
  };

  //style

  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2StylePrimary() => TextStyle(
        fontSize: 18,
        color: Colors.orange,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2WhiteStyle() => TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3WhiteStyle() => TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
      primary: MyConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ));
}
