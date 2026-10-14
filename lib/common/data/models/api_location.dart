import 'package:moneeb/common/domain/models/location_entity.dart';

class ApiLocationModel{
  final String? latitude;
  final String? longitude;
  const ApiLocationModel({required this.latitude, this.longitude});

  factory ApiLocationModel.fromJson(Map<String, dynamic> json){
    //خلي بالك لو هتخليها double فيه بعض الريكويستات بيرجع فيها String, ربنا يصلح الحال
    return ApiLocationModel(
      latitude: json["latitude"]?.toString(),
      longitude: json["longitude"]?.toString(),
    );
  }

  LocationEntity toEntity(){
    return LocationEntity(
      lat: latitude,
      long: longitude,
    );
  }
}
