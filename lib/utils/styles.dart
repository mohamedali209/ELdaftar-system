import 'package:aldafttar/utils/sizeconfig.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';

class Appstyles {
  static ArabicTextStyle bold50(BuildContext context) {
    return ArabicTextStyle(
        arabicFont: ArabicFont.arefRuqaa,
        color: Colors.white,
        fontSize: getResponsiveFontSize(context, fontSize: 45),
        fontWeight: FontWeight.bold);
  }

  static ArabicTextStyle regular25(BuildContext context) {
    return ArabicTextStyle(
        arabicFont: ArabicFont.lateef,
        color: Colors.white,
        fontSize: getResponsiveFontSize(context, fontSize: 25));
  }

  static ArabicTextStyle regular12cairo(BuildContext context) {
    return ArabicTextStyle(
        arabicFont: ArabicFont.cairo,
        fontSize: getResponsiveFontSize(context, fontSize: 12));
  }

  static TextStyle numheader(BuildContext context) {
    return const TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 32);
  }

  static ArabicTextStyle daftartodayheader(BuildContext context) {
    return const ArabicTextStyle(
        arabicFont: ArabicFont.cairo, fontSize: 12, color: Colors.amber);
  }
}

double getResponsiveFontSize(context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  double lowerLimit = fontSize * .8;
  double upperLimit = fontSize * 1.2;

  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

double getScaleFactor(context) {
  // var dispatcher = PlatformDispatcher.instance;
  // var physicalWidth = dispatcher.views.first.physicalSize.width;
  // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
  // double width = physicalWidth / devicePixelRatio;

  double width = MediaQuery.sizeOf(context).width;
  if (width < SizeConfig.tablet) {
    return width / 550;
  } else if (width < SizeConfig.desktop) {
    return width / 1000;
  } else {
    return width / 1920;
  }
}
