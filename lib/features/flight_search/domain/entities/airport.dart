class Airport {
  const Airport({
    required this.iataCode,
    required this.airportName,
    this.cityName,
    this.countryName,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      iataCode: (json['iata_code'] as String?) ?? '',
      airportName: (json['airport_name'] as String?) ?? '',
      cityName: json['city_iata_code'] as String?,
      countryName: json['country_name'] as String?,
    );
  }

  final String iataCode;
  final String airportName;
  final String? cityName;
  final String? countryName;

  @override
  String toString() => '$airportName ($iataCode)';
}
