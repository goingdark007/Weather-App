import 'package:flutter/material.dart';
import 'package:flutter6_weather_app/utilities/custom_icon.dart';

class CustomStack extends StatelessWidget {

  final String date;

  final String temp;

  final String weatherCondition;

  const CustomStack({
    super.key,
    required this.temp,
    required this.date,
    required this.weatherCondition
  });

  /// Function for weather icon
  IconData getWeatherIcon(String? mainCondition) {

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [ Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0d1d2a).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
          Positioned(
            top: 12,
            left: 10,
            child: Text(date, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),

          Positioned(
              top: 12,
              right: 130,
              child: Icon(CustomIconAndColor.getWeatherIcon(weatherCondition), color: CustomIconAndColor.getWeatherColor(weatherCondition)),
          ),

          Positioned(
              top: 12,
              right: 10,
              child: Text(temp, style: const TextStyle(fontSize: 18, color: Colors.white)),
          )

        ]
      ),
    );
  }
}