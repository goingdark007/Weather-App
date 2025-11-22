import 'package:flutter/material.dart';
import 'package:flutter6_weather_app/utilities/custom_icon.dart';

class CustomColumn extends StatelessWidget {

  final String time;
  final String weatherCondition;
  final String temp;

  const CustomColumn ({
    super.key,
    required this.time,
    required this.weatherCondition,
    required this.temp
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(time, style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 14),
          Icon(CustomIconAndColor.getWeatherIcon(weatherCondition), color: CustomIconAndColor.getWeatherColor(weatherCondition)),
          const SizedBox(height: 14),
          Text('$temp°C', style: const TextStyle(fontSize: 18, color: Colors.white)),
        ]
      ),
    );
  }

}