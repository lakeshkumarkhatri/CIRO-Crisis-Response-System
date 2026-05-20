import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(CIROApp());

class CIROApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CIRO Crisis Response',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}