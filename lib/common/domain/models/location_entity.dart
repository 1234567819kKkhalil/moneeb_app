import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable{
  final String? lat;
  final String? long;
  const LocationEntity({required this.lat, this.long});

  @override
  List<Object?> get props => [lat, long];
}
