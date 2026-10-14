import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/my_reviews/my_reviews_imports.dart';

part 'omrah_review_status_state.dart';

/// Answers whether the current user has already rated the omrah of [orderId].
///
/// An omrah is rated once and only once, so the conclusion page asks this
/// cubit before it offers the rating sheet.
///
/// Two sources, in this order:
/// * `reviews/me`, the only server source that ties a review back to an order,
///   narrowed to the review this user wrote for this order. It is the truth,
///   and it survives a reinstall or a switch of device.
/// * a flag persisted on this device when the rating was submitted, which
///   answers instantly on a cold start and still answers with no connection.
///
/// The flag is never treated as a rating the server does not have — it only
/// fills the gap until (or when) `reviews/me` answers.
class OmrahReviewStatusCubit extends Cubit<OmrahReviewStatusState> {
  late final MyReviewsRepository _repo;
  late final SharedPreferencesHelper _preferences;

  final String orderId;

  /// Current user id, so the provider's review of the same order is not
  /// mistaken for the user's own. Null when the caller has no user at hand,
  /// in which case the order match alone decides.
  final String? currentUserId;

  OmrahReviewStatusCubit({
    required this.orderId,
    this.currentUserId,
  }) : super(const OmrahReviewStatusState.initial()) {
    _repo = injector();
    _preferences = injector();
  }

  /// Resolves the rating state of this omrah: the persisted answer first so a
  /// cold start never invites a second rating, then the server's.
  Future<void> loadMyReview() async {
    if (state.myReview.isLoading) return;

    final ratedOnThisDevice = _preferences.isOmrahRated(orderId);

    emit(state.copyWith(
      myReview: const StateBox.loading(),
      isRatedLocally: ratedOnThisDevice,
    ));

    await collect(
      task: () async {
        final reviews = await _repo.getMyReviews();

        emit(state.copyWith(myReview: StateBox.success(_mineFor(reviews))));
      },
      onError: (failure) {
        emit(state.copyWith(myReview: StateBox.failure(failure)));
      },
    );
  }

  /// Records the rating the moment the server accepts it: on this device, so a
  /// restart still knows, and in state, so the page moves to its rated view
  /// without a second round trip.
  void onReviewSubmitted({required double score, required String comment}) {
    _preferences.saveRatedOmrah(orderId);

    emit(state.copyWith(
      isRatedLocally: true,
      myReview: StateBox.success(
        MyReviewEntity(
          id: '',
          orderId: orderId,
          providerId: '',
          requesterId: currentUserId ?? '',
          score: score.round(),
          comment: comment,
          isHidden: false,
          createdAt: DateTime.now(),
          counterpartyName: '',
          counterpartyAvatarUrl: '',
        ),
      ),
    ));
  }

  MyReviewEntity? _mineFor(List<MyReviewEntity> reviews) {
    final review = reviews.firstWhereOrNull((review) {
      if (review.orderId != orderId) return false;

      // When either id is missing, keep the order match rather than drop a
      // review that is almost certainly the user's own.
      final userId = currentUserId ?? '';
      if (userId.isEmpty || review.requesterId.isEmpty) return true;

      return review.requesterId == userId;
    });

    // A rating submitted from another device counts here too, so mirror the
    // server's answer onto this one.
    if (review != null) _preferences.saveRatedOmrah(orderId);

    return review;
  }
}
