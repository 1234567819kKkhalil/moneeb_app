import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_proof_input.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/provider/domain/repo/omrah_repository.dart';
import 'package:photo_manager/photo_manager.dart';

part 'provider_omrah_state.dart';

class ProviderOmrahCubit extends Cubit<ProviderOmrahState> {
  late final OmrahRepository _omrahRepository;
  late final UploadAttachmentUseCase _uploadAttachmentUseCase;
  final String orderId;
  final ForWhomEntity forWhom;

  /// The rituals cannot be started before this day.
  final DateTime? targetDate;
  ProviderOmrahCubit({required this.orderId, required this.forWhom, this.targetDate}) : super(const ProviderOmrahState.initial()){
    _omrahRepository = injector();
    _uploadAttachmentUseCase = injector();
  }

  void getOmrahStepsStatus() async {
    emit(state.copyWith(currentStep: StateBox.loading()));

    await collect(
      task: () async {
        final omrahStepsData = await _omrahRepository.getRitualSteps(orderId);

        emit(state.copyWith(
          omrahStepsData: StateBox.success(omrahStepsData),
          currentStep: StateBox.success(_getCurrentStep(omrahStepsData)))
        );
      },
      onError: (failure) {
        emit(state.copyWith(currentStep: StateBox.failure(failure)));
      },
    );
  }

  OmrahStepsEnum _getCurrentStep(List<OmrahStepEntity>  omrahStepsData){
    return omrahStepsData.getCurrentStep();
  }
  
  void submitStepProof(OmrahStepsEnum stepType, Attachment attachment) async {
    emit(state.copyWith(submitProof: StateBox.loading()));

    await collect(
      task: () async {
        final upload = await _uploadAttachmentUseCase.execute(
          input: [attachment],
          directory: UploadDirectory.ritualProofs
        );

        final uploadedProof = upload.firstOrNull ?? Attachment.empty();

        await _omrahRepository.submitStepProof(
          orderId: orderId,
          step: stepType,
          proof: OmrahProofInput.fromAttachment(
            attachment: uploadedProof
          )
        );

        final newOmrahStepsData = (state.omrahStepsData.data ?? []).map((e) {
            if(e.stepType == stepType) {
              return e.copyWith(
                status: OmrahStepStatusEnum.proofUploaded,
                proofVideoUrl: uploadedProof.type == AttachmentTypeEnum.video
                   ? uploadedProof.url
                   : null,
                clearRejectionReason: true,
              );
            }

            return e;
          }).toList();


        emit(state.copyWith(
          submitProof: StateBox.successWithoutData(),
          currentStep: StateBox.success(_getCurrentStep(newOmrahStepsData)),
          omrahStepsData: StateBox.success(newOmrahStepsData)
        ));
      },
      onError: (failure) {
        emit(state.copyWith(submitProof: StateBox.failure(failure)));
      },
    );

    emit(state.copyWith(submitProof: StateBox.initial()));
  }

  void validateMiqat() async {
    emit(state.copyWith(validateMapLocation: StateBox.loading()));

    await collect(
      task: () async {
        // The backend is the authority on the date; this only spares the
        // provider a pointless round trip.
        final startDate = OmrahSchedule.startOf(targetDate);
        if(!OmrahSchedule.hasStarted(targetDate) && startDate != null){
          throw UnExpectedFailure(appLocalizer.omrahNotStartedYet(startDate.toDDMMMyyyy));
        }

        final currentPos = await LocationService.instance.getCurrentLocation();

        final ({bool isValid, String miqatName}) miqatValidationData = await _omrahRepository.validateMiqat(
          orderId: orderId,
          latLng: LatLng(latitude: currentPos.latitude, longitude: currentPos.longitude)
        );

        if(!miqatValidationData.isValid){
          throw UnExpectedFailure(appLocalizer.locationNotValidForMiqat);
        }

        final newOmrahStepsData = (state.omrahStepsData.data ?? []).map((e) {
          if(e.stepType == OmrahStepsEnum.mekat) {
            return e.copyWith(
              isMapLocationProofed: miqatValidationData.isValid,
            );
          }
          return e;
        }).toList();

        emit(state.copyWith(
          validateMapLocation: StateBox.success(miqatValidationData.isValid),
          omrahStepsData: StateBox.success(newOmrahStepsData),
          miqatName: miqatValidationData.miqatName,
        ));
      },
      onError: (failure) {
        emit(state.copyWith(validateMapLocation: StateBox.failure(failure)));
      },
    );

    emit(state.copyWith(validateMapLocation: StateBox.initial()));
  }

  void validateTawaf() async {
    emit(state.copyWith(validateMapLocation: StateBox.loading()));

    await collect(
      task: () async {
        final currentPos = await LocationService.instance.getCurrentLocation();

        final bool isValid = await _omrahRepository.validateTawaf(
          orderId: orderId,
          latLng: LatLng(latitude: currentPos.latitude, longitude: currentPos.longitude)
        );

        if(!isValid){
          throw UnExpectedFailure(appLocalizer.locationNotValidForTawaf);
        }

        final newOmrahStepsData = (state.omrahStepsData.data ?? []).map((e) {
          if(e.stepType == OmrahStepsEnum.tawaf) {
            return e.copyWith(
              isMapLocationProofed: isValid
            );
          }
          return e;
        }).toList();

        emit(state.copyWith(
          validateMapLocation: StateBox.success(isValid),
          omrahStepsData: StateBox.success(newOmrahStepsData)
        ));
      },
      onError: (failure) {
        emit(state.copyWith(validateMapLocation: StateBox.failure(failure)));
      },
    );

    emit(state.copyWith(validateMapLocation: StateBox.initial()));
  }

  void validateSai() async {
    emit(state.copyWith(validateMapLocation: StateBox.loading()));

    await collect(
      task: () async {
        final currentPos = await LocationService.instance.getCurrentLocation();

        final bool isValid = await _omrahRepository.validateSai(
          orderId: orderId,
          latLng: LatLng(latitude: currentPos.latitude, longitude: currentPos.longitude)
        );

        if(!isValid){
          throw UnExpectedFailure(appLocalizer.locationNotValidForSai);
        }

        final newOmrahStepsData = (state.omrahStepsData.data ?? []).map((e) {
          if(e.stepType == OmrahStepsEnum.safa_and_marwa) {
            return e.copyWith(
              isMapLocationProofed: isValid
            );
          }
          return e;
        }).toList();

        emit(state.copyWith(
          validateMapLocation: StateBox.success(isValid),
          omrahStepsData: StateBox.success(newOmrahStepsData)
        ));
      },
      onError: (failure) {
        emit(state.copyWith(validateMapLocation: StateBox.failure(failure)));
      },
    );

    emit(state.copyWith(validateMapLocation: StateBox.initial()));
  }

}
