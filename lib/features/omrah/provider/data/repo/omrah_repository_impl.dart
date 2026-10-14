import 'package:injectable/injectable.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../domain/models/omrah/omrah_proof_input.dart';
import '../../domain/repo/omrah_repository.dart';
import '../../../common/data/endpoints/omrah_endpoint.dart';

@LazySingleton(as: OmrahRepository)
class OmrahRepositoryImpl implements OmrahRepository {
  final DioHelper _dioHelper;

  OmrahRepositoryImpl(this._dioHelper);

  @override
  Future<List<OmrahStepEntity>> getRitualSteps(String orderId) async {
    final response = await _dioHelper.get(
      OmrahEndpoint.omrahSteps(orderId),
    );

    final ritualSteps = ((response.data['data'] as List?)??[])
      .map((item) => OmrahStepEntity.fromJson(item))
      .toList();
    return ritualSteps;
  }

  @override
  Future<void> submitStepProof({
    required String orderId,
    required OmrahStepsEnum step,
    required OmrahProofInput proof,
  }) async {
    await _dioHelper.post(
      OmrahEndpoint.submitProof(orderId, step.toApi()),
      data: proof.toJson(),
    );
  }

  @override
  Future<({bool isValid, String miqatName})> validateMiqat({
    required String orderId,
    required LatLng latLng
  }) async {
    final results = await _dioHelper.post(
      OmrahEndpoint.validateMiqat(orderId),
      data: {
        "lat" : latLng.latitude,
        "lng" : latLng.longitude
      },
    );

    final bool isValid = results.data?['data']?["valid"] ?? false;

    // "name" is the step label ("الميقات (الإحرام)"); the miqat the provider was
    // actually matched to comes back in "zoneName" ("قرن المنازل").
    final String miqatName = results.data?['data']?["zoneName"] ?? '';

    return (
      isValid: isValid,
      miqatName: miqatName
    );
  }

  // @override
  // Future<TrackingPathModel> getTrackingPath(String orderId) async {
  //   final response = await _dioHelper.get(
  //     OmrahEndpoint.trackingPath(orderId),
  //   );
  //
  //   if (response.data != null && response.data['data'] != null) {
  //     return TrackingPathModel.fromJson(response.data['data']);
  //   }
  //   return TrackingPathModel(orderId: orderId, points: []);
  // }



  @override
  Future<bool> validateTawaf({
    required String orderId,
    required LatLng latLng
  }) async {
    final results = await _dioHelper.post(
      OmrahEndpoint.validateTawaf(orderId),
      data: {
        "lat" : latLng.latitude,
        "lng" : latLng.longitude
      },
    );

    return results.data?['data']?["valid"] ?? false;
  }

  @override
  Future<void> validateStepGps({
    required String orderId,
    required OmrahStepsEnum step,
  }) async {
    await _dioHelper.post(
      OmrahEndpoint.validateStep(orderId, step.toApi()),
      data: null,
    );
  }

  @override
  Future<bool> validateSai({
    required String orderId,
    required LatLng latLng
  }) async {
    // The Mas'a is inside Al-Masjid al-Haram, so the sai step reuses the
    // Haram geofence endpoint until the backend exposes a dedicated one.
    return validateTawaf(orderId: orderId, latLng: latLng);
  }
}
