import 'package:flutter/material.dart';

class AppFunctions {
  static showSnackbar(BuildContext context, String text)=> ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      )
    )
  );
}

