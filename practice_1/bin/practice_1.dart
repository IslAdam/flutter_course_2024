import 'package:practice_1/features/core/data/debug/weather_repository_debug.dart';
import 'package:practice_1/features/core/data/om/om_api.dart';
import 'package:practice_1/features/core/data/om/weather_repository_om.dart';
import 'package:practice_1/features/core/data/osm/osm_api.dart';
import 'package:practice_1/features/core/data/osm/weather_repository_osm.dart';
import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/presentation/app.dart';

const String version = '0.0.1';
const String urlOSM = 'https://api.openweathermap.org';
const String apiKeyOSM = '';

const String urlOM = 'http://api.weatherapi.com';
const String apiKeyOM = '';


void main(List<String> arguments) {
  var app = App(WeatherRepositoryOM(OMApi(urlOM, apiKeyOM)));

  app.run();
}
