import 'package:ezsaju/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'constants/themes.dart';

void main() {
  runApp(const EZSajuApp());
}

class EZSajuApp extends StatelessWidget {
  const EZSajuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZ-Saju',
      theme: lightTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
