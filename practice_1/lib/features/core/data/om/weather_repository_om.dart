import 'package:practice_1/features/core/data/om/om_api.dart';
import 'package:practice_1/features/core/domain/entities/search_query.dart';
import 'package:practice_1/features/core/domain/entities/search_response.dart';
import 'package:practice_1/features/core/domain/repositories/weather_repository.dart';

class WeatherRepositoryOM implements WeatherRepository {
  final OMApi _api;

  WeatherRepositoryOM(this._api);

  @override
  Future<SearchResponse> getWeather(SearchQuery query) async {
    var response = await _api.getWeather(query.city);
    return SearchResponse(response.temp.toInt()+273, _weatherType(response.type));
  }
}

WeatherType _weatherType(String type) {
  switch (type) {
    case 'cloudy':
      return WeatherType.cloudy;
    case 'clear':
      return WeatherType.clear;
    case 'rain':
      return WeatherType.rain;
    default:
      return WeatherType.other;
  }
}