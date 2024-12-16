import 'package:design/repository/weather_repository.dart';
import 'package:design/bloc/weather/weather_state.dart';
import 'package:design/bloc/weather/weater_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final cityId = await weatherRepository.fetchCityId(event.cityName);
        final weather = await weatherRepository.fetchWeather(cityId);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Could not fetch weather.'));
      }
    });
  }
}
