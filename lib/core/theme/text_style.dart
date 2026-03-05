import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title18BoldPlusJakartaSans => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
  );

  TextStyle get title16MediumPlusJakartaSans => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.gray_900_01,
  );

  TextStyle get title16RegularPlusJakartaSans => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.gray_600,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15RegularInter => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: appTheme.gray_700,
  );

  TextStyle get body14BoldPlusJakartaSans => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
  );

  TextStyle get body14RegularPlusJakartaSans => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.green_600_01,
  );

  TextStyle get body13RegularInter => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: appTheme.gray_500_01,
  );

  TextStyle get body13SemiBoldInter => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_700_01,
  );

  TextStyle get body12SemiBoldInter => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_400_02,
  );

  TextStyle get body12MediumPlusJakartaSans => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Plus Jakarta Sans',
  );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label11SemiBoldInter => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.green_300,
  );

  TextStyle get label11LightInter => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    fontFamily: 'Inter',
    color: appTheme.gray_500_02,
  );

  TextStyle get label10LightInter => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    fontFamily: 'Inter',
    color: appTheme.gray_500,
  );

  TextStyle get label10SemiBoldInter => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_400,
  );

  TextStyle get label9SemiBoldInter => TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.orange_300,
  );
}

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}