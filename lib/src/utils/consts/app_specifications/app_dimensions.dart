import 'package:flutter/material.dart';

class AppDimensions {
  //Size in logical pixels
  static var pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

  static var logicalScreenSize = WidgetsBinding.instance.window.physicalSize / pixelRatio;
  static var logicalWidth = logicalScreenSize.width;
  static var logicalHeight = logicalScreenSize.height;
  
  // ---------------------- Screen Dimensions ----------------------
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  // ---------------------- Padding & Margin ----------------------
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // ---------------------- Border Radius ----------------------
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;
  
  // ---------------------- Icon Sizes ----------------------
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // ---------------------- Button Dimensions ----------------------
  static const double buttonHeight = 48.0;
  static const double buttonRadius = 8.0;
  
 // ---------------------- SIZE FOR SPACE ----------------------
   static double sizeboxHeight40 = logicalHeight/20.7272;
    static double sizeboxHeight30 = logicalHeight/27.6363;
     static double sizeboxHeight20 = logicalHeight/41.4545;
    static double sizeboxHeight15 = logicalHeight/55.2727;
    static double sizeboxHeight10 = logicalHeight/82.9090;
    
    
    static double sizeboxWidth65 = logicalWidth/6.0461;
    static double sizeboxWidth10 = logicalWidth/39.2722;
    
}