import 'package:flutter/material.dart';

class Specialization {
  final String name, imageUrl;
  final int count;
  final MaterialColor color;

  Specialization({required this.count, required this.color, required this.name, required this.imageUrl});

  Specialization.dummy(this.color, this.name):
    count= 212,
    imageUrl= 'assets/images/cardio.png';
  
}