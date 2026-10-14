import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/features/omrah/user/data/repo/omrah_inspector_repo.dart';

part 'add_omrah_review_state.dart';

class AddOmrahReviewCubit extends Cubit<AddOmrahReviewState> {
  late final OmrahInspectorRepo _repo;
  final String orderId;

  AddOmrahReviewCubit(this.orderId) : super(const AddOmrahReviewState.initial()) {
    _repo = injector();
  }

  void addReview({required double score, required String comment}) async {
    if (state.reviewState.isLoading) return;

    emit(state.copyWith(reviewState: StateBox.loading()));

    await collect(
      task: () async {
        await _repo.addReview(orderId, score: score, comment: comment);
        emit(state.copyWith(reviewState: StateBox.success(null)));
      },
      onError: (failure) {
        emit(state.copyWith(reviewState: StateBox.failure(failure)));
      },
    );
  }
}
