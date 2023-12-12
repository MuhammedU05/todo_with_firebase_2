import 'package:flutter/material.dart';

class ThemeProviderClass extends ChangeNotifier {
  ThemeData _currentTheme = _getCurrentTheme();
  IconThemeData _currentIconTheme = _getCurrentIconTheme();

  ThemeData get currentTheme => _currentTheme;

  IconThemeData get iconTheme => _currentIconTheme;

  void updateTheme() {
    _currentTheme = _getCurrentTheme();
    _currentIconTheme = _getCurrentIconTheme();
    notifyListeners();
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // Define your light theme here
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // Define your dark theme here
  );

  static const IconThemeData _lightIconTheme = IconThemeData(
    // Define your light icon theme here
    color: Colors.black,
  );

  static const IconThemeData _darkIconTheme = IconThemeData(
    // Define your dark icon theme here
    color: Colors.white,
  );

  static _getCurrentTheme() {
    // Get the current time
    DateTime now = DateTime.now();

    // Define your start and end times for light and dark mode
    DateTime startTime =
        DateTime(now.year, now.month, now.day, 2, 37); // Adjust the start time
    DateTime endTime =
        DateTime(now.year, now.month, now.day, 2, 38); // Adjust the end time

    // Check if the current time is within the specified range
    bool isDayTime = now.isAfter(startTime) && now.isBefore(endTime);

    return
        isDayTime
        ?
        lightTheme
        :
        darkTheme
        ;
  }

  static _getCurrentIconTheme() {
    // Get the current time
    DateTime now = DateTime.now();

    // Define your start and end times for light and dark mode
    DateTime startTime =
        DateTime(now.year, now.month, now.day, 2, 20); // Adjust the start time
    DateTime endTime =
        DateTime(now.year, now.month, now.day, 20, 0); // Adjust the end time

    // Check if the current time is within the specified range
    bool isDayTime = now.isAfter(startTime) && now.isBefore(endTime);

    return 
        isDayTime 
        ? 
        _lightIconTheme 
        : 
        _darkIconTheme
        ;
  }
}
