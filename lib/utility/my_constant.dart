import 'dart:ui';

import 'package:flutter/material.dart';

class MyConstant {
  static String urlapi = 'http://192.168.0.205:8081/api';
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
  //Color

  static Color primary = Color(0xff02a9f4);
  static Color dark = Color(0xff007ac1);
  static Color light = Color(0xff67daff);

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
