import 'package:flutter/material.dart';

class CustomIconAndColor {

  /// Function for weather icon
  static IconData getWeatherIcon(String? mainCondition) {

    if (mainCondition == null){
      // By default its sunny
      return Icons.wb_sunny;
    }

    // to check weather condition and  .toLowerCase method used to convert it to lower case
    switch (mainCondition.toLowerCase()){
    /// if one of these cases match returns string for cloudy animation
    // break isn't needed in dart it stops automatically
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return Icons.wb_cloudy;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.cloudy_snowing;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'clear':
        return Icons.wb_sunny;
    /// if no case is matched default runs and returns a string for sunny animation
      default:
        return Icons.wb_sunny;
    }

  }

  static Color getWeatherColor(String? mainCondition) {

    IconData icon = getWeatherIcon(mainCondition);

    switch (icon) {
      case Icons.wb_sunny:
        return Colors.yellow;
      case Icons.cloudy_snowing:
        return Colors.grey;
      case Icons.thunderstorm:
        return Colors.grey;
      case Icons.wb_cloudy:
        return Colors.white;
      default:
        return Colors.white;
    }

  }

}