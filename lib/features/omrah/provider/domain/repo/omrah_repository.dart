import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/omrah/omrah_proof_input.dart';

abstract class OmrahRepository {
  Future<List<OmrahStepEntity>> getRitualSteps(String orderId);

  Future<void> submitStepProof({
    required String orderId,
    required OmrahStepsEnum step,
    required OmrahProofInput proof,
  });

  Future<({bool isValid, String miqatName})> validateMiqat({
    required String orderId,
    required LatLng latLng
  });

  Future<void> validateStepGps({
    required String orderId,
    required OmrahStepsEnum step,
  });

  // Future<TrackingPathModel> getTrackingPath(String orderId);
  //
  Future<bool> validateTawaf({
    required String orderId,
    required LatLng latLng
  });

  /// The Mas'a (Safa <-> Marwa) lies inside Al-Masjid al-Haram, so the sai step
  /// is validated against the same Haram geofence tawaf uses.
  Future<bool> validateSai({
    required String orderId,
    required LatLng latLng
  });
}
