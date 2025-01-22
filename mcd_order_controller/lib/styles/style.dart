import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFFBF0C0C); 
  static const Color secondaryColor = Color(0xFFFFC800); 
  static const Color backgroundColor = Color(0xFFFFF8E1); 
  static const Color vipOrderColor = Color(0xFFFFECB3); 
  static const Color normalOrderColor = Colors.white; 
  static const Color botIdleColor = Color(0xFFEEEEEE);
  static const Color botProcessingColor = Color(0xFFC8E6C9); 
  
  // Text Styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle botTextStyle = TextStyle(
    fontSize: 12,
  );

  static const TextStyle orderStatusTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black45,
  );

  // Elevated Button Style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.black,
    textStyle: const TextStyle(fontSize: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Card Decoration
  static BoxDecoration cardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
      ],
    );
  }
}

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppStyles.primaryColor,
      scaffoldBackgroundColor: AppStyles.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppStyles.primaryColor,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppStyles.backgroundColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppStyles.elevatedButtonStyle,
      ),
    );
  }
}
