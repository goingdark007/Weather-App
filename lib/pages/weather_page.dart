import 'package:flutter/material.dart'; // Importing material design widgets of flutter
import 'package:flutter6_weather_app/utilities/custom_column.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart'; // Importing our weather model
import '../services/weather_service.dart';
import '../utilities/custom_container.dart';
import '../utilities/custom_stack.dart'; // Importing our weather service

/// Creating a stateful widget
class WeatherPage extends StatefulWidget {

  // public classes need a constructor key for optimization or to identify widgets.
  const WeatherPage({super.key});

  /// Overriding or replacing flutters parent classes state with our own defined state
  @override
  State<WeatherPage> createState() => _WeatherPageState();

}

/// Creating a state class where the code will be written for the state of the widget
class _WeatherPageState extends State<WeatherPage> {


  // Creating private object of WeatherService class to pass the API key to it.
  final _weatherService = WeatherService();
  // Declaring a variable named _weather that will hold a Weather object (from our model).
  // The ? means it can be null — maybe the weather hasn’t been fetched yet.
  // Note we can't directly return anything from an async future function that's why we define
  // an object globally and use setState to update the UI with new value
  Weather? _weather;
  bool isLoading = true;

  /// Variable for storing the cityName from the Future string function
  String? cityName;

  List<List<dynamic>> hourlyList =  [];

  List<List<dynamic>> dailyList = [];

  /// fetch weather
  Future<void> _fetchWeather() async {

    /// get the latitude and longitude of the location
    String coordinates = await _weatherService.getCurrentCity();

    /// get the weather for city
    try{
      // gets the weather from the _weatherService object for the city name
      final weather = await _weatherService.getWeather(coordinates);

      final city = await _weatherService.getCurrentCityName(coordinates);

      // ✅ ensure widget is still active
      if (!mounted) return; // stops the function

      // setState rebuilds the state and sets the fetched weather object to  current _weather object
      setState(() {
        _weather = weather;
        hourlyList = _weather!.hourlyData;
        dailyList = _weather!.dailyData;
        cityName = city;
        isLoading = false;
      });
      // to catch any error if weather is not fetched
    } catch(e){

      // ✅ ensure widget is still active
      if (!mounted) return;

      // Shows a snackBar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );
    }

  }


  /// Function for weather animations
  String getWeatherAnimation(String? mainCondition) {

    if (mainCondition == null){
      // By default its sunny
      return 'assets/sunny.json';
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
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      /// if no case is matched default runs and returns a string for sunny animation
      default:
        return 'assets/sunny.json';
    }

  }


  /// initState
  @override
  void initState() {
    super.initState();
    // fetch weather on start up
    _fetchWeather();

  }

  /// build

  /// Overriding flutters parent classes build method with our own defined build method
  @override
  /// This widget is the WeatherPage of our application.
  // Widget build is a method that returns a widget and  BuildContext is an object that
  // gives access to the location of this widget in the widget tree, used to access theme
  // data (theme.of(context), navigation (Navigator.of(context)), find inherited widgets
  Widget build(BuildContext context) {

    // final List<List<dynamic>> hourlyList = _weather?.hourlyData ?? [];
    //
    // final List<List<dynamic>> dailyList = _weather?.dailyData ?? [];

    /// Scaffold is the basic page layout for material apps.
    // Gives the screen a structure with appBar, body, bottomNavigationBar etc.
    return Scaffold(

      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 8,
        // Sets the background color of the app bar
        // Using .inversePrimary our AppBar background will adapt automatically to look
        // good in both light and dark modes without us needing to hardcode colors.
        backgroundColor: const Color(0xFF0d1d2a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3)
        ),
        shadowColor: Colors.black45,
      ),

      body: isLoading ? Center(child: CircularProgressIndicator()): SingleChildScrollView(

        child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                const SizedBox(height: 10),

                buildTopCard(context),

                const SizedBox(height: 10),

                buildGrid(),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 18),
                    const Text('Hourly Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),

                buildHourly(),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    const Text('7-day Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),

                buildDaily(),

                const SizedBox(height: 10),

                const Text('Developed by Nazmul', style: TextStyle( fontFamily: 'Arial' ,fontWeight: FontWeight.bold, fontSize: 25,color: Colors.white)),

                const SizedBox(height: 15)

              ],
            ),
      ),


    );
  }

  Padding buildDaily() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          clipBehavior: Clip.antiAlias,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dailyList.length,
            itemBuilder: (context, index) {

              return CustomStack(
                date: dailyList[index][0],
                temp: dailyList[index][1],
                weatherCondition: dailyList[index][2],
              );

              },
          )
      ),
    );
  }

  Padding buildHourly() {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      alignment: Alignment.center,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF0d1d2a).withValues(alpha: 0.8),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: hourlyList.length,
          itemBuilder: (context, index) {

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomColumn(
                    time: hourlyList[index][0],
                    weatherCondition: hourlyList[index][1],
                    temp:  hourlyList[index][2]
                ),
              );
          }

      ),
    ),
    );
  }

  GridView buildGrid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(9.0),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [

        CustomContainer(
          conditionName: 'Wind Speed',
          conditionData: '${_weather?.windSpeed} m/s',
          conditionLottie: 'assets/windy.json',
        ),
        CustomContainer(
          conditionName: 'Humidity',
          conditionData: '${_weather?.humidity}%',
          conditionLottie: 'assets/humidity.json',
        ),


      ],

    );
  }

  Padding buildTopCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: Stack(

        children: [

          Card(

            elevation: 4,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            child: Container(

              height: 220,

              width: double.maxFinite,

              decoration: BoxDecoration(
                color: const Color(0xFF0d1d2a),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Positioned(

            top: 40,

            left: 20,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.max,

              children: [

                /// City name
                Text(
                    cityName ?? 'Loading city',
                    style:  Theme.of(context).textTheme.displayMedium
                ),

                const SizedBox(height: 22),

                /// Temperature
                Text(
                    '${_weather?.temperature.round()}°C',
                    style: Theme.of(context).textTheme.displayLarge
                ),

                const SizedBox(height: 22),

                Text('High: ${_weather?.highestTemp.round()}°C . Low: ${_weather?.lowestTemp.round()}°C',
                  style: Theme.of(context).textTheme.bodyLarge,
                )


              ],
            ),

          ),

          Positioned(

            top: 40,

            right: 20,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.end,

              mainAxisSize: MainAxisSize.min,

              children: [

                /// Weather condition
                Text(
                    _weather?.conditionDescription ?? 'Loading weather',
                    style: Theme.of(context).textTheme.displayMedium
                ),

                /// Weather animation
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),

                  ),
                ),

                /// Feels like temperature
                Text(
                    'Feels like ${_weather?.feelsLikeTemp.round()}°C',
                    style: Theme.of(context).textTheme.displaySmall
                ),

              ],

            ),

          )

        ],

      ),

    );

  }

}
