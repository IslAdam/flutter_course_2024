import 'dart:convert';

import 'package:practice_1/features/core/data/debug/weather_repository_debug.dart';
import 'package:practice_1/features/core/data/osm/osm_api.dart';
import 'package:practice_1/features/core/data/osm/weather_repository_osm.dart';
import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/presentation/app.dart';
import 'package:http/http.dart' as http;


void main(List<String> arguments) async {
  //double lat = 55.75;
  //double lon = 37.61;
  double lat = 42.96;
  double lon = 47.51;
  var response = await http.get(Uri.parse('http://api.weatherapi.com/v1/current.json?key=5369c50629664ed2918234108240812&q=moscow'));
  var rJson = jsonDecode(response.body);

  print(rJson['current']['temp_c']);
  print(rJson['current']['condition']['text']);
  //print(response.body);
}
