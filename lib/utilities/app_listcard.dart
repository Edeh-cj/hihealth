import 'package:flutter/material.dart';
import 'package:hihealth/models/user_doctor.dart';

Widget appListCard (UserDoctor user)=> Container(
  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
  constraints: BoxConstraints.tight(const Size(double.maxFinite, 105)),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(9),
    border: Border.all(color: const Color.fromRGBO(234, 234, 234, 1))
  ),
);