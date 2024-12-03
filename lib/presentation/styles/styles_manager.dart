part of 'styles.dart';

class TextStylesManager {
  /// Thin TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getThinStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14, FontWeightConstants.thin,
          color ?? AppColors.black);

  /// light TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getLightStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14,
          FontWeightConstants.light, color ?? AppColors.black);

  /// regular TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getRegularStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14,
          FontWeightConstants.regular, color ?? AppColors.black);

  /// Medium TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getMediumStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14,
          FontWeightConstants.medium, color ?? AppColors.black);

  /// bold TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getBoldStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14, FontWeightConstants.bold,
          color ?? AppColors.black);

  /// black TextStyle
  ///
  ///  Default values if not givin
  ///  ```dart
  /// fontSize = FontSizeConstants.s14
  /// color = ColorConstants.black
  /// ```
  ///
  static TextStyle getBlackStyle({double? fontSize, Color? color}) =>
      _getTextStyle(fontSize ?? FontSizeConstants.s14,
          FontWeightConstants.black, color ?? AppColors.black);

  static TextStyle _getTextStyle(
          double fontSize, FontWeight fontWeight, Color color) =>
      TextStyle(
          fontSize: fontSize,
          fontFamily: FontConstants.fontFamilyLato,
          color: color,
          fontWeight: fontWeight);
}
