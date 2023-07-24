import 'package:clima_weather/components/error_message.dart';
import 'package:clima_weather/models/weather_models.dart';
import 'package:clima_weather/services/weather.dart';
import 'package:clima_weather/utilities/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/details_widget.dart';
import 'package:clima_weather/components/loading_widget.dart';
import 'package:clima_weather/utilities/constants.dart';
import '../models/themes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isDataLoaded = false;
  bool isErrorOccurd = false;
  double? latitude;
  double? longitude;
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  LocationPermission? permission;
  WeatherModel? weatherModel;
  int code = 0;
  Weather weather = Weather();
  var weatherData;
  String? title, message;
  bool iconModeStatus = true;
  Icon iconMode = Icon(
    Icons.nights_stay,
    color: kMidLightColor,
  );

  @override
  void initState() {
    super.initState();
    getPremission();
  }


  ///# GetPremission
  ///
  /// this function will check if app has accses to gps and if the app doesn't 
  /// have accses to gps, it will get the premission from user.
  void getPremission() async {
    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission != LocationPermission.denied) {
        if (permission == LocationPermission.deniedForever) {
        } else {
          getLocation();
        }
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }
  }

  ///# GetLocation
  /// 
  /// this function will do two things:
  /// 1. it will check if app have accses to user current location. 
  /// 2. it will get all the data that app need from [getLocationWeather] function.
  void getLocation() async {
    if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      setState(() {
        isErrorOccurd = true;
        isDataLoaded = true;
        title = "Location is turned off";
        message =
            "Please enable the location service to see weather condition for your location";
        return;
      });
    }
    weatherData = await weather.getLocationWeather();
    code = weatherData["weather"][0]["id"];
    weatherModel = WeatherModel(
      temperatur: weatherData["main"]["temp"],
      feelslike: weatherData["main"]["feels_like"],
      humidity: weatherData["main"]["humidity"],
      wind: weatherData["wind"]["speed"],
      icon:
          "assets/weather-icons/${getIconsPreFix(code)}${kWeatherIcons[code.toString()]!["icon"]}.svg",
      location: weatherData["name"] + ", " + weatherData["sys"]["country"],
      description: weatherData["weather"][0]["description"],
    );
    setState(() {
      isDataLoaded = true;
      isErrorOccurd = false;
    });
  }

  /// LightMode
  ///
  /// With this function user can switch into lightmode.
  void lightSwitch() {
    kOverlayColor = ThemeClass().lightBackgroundColor;
    kIconColor = ThemeClass().lightPrimaryTextColor;
    kMidLightColor = ThemeClass().lightPrimaryTextColor;
    kCardColor = ThemeClass().lightSecondaryTextColor;
    kDarkColor = ThemeClass().lightDetailTextColor;
    kHeadIconColor = ThemeClass().lightIconColor;
  }

  /// DarkMode
  ///
  /// With this function user can switch into darkmode.
  void darkSwitch() {
    kOverlayColor = ThemeClass().darkBackgroundColor;
    kIconColor = ThemeClass().darkPrimeryColor;
    kMidLightColor = ThemeClass().darkPrimaryTextColor;
    kCardColor = ThemeClass().darkSecondaryTextColor;
    kDarkColor = ThemeClass().darkDetailTextColor;
    kHeadIconColor = ThemeClass().darkIconColor;
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return const LoadingWidget();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kOverlayColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: kCardColor,
                        child: SizedBox(
                          height: 60,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    getLocation();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kCardColor,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      left: 5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.refresh,
                                    color: kHeadIconColor,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: kDarkColor,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (iconModeStatus == true) {
                                        iconMode = const Icon(
                                          Icons.light_mode,
                                          color: Color(0xFFFAFAFA),
                                        );
                                        iconModeStatus = false;
                                        lightSwitch();
                                      } else {
                                        iconMode = const Icon(
                                          Icons.nights_stay,
                                          color: Colors.white60,
                                        );
                                        iconModeStatus = true;
                                        darkSwitch();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kCardColor,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      left: 5,
                                    ),
                                  ),
                                  child: iconMode,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          getPremission();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCardColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            children: [
                              Text(
                                "My Location",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kHeadIconColor,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.gps_fixed,
                                color: kHeadIconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isErrorOccurd
                  ? ErrorMessage(title: title!, message: message!)
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                color: kMidLightColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                weatherModel?.location! ?? "no data",
                                style: GoogleFonts.monda(
                                  fontSize: 20,
                                  color: kMidLightColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          SvgPicture.asset(
                            weatherModel!.icon!,
                            height: 280,
                            colorFilter: ColorFilter.mode(
                              kIconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "${weatherModel?.temperatur!.round()}°",
                            style: GoogleFonts.daysOne(
                              fontSize: 80,
                              color: kIconColor,
                            ),
                          ),
                          Text(
                            weatherModel?.description!.toUpperCase() ??
                                "no data",
                            style: GoogleFonts.monda(
                              fontSize: 20,
                              color: kMidLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: kCardColor,
                  child: SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DetailsWidget(
                          text: "${weatherModel?.feelslike!.round()}°",
                          detailText: "FEELS LIKE",
                          color: kHeadIconColor,
                          colorDetail: kDarkColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkColor,
                          ),
                        ),
                        DetailsWidget(
                          text: "${weatherModel?.humidity!}%",
                          detailText: "HUMIDITY",
                          color: kHeadIconColor,
                          colorDetail: kDarkColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkColor,
                          ),
                        ),
                        DetailsWidget(
                          text: "${weatherModel?.wind!.round()}",
                          detailText: "WIND",
                          color: kHeadIconColor,
                          colorDetail: kDarkColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
