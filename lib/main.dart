import 'package:flutter/material.dart'; // Importing material design widgets of flutter
import 'package:flutter6_weather_app/pages/weather_page.dart'; // Importing flutter_dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importing our WeatherPage

/// The main function of dart
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  // runs our app and const is for optimization
  runApp(const MyApp());
}

/// Creating a stateless widget
class MyApp extends StatelessWidget {

  // public classes need a constructor key for optimization or to identify widgets.
  const MyApp({super.key});

  /// Overriding flutters parent classes build method with our own defined build method
  @override
  /// This widget is the root of our application.
  // Widget build is a method that returns a widget and  BuildContext is an object that
  // gives access to the location of this widget in the widget tree, used to access theme
  // data (theme.of(context), navigation (Navigator.of(context)), find inherited widgets
  Widget build(BuildContext context) {

    /// Returns a material app which is the starting point of any app in flutter that uses material design
    return MaterialApp(
      // Sets the title of the material app
      title: 'Weather Demo',
      // Disables the demo banner at the top of the app
      debugShowCheckedModeBanner: false,
      // Defines ThemeData of the material app which can be used by theme.of(context)
      theme: ThemeData(
        // ColorScheme is a set of colors for themeData and .fromSeed() to take the
        // color palette of deepPurple
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 50
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
          displaySmall: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),

        ),

        scaffoldBackgroundColor: const Color(0xFF24323f)

      ),
      // First screen to show is WeatherPage
      home: const WeatherPage(),
    );

  }

}