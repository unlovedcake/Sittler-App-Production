import 'package:flutter/material.dart';

class ServicesTypesOfDoctor {
  static List<Map<String, dynamic>> gender = [
    {
      'value': "Female",
      'label': "Female",
      'icon': const Icon(Icons.stop),
    },
    {
      'value': "Male",
      'label': "Male",
      'icon': const Icon(Icons.adjust),
      'textStyle': const TextStyle(color: Colors.orange),
    },
  ];
}
