part of home;

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final GetHomeFeedUseCase _getHomeFeedUseCase;
  final GetStoryProvidersUseCase _getStoryProvidersUseCase;
  final GetBestProvidersUseCase _getBestProvidersUseCase;
  final GetVerifiedProvidersUseCase _getVerifiedProvidersUseCase;
  final UserOrdersRepository _userOrdersRepository;
  final ProviderOrdersRepository _providerOrdersRepository;
  final OmrahRepository _omrahRepository;
  final GetBannersUseCase _getBannersUseCase;
  final GetStreamsUseCase _getStreamsUseCase;
  final SharedPreferencesHelper _prefsHelper;

  HomeCubit(
    this._getHomeFeedUseCase,
    this._getStoryProvidersUseCase,
    this._getBestProvidersUseCase,
    this._getVerifiedProvidersUseCase,
    this._userOrdersRepository,
    this._providerOrdersRepository,
    this._omrahRepository,
    this._getBannersUseCase,
    this._getStreamsUseCase,
    this._prefsHelper,
  ) : super(
        HomeState(
          listStage: [
            Stage(imageUrl: AssetPaths.ihramStage, name: appLocalizer.ihram),
            Stage(
              imageUrl: 'https://i.postimg.cc/0jWnKHLy/live1.jpg',
              name: appLocalizer.tawaf,
            ),
            // TODO(User): makam step is disabled for now, uncomment when needed.
            // Stage(
            //   imageUrl: "https://i.postimg.cc/507XzVk3/image-splash.jpg",
            //   name: appLocalizer.prayerBehindMakam,
            // ),
            Stage(
              imageUrl: AssetPaths.saiStage,
              name: appLocalizer.saiMinimized,
            ),
            Stage(
              imageUrl: AssetPaths.tahalolStage,
              name: appLocalizer.tahalol,
            ),
          ],
        ),
      );

  bool _isGuest = false;
  bool _isProvider = false;

  void init(BuildContext context) {
    final userRole = context.read<AuthenticationBloc>().getUserRole;
    _isGuest = userRole == UserRoleEnum.guest;
    _isProvider = userRole == UserRoleEnum.provider;

    fetchHomeFeed();
    fetchStories();
    fetchBanners();
    fetchBestProviders();
    fetchVerifiedProviders();
    fetchStreams();

    if (!_isGuest) {
      fetchActiveOmrah();
      fetchUpcomingOmrah();
    }
  }

  LocationEntity? _currentLocation;

  Future<void> fetchStories() async {
    emit(state.copyWith(storiesData: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getStoryProvidersUseCase.execute();

        final dataList = data.map((e) => e as StoryProviderModel).toList();

        // For guests the server always returns isViewed=false (no session).
        // Apply locally cached guest-viewed story IDs only for guest sessions —
        // for authenticated users the server is the source of truth.
        List<StoryProviderEntity> resolvedList = dataList;
        if (_isGuest) {
          final guestViewed = _prefsHelper.getGuestViewedStoryIds();
          if (guestViewed.isNotEmpty) {
            resolvedList = dataList.map((provider) {
              return guestViewed.contains(provider.storyId)
                  ? provider.copyWith(hasUnviewed: false)
                  : provider;
            }).toList();
          }
        }

        emit(state.copyWith(storiesData: StateBox.success(resolvedList)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(storiesData: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchBanners() async {
    emit(state.copyWith(banners: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getBannersUseCase.execute();
        emit(state.copyWith(banners: StateBox.success(data)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(banners: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchStreams() async {
    emit(state.copyWith(streams: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getStreamsUseCase.execute();
        emit(state.copyWith(streams: StateBox.success(data)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(streams: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchHomeFeed() async {
    emit(state.copyWith(feedData: const StateBox.loading()));

    await LocationService.instance.initLocation();
    await _setLocation();

    log(_currentLocation?.lat.toString() ?? "");
    log(_currentLocation?.long.toString() ?? "");
    await collect(
      task: () async {
        final data = await _getHomeFeedUseCase.execute(
          lat: (_currentLocation?.lat ?? kaabaLatitude).toString(),
          lng: (_currentLocation?.long ?? kaabaLongitude).toString(),
        );
        emit(state.copyWith(feedData: StateBox.success(data)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(feedData: StateBox.failure(failure)));
      },
    );
  }

  void markProviderStoriesAsSeen(String providerId) {
    if (state.storiesData.data == null) return;

    final newList = state.storiesData.data!.map((provider) {
      if (provider.providerId == providerId) {
        return provider.copyWith(hasUnviewed: false);
      }
      return provider;
    }).toList();

    emit(state.copyWith(storiesData: StateBox.success(newList)));
  }

  Future<void> fetchBestProviders() async {
    emit(state.copyWith(bestProviders: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getBestProvidersUseCase.execute();
        emit(state.copyWith(bestProviders: StateBox.success(data)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(bestProviders: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchVerifiedProviders() async {
    emit(state.copyWith(verifiedProviders: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getVerifiedProvidersUseCase.execute();
        emit(state.copyWith(verifiedProviders: StateBox.success(data)));
        return data;
      },
      onError: (failure) {
        emit(state.copyWith(verifiedProviders: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchActiveOmrah() async {
    emit(state.copyWith(activeOmrah: const StateBox.loading()));

    await collect(
      task: () async {
        final activeOrders = _isProvider
            ? (await _providerOrdersRepository.getProviderOrders(
                status: ProviderOrderStatus.inProgress,
              )).items.map(
                (order) => (
                  id: order.id,
                  beneficiaryType: order.beneficiaryType,
                  beneficiaryName: order.beneficiaryName,
                  targetDate: order.targetDate,
                ),
              )
            : (await _userOrdersRepository.getUserOrders(
                status: UserOrderStatus.inProgress,
              )).items.map(
                (order) => (
                  id: order.id,
                  beneficiaryType: order.beneficiaryType,
                  beneficiaryName: order.beneficiaryName,
                  targetDate: order.targetDate,
                ),
              );

        if (activeOrders.isEmpty) {
          emit(state.copyWith(activeOmrah: StateBox.initial()));
        } else {
          final List<OmrahStepperEntity> omrahSteps = [];

          for (var order in activeOrders) {
            final ritualSteps = await _omrahRepository.getRitualSteps(order.id);

            omrahSteps.add(
              OmrahStepperEntity(
                currentStep: ritualSteps.getCurrentStep(),
                orderId: order.id,
                forWhom: ForWhomEntity(
                  beneficiaryType: order.beneficiaryType,
                  beneficiaryName: order.beneficiaryName,
                ),
                targetDate: order.targetDate,
              ),
            );
          }

          emit(state.copyWith(activeOmrah: StateBox.success(omrahSteps)));
        }
      },
      onError: (failure) {
        emit(state.copyWith(activeOmrah: StateBox.failure(failure)));
      },
    );
  }

  /// Accepted orders still waiting for their day, nearest first. Refreshes
  /// silently once loaded so the card does not flicker when the tab is reopened.
  Future<void> fetchUpcomingOmrah() async {
    if (_isGuest) return;

    if (!state.upcomingOmrah.isSuccess) {
      emit(state.copyWith(upcomingOmrah: const StateBox.loading()));
    }

    await collect(
      task: () async {
        final List<UpcomingOmrahEntity> upcoming = _isProvider
            ? (await _providerOrdersRepository.getProviderOrders(
                status: ProviderOrderStatus.accepted,
              )).items.map(
                (order) => UpcomingOmrahEntity(
                  orderId: order.id,
                  beneficiaryName: order.beneficiaryName,
                  targetDate: order.targetDate,
                ),
              ).toList()
            : (await _userOrdersRepository.getUserOrders(
                status: UserOrderStatus.accepted,
              )).items.map(
                (order) => UpcomingOmrahEntity(
                  orderId: order.id,
                  beneficiaryName: order.beneficiaryName,
                  targetDate: order.targetDate,
                ),
              ).toList();

        // Orders without a date sort last: there is nothing to count down to.
        upcoming.sort((a, b) {
          final aStart = OmrahSchedule.startOf(a.targetDate);
          final bStart = OmrahSchedule.startOf(b.targetDate);
          if (aStart == null || bStart == null) {
            return aStart == null ? (bStart == null ? 0 : 1) : -1;
          }
          return aStart.compareTo(bStart);
        });

        emit(state.copyWith(upcomingOmrah: StateBox.success(upcoming)));
      },
      onError: (failure) {
        emit(state.copyWith(upcomingOmrah: StateBox.failure(failure)));
      },
    );
  }

  Future<void> _setLocation() async {
    final latLong = await LocationService.instance.getLatLng;

    if (latLong != null) {
      _currentLocation = LocationEntity(
        lat: latLong.latitude.toString(),
        long: latLong.longitude.toString(),
      );
    }
  }

  void modifyOmrahCompleted(String orderId) {
    final List<OmrahStepperEntity> omrahSteps = List.from(
      state.activeOmrah.data ?? [],
    );

    if (omrahSteps.isNotEmpty) {
      omrahSteps.removeWhere((element) => element.orderId == orderId);
      emit(state.copyWith(activeOmrah: StateBox.success(omrahSteps)));
    }
  }

  void modifyOmrahStepChanged(OmrahStepperEntity stepper) {
    final List<OmrahStepperEntity> omrahSteps = state.activeOmrah.data ?? [];

    if (omrahSteps.isNotEmpty) {
      final List<OmrahStepperEntity> newList = omrahSteps.map((element) {
        if (element.orderId == stepper.orderId) {
          return element.copyWith(currentStep: stepper.currentStep);
        }

        return element;
      }).toList();

      emit(state.copyWith(activeOmrah: StateBox.success(newList)));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
