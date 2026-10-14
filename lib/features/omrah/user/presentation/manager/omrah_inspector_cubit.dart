import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/features/omrah/user/data/repo/omrah_inspector_repo.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/socket/omrah_socket.dart';

part 'omrah_inspector_state.dart';

class OmrahInspectorCubit extends Cubit<OmrahInspectorState> {
  late final OmrahInspectorRepo _repo;
  final String orderId;

  OmrahInspectorCubit(this.orderId) : super(const OmrahInspectorState.initial()){
    _repo = injector();
  }

  void getOmrahStepsStatus() async {
    if(state.currentStep.isLoading){
      return;
    }

    emit(state.copyWith(currentStep: StateBox.loading()));

    await collect(
      task: () async {
        final omrahStepsData = await _repo.getRitualSteps(orderId);

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


}
