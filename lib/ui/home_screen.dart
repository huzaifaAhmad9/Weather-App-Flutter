import 'package:design/bloc/weather/weather_state.dart';
import 'package:design/bloc/weather/weater_event.dart';
import 'package:design/bloc/weather/weather_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design/model/weather.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.pinkAccent),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: const BoxDecoration(color: Colors.lightBlue),
              ),
            ),
            // for blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    '⛅ Weather App',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            iconColor: Colors.white,
                            focusColor: Colors.white,
                            labelText: 'Enter City',
                            labelStyle: const TextStyle(color: Colors.white),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                final cityName = _controller.text.trim();
                                if (cityName.isNotEmpty) {
                                  context
                                      .read<WeatherBloc>()
                                      .add(FetchWeather(cityName));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please enter a city name.')),
                                  );
                                }
                              },
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (cityName) {
                            final trimmedCityName = cityName.trim();
                            if (trimmedCityName.isNotEmpty) {
                              context
                                  .read<WeatherBloc>()
                                  .add(FetchWeather(trimmedCityName));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a city name.')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        if (state is WeatherLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is WeatherLoaded) {
                          return WeatherInfo(weather: state.weather);
                        } else if (state is WeatherError) {
                          return Center(child: Text(state.message));
                        }
                        return const Center(
                            child: Text(
                          'Search for a city!',
                          style: TextStyle(color: Colors.white),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final Weather weather;

  const WeatherInfo({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
              child: Image.asset(
            'assets/images/5.png',
            scale: 3,
          )),
          Center(
            child: Text(
              '🌡️${weather.temperature} °C',
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Center(
              child: Text(
                weather.description.toUpperCase(),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/9.png',
                    scale: 8,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text(
                        'Wind Speed',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      Center(
                          child: Text(
                        '${weather.windSpeed} m/s',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 13),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/8.png',
                      scale: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                            child: Text(
                          'Humidity',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        )),
                        const SizedBox(
                          height: 3,
                        ),
                        Center(
                            child: Text(
                          '${weather.humidity}%',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(
              color: Colors.grey.withOpacity(.5),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/14.png',
                    scale: 8,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text(
                        'Temp Min',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      Center(
                          child: Text(
                        '${weather.minTemp}°C',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/11.png',
                    scale: 8,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text(
                        'Temp Max',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      Center(
                          child: Text(
                        '${weather.maxtemp}°C',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    ],
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(
              color: Colors.grey.withOpacity(.5),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/13.png',
                    scale: 8,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                          child: Text(
                        'Pressure',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      )),
                      const SizedBox(
                        height: 3,
                      ),
                      Center(
                          child: Text(
                        '${weather.pressure}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
