import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '').toUpperCase();

  if (hex.length == 6) {
    // If no alpha is provided, assume fully opaque
    hex = 'FF$hex';
  } else if (hex.length == 3) {
    // Handle short form like 'FFF'
    hex = 'FF${hex.split('').map((c) => '$c$c').join()}';
  }

  return Color(int.parse(hex, radix: 16));
}

class AppColors {
  static Color white = Colors.white;
  static Color offWhite = hexToColor('F5F5F5');
  static Color whiteStroke = hexToColor('5E5E5E').withAlpha(20);
  static Color offWhiteText = hexToColor('5E5E5E').withAlpha(90);
  static Color blue = hexToColor('00A3FF');
  static Color text = hexToColor('5F5F5F');
}
