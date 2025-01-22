import 'package:flutter/material.dart';
import 'styles/style.dart';
import 'widgets/order_system.dart';

void main() {
  runApp(const McdonaldsApp());
}

class McdonaldsApp extends StatelessWidget {
  const McdonaldsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.lightTheme,
      home: const OrderSystem(),
    );
  }
}