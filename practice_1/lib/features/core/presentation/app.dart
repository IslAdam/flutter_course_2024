import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/domain/repositories/weather_repository.dart';
import 'dart:io';

class App {
  final WeatherRepository repository;

  App(this.repository);

  void run() async {
    print('Введите город или координаты через пробел:');
    var input = stdin.readLineSync();

    if (input == null) {
      print('Ошибка ввода');
      return;
    }

    if (input.contains(' ')) {
      var parts = input.split(' ');
      var x = double.parse(parts[0]);
      var y = double.parse(parts[1]);
      var resp = await repository.getWeather(SearchQueryCoord(x,y));
      print('Погода в городе $input: ${resp.temp-273} по Цельсию, тип: ${resp.type}');

    } else {
      var resp = await repository.getWeather(SearchQueryCity(input));
      print('Погода в городе $input: ${resp.temp-273} по Цельсию, тип: ${resp.type}');

    }
  }
}