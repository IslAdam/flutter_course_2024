import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:practice_1/features/core/data/om/models/om_weather.dart';


class OMApi{
  final String url;
  final String apiKey;

  OMApi(this.url, this.apiKey);

  Future<OMWeather> getWeather(String city) async {
    var response = await http.get(Uri.parse('$url/v1/current.json?key=$apiKey&q=$city'));
    var rJson = jsonDecode(response.body);

    return OMWeather(rJson['current']['temp_c'], rJson['current']['condition']['text']);
  }
}