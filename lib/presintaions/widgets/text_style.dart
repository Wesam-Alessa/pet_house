// ignore_for_file: prefer_const_constructors

import 'package:animal_house/core/utills/dimensions.dart';
import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();
  static final TextStyle appNameTextStyle = TextStyle(
      fontSize: Dimensions.font26,
      //26,
      fontWeight: FontWeight.w800,
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Ubuntu');
  static final TextStyle tageLineStyle = TextStyle(
      fontSize: Dimensions.font12,
      // 12,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle bigHeadingTextStyle = TextStyle(
      fontSize: Dimensions.font20 * 2.5,
      //50,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle bodyTextStyle = TextStyle(
      fontSize: Dimensions.font14,
      //14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle enjoyTextStyle = TextStyle(
      fontSize: Dimensions.font18,
      // 18,
      fontWeight: FontWeight.w900,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle headingText = TextStyle(
      fontSize: Dimensions.font20,
      // 22,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle subscriptionAmountTextStyle = TextStyle(
      fontSize: Dimensions.font26,
      //26,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle subscriptionTitleTextStyle = TextStyle(
      fontSize: Dimensions.font20,
      // 20,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle titleTextStyle = TextStyle(
      fontSize: Dimensions.font12 * 2,
      //24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontFamily: 'Ubuntu');
  static final TextStyle body2TextStyle = TextStyle(
      fontSize: Dimensions.font16,
      // 16,
      letterSpacing: 1.3,
      fontWeight: FontWeight.w400,
      color: Colors.white.withOpacity(0.5),
      fontFamily: 'Ubuntu');
  static final TextStyle body3TextStyle = TextStyle(
      fontSize: Dimensions.font12,
      //12,
      fontWeight: FontWeight.w300,
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Ubuntu');

  static final TextStyle cardSubTitleTextStyle = TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Ubuntu');

  static final TextStyle cardSubTitleTextStyle2 = TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w600,
      color: Colors.white.withOpacity(0.8),
      fontFamily: 'Ubuntu');
}
