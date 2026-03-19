class FlightSearchParams {
  const FlightSearchParams({
    required this.departureIata,
    required this.arrivalIata,
    this.date,
    this.limit = 20,
    this.offset = 0,
  });

  final String departureIata;
  final String arrivalIata;
  final DateTime? date;
  final int limit;
  final int offset;

  FlightSearchParams copyWith({
    String? departureIata,
    String? arrivalIata,
    DateTime? date,
    int? limit,
    int? offset,
  }) {
    return FlightSearchParams(
      departureIata: departureIata ?? this.departureIata,
      arrivalIata: arrivalIata ?? this.arrivalIata,
      date: date ?? this.date,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  FlightSearchParams nextPage() => copyWith(offset: offset + limit);
}
