import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle get doctorCardDetail => const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10
  );
  static TextStyle get doctorCardName => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700
  );
  static TextStyle get doctorCategoryName => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Colors.white
  );
  static TextStyle get doctorCategoryDetail => const TextStyle(
    color: Colors.white,
    fontSize: 10
  );
}