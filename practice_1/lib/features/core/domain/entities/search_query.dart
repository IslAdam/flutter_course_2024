sealed class SearchQuery {}

class SearchQueryCity extends SearchQuery{
  final String city;

  SearchQueryCity(this.city);
}

class SearchQueryCoord extends SearchQuery{
  final double x;
  final double y;

  SearchQueryCoord(this.x, this.y);
}