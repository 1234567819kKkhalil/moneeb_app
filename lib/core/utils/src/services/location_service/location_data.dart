part of app_utils;

/// Persisted location object holding the four cached values
/// (latitude, longitude, city, country) as a single JSON string.
class LocationData extends Equatable {
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;

  const LocationData({
    this.latitude,
    this.longitude,
    this.city,
    this.country,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        city: json['city'] as String?,
        country: json['country'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'country': country,
      };

  /// Human readable "City, Country" label, skipping any empty part.
  /// Returns null when neither a city nor a country is available.
  String? get label {
    final parts = [city, country]
        .where((part) => part != null && part.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [latitude, longitude, city, country];
}
